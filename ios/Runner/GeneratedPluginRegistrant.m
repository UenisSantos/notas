//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<admob_flutter/AdmobFlutterPlugin.h>)
#import <admob_flutter/AdmobFlutterPlugin.h>
#else
@import admob_flutter;
#endif

#if __has_include(<flutter_share_me/FlutterShareMePlugin.h>)
#import <flutter_share_me/FlutterShareMePlugin.h>
#else
@import flutter_share_me;
#endif

#if __has_include(<multi_select_item/MultiSelectItemPlugin.h>)
#import <multi_select_item/MultiSelectItemPlugin.h>
#else
@import multi_select_item;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AdmobFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"AdmobFlutterPlugin"]];
  [FlutterShareMePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterShareMePlugin"]];
  [MultiSelectItemPlugin registerWithRegistrar:[registry registrarForPlugin:@"MultiSelectItemPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
