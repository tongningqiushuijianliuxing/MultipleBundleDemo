//
//  RCTBridge+CustomBridge.h
//  MultipleBundleDemo
//
//  Created by 产品1 on 2024/8/13.
//

#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTBridge (CustomBridge)
- (void)executeSourceCode:(NSData *)sourceCode withSourceURL:(NSURL *)url sync:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END
