
#import "RNSmartassets.h"

@implementation RNSmartassets

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE(Smartassets)

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(isFileExist:(NSString *)filePath){
    if([filePath hasPrefix:@"file://"]){
      filePath = [filePath substringFromIndex:6];
    }
  NSLog(@"filePath:%@, bundlePath:%@", filePath, [[NSBundle mainBundle] bundlePath]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    return @(fileExists);
}

RCT_EXPORT_METHOD(travelDrawable:(NSString *)bundlePath callBack:(RCTResponseSenderBlock)callback){
    bundlePath = [bundlePath substringFromIndex:6];
    NSString *assetPath = [bundlePath stringByDeletingLastPathComponent];
  NSLog(@"bundlePath:%@", assetPath);
    NSString *imgPath;
    NSFileManager *fm;
    NSDirectoryEnumerator *dirEnum;
    fm = [NSFileManager defaultManager];
    dirEnum = [fm enumeratorAtPath:assetPath];
  
    NSMutableArray *imgArrays = [[NSMutableArray alloc]init];
    while ((imgPath = [dirEnum nextObject]) != nil){
      NSLog(@"imgPath:%@", imgPath);
        [imgArrays addObject:[assetPath stringByAppendingPathComponent:imgPath]];
    }
  NSLog(@"imgArr:%@", imgArrays);
    callback(imgArrays);
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"DefaultMainBundlePath": [[NSBundle mainBundle] bundlePath]
             };
}

@end


