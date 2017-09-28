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
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey : @NO}];
        regions = [NSMutableArray array];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[kStatusUpdateEvent];
}

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(startAdvertising,
                 startAdvertisingWithRegionUUID:(NSString *)uuid
                 major:(NSNumber *)major
                 minor:(NSNumber *)minor
                 identifier: (NSString *)identifier
                 ) {
    UInt16 uint16Major = [major unsignedIntegerValue];
    UInt16 uint16Minor = [minor unsignedIntegerValue];
    NSUUID *regionUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:regionUUID major:uint16Major minor:uint16Minor identifier:identifier];
    [regions addObject:region];
}

RCT_EXPORT_METHOD(stopAdvertising) {
    [peripheralManager stopAdvertising];
    [regions removeAllObjects];
}

- (void)startAdvertisingWhenPossible {
    if(peripheralManager.state == CBPeripheralManagerStatePoweredOn) {

    }
}

#pragma mark - Periphial Manager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSString *status = [RCTBeaconManager stringForBeaconStatus:peripheral.state];
    [self sendEventWithName:kStatusUpdateEvent body:@{@"status": status}];
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        // TODO: start broadcast here?
    }
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

@end

