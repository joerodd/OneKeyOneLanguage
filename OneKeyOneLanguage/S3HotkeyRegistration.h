//
//  S3HotkeyRegistration.h
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 8/4/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShortcutRecorder.h"

@protocol S3HotkeyDelegate <NSObject>

-(void)hotkeyPressed;

@end

@interface S3HotkeyRegistration : NSObject

@property (readwrite, strong) id <S3HotkeyDelegate> delegate;
@property (readwrite, assign) BOOL enabled;

-(BOOL)registerHotkey:(KeyCombo)keyCombo;

@end
