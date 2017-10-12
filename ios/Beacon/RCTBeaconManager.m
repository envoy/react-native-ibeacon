#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <React/RCTUIManager.h>

#import "RCTBeaconManager.h"

NSString * const kStatusUpdateEvent = @"StatusUpdate";

@interface RCTBeaconManager() <CBPeripheralManagerDelegate, CBPeripheralDelegate>
@end

@implementation RCTBeaconManager {
    CBPeripheralManager *peripheralManager;
    NSMutableArray<CLBeaconRegion *> *regions;
    BOOL advertiseWhenReady;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey : @NO}];
        regions = [NSMutableArray array];
        advertiseWhenReady = NO;
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[kStatusUpdateEvent];
}

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(startAdvertising,
                 startAdvertisingWithRegionUUID:(NSString * _Nonnull)uuid
                 major:(NSNumber * _Nonnull)major
                 minor:(NSNumber * _Nonnull)minor
                 identifier:(NSString * _Nonnull)identifier
) {
    UInt16 uint16Major = [major unsignedIntegerValue];
    UInt16 uint16Minor = [minor unsignedIntegerValue];
    NSUUID *regionUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:regionUUID major:uint16Major minor:uint16Minor identifier:identifier];
    [regions addObject:region];
    advertiseWhenReady = YES;
    [self startAdvertisingWhenPossible];
}

RCT_EXPORT_METHOD(stopAdvertising) {
    advertiseWhenReady = NO;
    [peripheralManager stopAdvertising];
    [regions removeAllObjects];
}

RCT_REMAP_METHOD(currentStatus,
                 currentStatusWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject
) {
    resolve([RCTBeaconManager stringForBeaconStatus:peripheralManager.state]);
}

- (void)startAdvertisingWhenPossible {
    if(peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    for (CLBeaconRegion *region in regions) {
        [peripheralManager startAdvertising:[region peripheralDataWithMeasuredPower:nil]];
    }
}

#pragma mark - Periphial Manager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager * _Nonnull)peripheral {
    NSString * _Nonnull status = [RCTBeaconManager stringForBeaconStatus:peripheral.state];
    [self sendEventWithName:kStatusUpdateEvent body:@{@"status": status}];
    [self startAdvertisingWhenPossible];
}

+ (NSString *)stringForBeaconStatus:(CBManagerState)state {
    switch (state) {
        case CBPeripheralManagerStateUnknown:
            return @"unknown";
        case CBPeripheralManagerStateResetting:
            return @"resetting";
        case CBPeripheralManagerStateUnsupported:
            return @"unsupported";
        case CBPeripheralManagerStateUnauthorized:
            return @"unauthorized";
        case CBPeripheralManagerStatePoweredOff:
            return @"poweredOff";
        case CBPeripheralManagerStatePoweredOn:
            return @"poweredOn";
    }
    return NULL;
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

@end
