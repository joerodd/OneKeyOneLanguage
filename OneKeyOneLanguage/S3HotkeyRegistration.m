//
//  S3HotkeyRegistration.m
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 8/4/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3HotkeyRegistration.h"

//block signature typedef for handling NSEvents
typedef void (^keypressHandler)(NSEvent*);

@implementation S3HotkeyRegistration
{
    id hotkeyRegistration;
    KeyCombo _registeredKeyCombo;
}

-(BOOL)registerHotkey:(KeyCombo)keyCombo
{
    _registeredKeyCombo = keyCombo;
    keypressHandler myHandler = ^(NSEvent * event) {
        unsigned short eventCode = [event keyCode];
        unsigned short registeredCode = _registeredKeyCombo.code;
        NSUInteger eventFlags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
        NSUInteger registeredFlags = _registeredKeyCombo.flags;
        if (registeredCode == eventCode) {
            if (registeredFlags == eventFlags ||
                (eventFlags == 0 && registeredFlags == 0)) {
                [[self delegate] performSelector:@selector(hotkeyPressed)];
            }
        }
    };
    hotkeyRegistration = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:myHandler];
    return NO;
}

@end
