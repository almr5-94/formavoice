// Adds unload() to free GGML context on memory warnings.
// Relocated to Sources/Bridges for SwiftPM compilation.

#define WHISPER_STUB

#import "WhisperBridge.h"
#import "../../Vendor/whisper.cpp/include/whisper.h"
#import "../../Vendor/whisper.cpp/ggml/include/ggml.h"

@interface WhisperBridge ()
@property(nonatomic, assign) struct whisper_context *ctx;
@end

@implementation WhisperBridge (Unload)
- (void)unload {
    if (self.ctx) {
#ifndef WHISPER_STUB
        whisper_free(self.ctx);
#endif
        self.ctx = NULL;
    }
}
@end 