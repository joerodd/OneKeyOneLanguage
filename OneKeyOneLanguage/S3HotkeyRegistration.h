//
//  S3HotkeyRegistration.h
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 8/4/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShortcutRecorder.h"

@interface S3HotkeyRegistration : NSObject

-(BOOL)registerHotkey:(KeyCombo)keyCombo withSelector:(SEL)targetSelector;

@end
