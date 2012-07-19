//
//  S3InputMenuManager.m
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 7/18/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3InputMenuManager.h"
#import <Carbon/Carbon.h>

@implementation S3InputMenuManager {
    NSArray * sourcesCompatibleWithASCII;
}

- (id)init {
    self = [super init];
    if (self) {
        sourcesCompatibleWithASCII = [NSMutableArray array];
        NSArray * allInputSources = CFBridgingRelease(TISCreateInputSourceList(NULL, TRUE));
        NSMutableArray * workingArray = [NSMutableArray array];
        for (int i=0; i<[allInputSources count]; ++i) {
            TISInputSourceRef nextInputSource = (__bridge TISInputSourceRef)([allInputSources objectAtIndex:i]);
            NSNumber * isASCIICompatible = CFBridgingRelease(TISGetInputSourceProperty(nextInputSource, kTISPropertyInputSourceIsASCIICapable));
            if ([isASCIICompatible boolValue]) {
                [workingArray addObject:(__bridge id)(nextInputSource)];
            }
            else {
                NSString * incompatibleInputSourceName = CFBridgingRelease(TISGetInputSourceProperty(nextInputSource, kTISPropertyLocalizedName));
                NSLog(@"Didn't add: %@",incompatibleInputSourceName);
            }
        }
        sourcesCompatibleWithASCII = [workingArray copy];
    }
    return self;
}
/*
- (void)menuNeedsUpdate:(NSMenu*)menu {
    for (int i = 0; i < [sourcesCompatibleWithASCII count]; ++i) {
        NSMenuItem * nextMenuItem
    }
}*/

- (NSInteger)numberOfItemsInMenu:(NSMenu*)menu {
    return [sourcesCompatibleWithASCII count];
}

- (BOOL)menu:(NSMenu*)menu updateItem:(NSMenuItem*)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel {
    TISInputSourceRef inputSource = (__bridge TISInputSourceRef)([sourcesCompatibleWithASCII objectAtIndex:index]);
    NSString * nameOfInputSource = CFBridgingRelease(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName));
    [item setTitle:nameOfInputSource];
    return YES;
}

/* indicates that the menu is being opened (displayed) or closed (hidden).  Do not modify the structure of the menu or the menu items from within these callbacks. */
- (void)menuWillOpen:(NSMenu *)menu NS_AVAILABLE_MAC(10_5) {
}
- (void)menuDidClose:(NSMenu *)menu NS_AVAILABLE_MAC(10_5) {
    
}

/* Indicates that menu is about to highlight item.  Only one item per menu can be highlighted at a time.  If item is nil, it means all items in the menu are about to be unhighlighted. */
- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item NS_AVAILABLE_MAC(10_5) {
    
}


/* Given a menu that is about to be opened on the given screen, return a rect, in screen coordinates, within which the menu will be positioned.  If you return NSZeroRect, or if the delegate does not implement this method, the menu will be confined to the bounds appropriate for the given screen.  The returned rect may not be honored in all cases, such as if it would force the menu to be too small.
 */
- (NSRect)confinementRectForMenu:(NSMenu *)menu onScreen:(NSScreen *)screen NS_AVAILABLE_MAC(10_6) {
    return NSZeroRect;
}



@end
