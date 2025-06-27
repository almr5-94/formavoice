// FilePath: Bridges/WhisperBridge.mm
// Objective-C++ wrapper around whisper.cpp compiled with GGML_QK_K 4-bit weights. :contentReference[oaicite:4]{index=4}

#import "WhisperBridge.h"
#import <Foundation/Foundation.h>
#import "whisper.h"

@implementation WhisperBridge {
    struct whisper_context *ctx;
    dispatch_queue_t queue;
}

- (instancetype)initWithModelAt:(NSString *)path {
    self = [super init];
    if (self) {
        ctx = whisper_init_from_file_q4_k([path UTF8String]); // GGML_QK_K 4-bit quantization. :contentReference[oaicite:5]{index=5}
        queue = dispatch_queue_create("ai.formavoice.whisper", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    }
    return self;
}

- (void)dealloc {
    whisper_free(ctx);
}

- (void)transcribePCM:(float *)pcm
               length:(int)len
             language:(NSString *)lang
       progressBlock:(void (^)(NSString *chunk))progress
        completion:(void (^)(NSString *full))completion {
    
    dispatch_async(queue, ^{
        struct whisper_params p = whisper_default_params();
        p.language = (char *)[lang UTF8String];
        whisper_full(ctx, p, pcm, len);
        
        const int n_segments = whisper_full_n_segments(ctx);
        NSMutableString *result = [NSMutableString string];
        for (int i = 0; i < n_segments; ++i) {
            const char *text = whisper_full_get_segment_text(ctx, i);
            [result appendString:[NSString stringWithUTF8String:text]];
            if (progress) { progress([NSString stringWithUTF8String:text]); }
        }
        if (completion) { completion(result); }
    });
}
@end
