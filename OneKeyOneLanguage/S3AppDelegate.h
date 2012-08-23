//
//  S3AppDelegate.h
//  Singleshot
//
//  Created by Michael Herring on 7/17/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "ShortcutRecorder.h"
#import "S3InputMenuManager.h"
#import "S3HotkeyRegistration.h"

static const NSString * kS3InputSourceDefaultName;
static const NSString * kS3EnabledDefaultName;
static const NSString * kS3HotkeyRegistrationFlagsDefaultName;
static const NSString * kS3HotkeyRegistrationCodeDefaultName;

@interface S3AppDelegate : NSObject <NSApplicationDelegate, S3InputMenuSelectionDelegate, S3HotkeyDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet SRRecorderControl *shortcutRecorder;
@property (weak) IBOutlet NSMenu *inputSourceMenu;
@property (weak) IBOutlet NSButton *selectedInputSourceButton;
@property (weak) IBOutlet NSButton *enableCheckbox;

- (IBAction)showLicensingInfo:(id)sender;

static OSStatus hotKeyEventHandler(EventHandlerCallRef inHandlerRef, EventRef event, void* refCon );
- (IBAction)toggleEnabledStatus:(id)sender;
- (IBAction)closeWindow:(id)sender;
- (IBAction)revealWindow:(id)sender;

@end
