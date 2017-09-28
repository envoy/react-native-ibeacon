import { NativeEventEmitter } from 'react-native';
export declare const StatusUpdateEvent = "StatusUpdate";
export declare type Status = 'unknown' | 'resetting' | 'unsupported' | 'unauthorized' | 'poweredOff' | 'poweredOn';
export default class Beacon {
    static emitter: NativeEventEmitter;
    static startAdvertising(uuid: string, major: number, minor: number, identifier: any): any;
    static stopAdvertising(): void;
    static currentStatus(): Promise<Status>;
}
