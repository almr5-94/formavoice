// LLMBridge.h
// Public Objective-C++ interface for the phi-3 Mini / llama.cpp helper used by Swift sources.
// Created automatically by AI assistant to expose ObjC++ implementation to Swift Package consumers.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Lightweight wrapper around llama.cpp to stream tokens from a GGUF model.
@interface LLMBridge : NSObject

- (instancetype)initWithModelAt:(NSString *)path NS_DESIGNATED_INITIALIZER;

/// Run a prompt on the LLM and get incremental tokens.
/// @param prompt User prompt string.
/// @param tokenCallback Called on an arbitrary queue for each emitted token.
/// @param completion Called once full generation is complete.
- (void)runPrompt:(NSString *)prompt
   tokenCallback:(void (^)(NSString *token))tokenCallback
      completion:(void (^)(NSString *full))completion;

@end

NS_ASSUME_NONNULL_END 