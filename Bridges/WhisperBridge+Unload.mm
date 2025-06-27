// FilePath: Sources/Bridges/WhisperBridge+Unload.mm
// Adds unload() to free GGML context on memory warning, fulfilling §35.1.  
// GGML supports ctx-free call documented in whisper.cpp README. :contentReference[oaicite:7]{index=7}

#import "WhisperBridge.h"

@interface WhisperBridge ()
@property(nonatomic, assign) struct whisper_context *ctx;
@end

@implementation WhisperBridge (Unload)
- (void)unload {
    if (self.ctx) {
        whisper_free(self.ctx);
        self.ctx = NULL;
    }
}
@end
