#import "AdderPlugin.h"
#if __has_include(<adder/adder-Swift.h>)
#import <adder/adder-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "adder-Swift.h"
#endif

@implementation AdderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdderPlugin registerWithRegistrar:registrar];
}
@end
