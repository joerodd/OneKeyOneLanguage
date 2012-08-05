//
//  S3HotkeyRegistration.m
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 8/4/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3HotkeyRegistration.h"

//stores the single hotkey registration
static id hotkeyRegistration = nil;

//block signature typedef for handling NSEvents
typedef void (^keypressHandler)(NSEvent*);

//this block handles the NSEvent and tries to execute the given selector, if it exists
static keypressHandler S3KeypressHandler = ^(NSEvent * event) {
    NSLog(@"%@",event);
};

@implementation S3HotkeyRegistration

+(BOOL)registerHotkey:(KeyCombo)keyCombo withSelector:(SEL)targetSelector
{
    hotkeyRegistration = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:S3KeypressHandler];
    return NO;
}

@end
