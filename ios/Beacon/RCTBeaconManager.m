#import <UIKit/UIKit.h>
#import <React/RCTUIManager.h>

#import "RCTBeaconManager.h"

@implementation RCTBeaconManager

RCT_EXPORT_MODULE()

// FIXME:
RCT_REMAP_METHOD(hello,
                 helloWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve(@"hello");
}

@end
