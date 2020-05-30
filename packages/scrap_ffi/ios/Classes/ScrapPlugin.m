#import "ScrapPlugin.h"
#if __has_include(<scrap/scrap-Swift.h>)
#import <scrap/scrap-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "scrap-Swift.h"
#endif

@implementation ScrapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScrapPlugin registerWithRegistrar:registrar];
}
@end
