// Streams tokens from phi-3-mini.gguf using llama.cpp Metal path on A-series GPUs.
// Relocated to Sources/Bridges for SwiftPM compilation.

#import "LLMBridge.h"
#import <Foundation/Foundation.h>
#import "../../Vendor/llama.cpp/include/llama.h"
#import "../../Vendor/llama.cpp/ggml/include/ggml.h"
#include <vector>
#include <string>

@implementation LLMBridge {
#ifndef LLM_STUB
    struct llama_model   *model;
    struct llama_context *ctx;
#endif
    dispatch_queue_t queue;
}

- (instancetype)initWithModelAt:(NSString *)path {
    self = [super init];
    if (self) {
#ifndef LLM_STUB
        llama_backend_init();
        struct llama_model_params mparams = llama_model_default_params();
        mparams.progress_callback = NULL;
        model = llama_model_load_from_file(path.UTF8String, mparams);

        struct llama_context_params cparams = llama_context_default_params();
        cparams.n_ctx = 2048;
        ctx = llama_init_from_model(model, cparams);
#endif
        queue = dispatch_queue_create("ai.formavoice.llm", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    }
    return self;
}

- (void)dealloc {
#ifndef LLM_STUB
    llama_free(ctx);
    llama_model_free(model);
    llama_backend_free();
#endif
}

- (void)runPrompt:(NSString *)prompt
    tokenCallback:(void (^)(NSString *token))cb
       completion:(void (^)(NSString *full))done {

    dispatch_async(queue, ^{
        // Convert NSString → std::string
        std::string promptStr([[prompt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] UTF8String]);

        // Access the vocabulary
        const struct llama_vocab * vocab = llama_model_get_vocab(model);

        // Tokenize to find required buffer size (negative return is size)
        const int nPrompt = -llama_tokenize(vocab,
                                            promptStr.c_str(),
                                            (int)promptStr.size(),
                                            /*tokens*/ nullptr,
                                            /*n_tokens_max*/ 0,
                                            /*add_special*/ true,
                                            /*parse_special*/ true);

        if (nPrompt <= 0) {
            if (done) done(@"Tokenizer error");
            return;
        }

        std::vector<llama_token> promptTokens(nPrompt);
        llama_tokenize(vocab,
                       promptStr.c_str(),
                       (int)promptStr.size(),
                       promptTokens.data(),
                       (int)promptTokens.size(),
                       /*add_special*/ true,
                       /*parse_special*/ true);

        // Evaluate the prompt in a single batch.
        llama_batch batch = llama_batch_get_one(promptTokens.data(), (int32_t)promptTokens.size());
        if (llama_decode(ctx, batch) != 0) {
            if (done) done(@"llama_decode failed");
            return;
        }

        // Create a greedy sampler chain
        struct llama_sampler_chain_params sp = llama_sampler_chain_default_params();
        struct llama_sampler * sampler = llama_sampler_chain_init(sp);
        llama_sampler_chain_add(sampler, llama_sampler_init_greedy());

        NSMutableString *full = [NSMutableString string];

        const int maxTokens = 256;
        for (int i = 0; i < maxTokens; ++i) {
            llama_token id = llama_sampler_sample(sampler, ctx, -1);

            // End-of-generation?
            if (llama_vocab_is_eog(vocab, id)) {
                break;
            }

            char buf[128];
            int n = llama_token_to_piece(vocab, id, buf, sizeof(buf), 0, /*special*/ true);
            if (n < 0) { continue; }
            std::string piece(buf, n);
            NSString *tokenStr = [NSString stringWithUTF8String:piece.c_str()];

            // Emit to Swift on main thread
            if (cb) {
                dispatch_async(dispatch_get_main_queue(), ^{ cb(tokenStr); });
            }
            [full appendString:tokenStr];

            // Feed the generated token back for continued generation
            llama_batch nextBatch = llama_batch_get_one(&id, 1);
            if (llama_decode(ctx, nextBatch) != 0) {
                break;
            }
        }

        llama_sampler_free(sampler);

        if (done) {
            dispatch_async(dispatch_get_main_queue(), ^{ done(full); });
        }
    });
}
@end 