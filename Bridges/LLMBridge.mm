// FilePath: Bridges/LLMBridge.mm
// Streams tokens from phi-3-mini.gguf using llama.cpp Metal path on A-series GPUs. :contentReference[oaicite:6]{index=6}

#import "LLMBridge.h"
#import <Foundation/Foundation.h>
#import "llama.h"

@implementation LLMBridge {
    struct llama_context *ctx;
    dispatch_queue_t queue;
}

- (instancetype)initWithModelAt:(NSString *)path {
    self = [super init];
    if (self) {
        struct llama_context_params params = llama_context_default_params();
        params.n_ctx = 2048;
        params.use_metal = 1; // Enable GPU inference when supported. :contentReference[oaicite:7]{index=7}
        ctx = llama_init_from_file([path UTF8String], params);
        queue = dispatch_queue_create("ai.formavoice.llm", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    }
    return self;
}

- (void)dealloc {
    llama_free(ctx);
}

- (void)runPrompt:(NSString *)prompt
    tokenCallback:(void(^)(NSString *token))cb
       completion:(void(^)(NSString *full))done {
    
    dispatch_async(queue, ^{
        NSMutableString *out = [NSMutableString string];
        llama_reset(ctx);
        llama_token tokens[1 << 14];
        int n_tokens = llama_tokenize(ctx, [prompt UTF8String], tokens, 2048, true);
        llama_eval(ctx, tokens, n_tokens, 0, 4);
        
        while (true) {
            llama_token id = llama_sample_token(ctx);
            const char *piece = llama_token_to_str(ctx, id);
            if (id == llama_token_eos(ctx)) { break; }
            [out appendString:[NSString stringWithUTF8String:piece]];
            if (cb) { cb([NSString stringWithUTF8String:piece]); }
            llama_eval(ctx, &id, 1, 0, 4);
        }
        if (done) { done(out); }
    });
}
@end
