//
//  S3AppDelegate.m
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 7/17/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3AppDelegate.h"
#import "S3HotkeyRegistration.h"

@implementation S3AppDelegate {
    NSArray * inputSources;
    EventHotKeyID hotKeyID;
    S3InputMenuManager * inputMenuManager;
}

@synthesize shortcutRecorder;
@synthesize inputSourceMenu;
@synthesize selectedInputSourceButton;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self shortcutRecorder] setDelegate:self];
    [[self shortcutRecorder] setCanCaptureGlobalHotKeys:YES];
    [[self shortcutRecorder] setAllowsKeyOnly:YES escapeKeysRecord:NO];
    hotKeyID.id = 1;
    hotKeyID.signature = 'OKOL';
    
    inputMenuManager = [[S3InputMenuManager alloc] init];
    [inputSourceMenu setDelegate:inputMenuManager];
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
}

- (IBAction)selectInputLanguage:(id)sender {
    [inputSourceMenu popUpMenuPositioningItem:nil atLocation:NSZeroPoint inView:(NSView*)sender];
}

-(void)selectInputSource:(id)sender {
    NSLog(@"Selected: %@", sender);
    TISInputSourceRef selectedInputSource = (__bridge TISInputSourceRef)([inputSources objectAtIndex:[sender tag]]);
    TISSelectInputSource(selectedInputSource);
}

-(void) methodSelected:(id)sender {
    TISInputSourceRef inputSource = (__bridge TISInputSourceRef)([sender representedObject]);
    NSString * methodName = (__bridge NSString *)(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName));
    [selectedInputSourceButton setTitle:methodName];
}

@end
