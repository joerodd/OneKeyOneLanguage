//
//  S3AppDelegate.h
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 7/17/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "ShortcutRecorder.h"
#import "S3InputMenuManager.h"

@interface S3AppDelegate : NSObject <NSApplicationDelegate, S3InputMenuSelectionDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet SRRecorderControl *shortcutRecorder;
@property (weak) IBOutlet NSMenu *inputSourceMenu;

- (IBAction)selectInputLanguage:(id)sender;

static OSStatus hotKeyEventHandler(EventHandlerCallRef inHandlerRef, EventRef event, void* refCon );

@end
