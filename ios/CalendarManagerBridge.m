//
//  CalendarManagerBridge.m
//  SwiftBridge
//
//  Created by Jason Emberley on 10/31/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

// CalendarManagerBridge.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CalendarManager, NSObject)

RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(nonnull NSNumber *)date callback: (RCTResponseSenderBlock)callback)

@end


@interface RCT_EXTERN_MODULE(Sender, NSObject)

RCT_EXTERN_METHOD(start)
RCT_EXTERN_METHOD(initialize)

@end

@interface RCT_EXTERN_MODULE(Receiver, NSObject)

RCT_EXTERN_METHOD(start)
RCT_EXTERN_METHOD(initialize)

@end
