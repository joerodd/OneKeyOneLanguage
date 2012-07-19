//
//  S3AppDelegate.m
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 7/17/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3AppDelegate.h"
#import "S3InputMenuManager.h"

@implementation S3AppDelegate {
    NSArray * inputSources;
    EventHotKeyID hotKeyID;
    S3InputMenuManager * inputMenuManager;
}

@synthesize shortcutRecorder;
@synthesize inputSourceMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self shortcutRecorder] setDelegate:self];
    [[self shortcutRecorder] setCanCaptureGlobalHotKeys:YES];
    /*inputSources = CFBridgingRelease(TISCreateInputSourceList(NULL, TRUE));
    for (int i=0; i<[inputSources count]; ++i) {
        TISInputSourceRef nextInputSource = (__bridge TISInputSourceRef)([inputSources objectAtIndex:i]);
        NSString * inputSourceName = CFBridgingRelease(TISGetInputSourceProperty(nextInputSource, kTISPropertyLocalizedName));
        NSMenuItem * nextMenuItem = [[NSMenuItem alloc] initWithTitle:inputSourceName action:@selector(selectInputSource:) keyEquivalent:@""];
        [nextMenuItem setTag:i];
        [inputSourceMenu addItem:nextMenuItem];
    }*/
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
    [inputSourceMenu popUpMenuPositioningItem:nil atLocation:NSZeroPoint inView:nil];
}

-(void)selectInputSource:(id)sender {
    NSLog(@"Selected: %@", sender);
    TISInputSourceRef selectedInputSource = (__bridge TISInputSourceRef)([inputSources objectAtIndex:[sender tag]]);
    TISSelectInputSource(selectedInputSource);
}

@end
