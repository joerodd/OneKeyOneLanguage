//
//  S3AppDelegate.m
//  Singleshot
//
//  Created by Michael Herring on 7/17/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3AppDelegate.h"

static const NSString * kS3InputSourceDefaultName = @"inputsourcedefaultname";
static const NSString * kS3EnabledDefaultName = @"enablehotkeydefaultname";
static const NSString * kS3HotkeyRegistrationFlagsDefaultName = @"hotkeyflags";
static const NSString * kS3HotkeyRegistrationCodeDefaultName = @"hotkeycode";

@implementation S3AppDelegate {
    NSArray * inputSources;
    S3InputMenuManager * inputMenuManager;
    S3HotkeyRegistration * hotkeyRegistration;
    TISInputSourceRef _selectedInputSource;
}

@synthesize shortcutRecorder;
@synthesize inputSourceMenu;
@synthesize selectedInputSourceButton;
@synthesize enableCheckbox;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //register help book
    AHRegisterHelpBookWithURL((__bridge CFURLRef)([[NSBundle mainBundle] pathForResource:@"Singleshot" ofType:@"help"]));
    [[self shortcutRecorder] setDelegate:self];
    [[self shortcutRecorder] setCanCaptureGlobalHotKeys:YES];
    [[self shortcutRecorder] setAllowsKeyOnly:YES escapeKeysRecord:NO];
    
    inputMenuManager = [[S3InputMenuManager alloc] init];
    [inputSourceMenu setDelegate:inputMenuManager];
    
    hotkeyRegistration = [[S3HotkeyRegistration alloc] init];
    
    //defrost the saved hotkey registration state, if it exists.
    NSNumber * savedHotkeyCode = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kS3HotkeyRegistrationCodeDefaultName];
    NSNumber * savedHotkeyFlags = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kS3HotkeyRegistrationFlagsDefaultName];
    NSString * savedInputSource = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kS3InputSourceDefaultName];
    NSNumber * savedEnableState = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kS3EnabledDefaultName];
    //worth pointing out: even if there are defaults, if the old input source is no longer installed, we still just fail.
    TISInputSourceRef restoredInputSource = NULL;
    if (savedInputSource != nil) {
        restoredInputSource = [inputMenuManager inputSourceForName:savedInputSource];
    }
    if (savedHotkeyCode != nil && savedHotkeyFlags != nil && restoredInputSource != NULL) {
        //actually register the hotkey
        [hotkeyRegistration restoreHotkeyRegistrationForKeyCode:savedHotkeyCode withFlags:savedHotkeyFlags];
        
        //set the value in the shortcut recorder
        KeyCombo synthesizedKeyCombo;
        synthesizedKeyCombo.code = [savedHotkeyCode intValue];
        synthesizedKeyCombo.flags = [savedHotkeyFlags unsignedIntValue];
        [shortcutRecorder setKeyCombo:synthesizedKeyCombo];
        
        //set the input source selection.
        [selectedInputSourceButton setTitle:savedInputSource];
        _selectedInputSource = restoredInputSource;
        
        //in this case, we actually don't care since if enabled isn't present,
        //sending boolValue to nil will return false, which seems reasonable.
        [hotkeyRegistration setEnabled:[savedEnableState boolValue]];
    }
    [[self window] makeMainWindow];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self revealWindow:self];
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    [hotkeyRegistration setDelegate:self];
    [hotkeyRegistration registerHotkey:newKeyCombo];
    //save the hotkey registration for defrosting later.
    NSNumber * codeToSave = [NSNumber numberWithLong:newKeyCombo.code];
    NSNumber * flagsToSave = [NSNumber numberWithUnsignedLong:newKeyCombo.flags];
    [[NSUserDefaults standardUserDefaults] setObject:codeToSave forKey:(NSString*)kS3HotkeyRegistrationCodeDefaultName];
    [[NSUserDefaults standardUserDefaults] setObject:flagsToSave forKey:(NSString*)kS3HotkeyRegistrationFlagsDefaultName];

}

- (IBAction)selectInputLanguage:(id)sender {
    [inputSourceMenu popUpMenuPositioningItem:nil atLocation:NSZeroPoint inView:(NSView*)sender];
}

-(void) methodSelected:(id)sender {
    _selectedInputSource = (__bridge TISInputSourceRef)([sender representedObject]);
    NSString * methodName = (__bridge NSString *)(TISGetInputSourceProperty(_selectedInputSource, kTISPropertyLocalizedName));
    [selectedInputSourceButton setTitle:methodName];
    [[NSUserDefaults standardUserDefaults] setObject:methodName forKey:(NSString*)kS3InputSourceDefaultName];
}

#pragma mark - S3HotkeyDelegate implementation

-(void)hotkeyPressed {
    TISSelectInputSource(_selectedInputSource);
}

- (IBAction)showLicensingInfo:(id)sender {
    NSURL * licensingURL = [[NSBundle mainBundle] URLForResource:@"License" withExtension:@"rtf"];
    NSData * licensingData = [NSData dataWithContentsOfURL:licensingURL];
    NSAttributedString * bsdLicenseString = [[NSAttributedString alloc] initWithRTF:licensingData documentAttributes:nil];
    
    NSDictionary * aboutPanelOptions = @{
    @"Credits" : bsdLicenseString,
    @"ApplicationName" : @"Licensing Information",
    @"Version" : @"",
    @"ApplicationVersion": @"",
    @"Copyright": @""
    };
    
    [[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:aboutPanelOptions];
}

- (IBAction)toggleEnabledStatus:(id)sender {
    BOOL newState = (BOOL)[(NSButton*)sender state];
    [hotkeyRegistration setEnabled:newState];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:newState] forKey:(NSString*)kS3EnabledDefaultName];
}

- (IBAction)closeWindow:(id)sender {
    [[self window] close];
}

- (IBAction)revealWindow:(id)sender {
    if ([[self window] isVisible] == NO) {
        [[self window] makeKeyAndOrderFront:nil];
    }
}

@end
