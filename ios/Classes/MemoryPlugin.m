#import "MemoryPlugin.h"
#if __has_include(<memory_plugin/memory_plugin-Swift.h>)
#import <memory_plugin/memory_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "memory_plugin-Swift.h"
#endif

@implementation MemoryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMemoryPlugin registerWithRegistrar:registrar];
}
@end
