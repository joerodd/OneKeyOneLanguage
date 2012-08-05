//
//  S3AppDelegate.m
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 7/17/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3AppDelegate.h"

@implementation S3AppDelegate {
    NSArray * inputSources;
    S3InputMenuManager * inputMenuManager;
    S3HotkeyRegistration * hotkeyRegistration;
    TISInputSourceRef _selectedInputSource;
}

@synthesize shortcutRecorder;
@synthesize inputSourceMenu;
@synthesize selectedInputSourceButton;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self shortcutRecorder] setDelegate:self];
    [[self shortcutRecorder] setCanCaptureGlobalHotKeys:YES];
    [[self shortcutRecorder] setAllowsKeyOnly:YES escapeKeysRecord:NO];
    
    inputMenuManager = [[S3InputMenuManager alloc] init];
    [inputSourceMenu setDelegate:inputMenuManager];
    
    hotkeyRegistration = [[S3HotkeyRegistration alloc] init];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [[self window] makeKeyAndOrderFront:nil];
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    [hotkeyRegistration setDelegate:self];
    [hotkeyRegistration registerHotkey:newKeyCombo];
}

- (IBAction)selectInputLanguage:(id)sender {
    [inputSourceMenu popUpMenuPositioningItem:nil atLocation:NSZeroPoint inView:(NSView*)sender];
}

-(void) methodSelected:(id)sender {
    _selectedInputSource = (__bridge TISInputSourceRef)([sender representedObject]);
    NSString * methodName = (__bridge NSString *)(TISGetInputSourceProperty(_selectedInputSource, kTISPropertyLocalizedName));
    [selectedInputSourceButton setTitle:methodName];
}

#pragma mark - S3HotkeyDelegate implementation

-(void)hotkeyPressed {
    TISSelectInputSource(_selectedInputSource);
}

@end
