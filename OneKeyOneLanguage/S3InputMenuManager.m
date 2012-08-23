//
//  S3InputMenuManager.m
//  Singleshot
//
//  Created by Michael Herring on 7/18/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3InputMenuManager.h"
#import <Carbon/Carbon.h>

const NSUInteger kS3InputMenuManagerNumberOfSubmenus = 3;

@implementation S3InputMenuManager {
    NSArray * allInputSources;
}

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        CFArrayRef cfInputList = TISCreateInputSourceList(NULL, FALSE);
        NSMutableArray * workingInputSourceList = [NSMutableArray array];
        for (int i = 0; i < CFArrayGetCount(cfInputList); ++i) {
            TISInputSourceRef nextInputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(cfInputList, i);
            NSString * inputSourceName = (__bridge NSString *)(TISGetInputSourceProperty(nextInputSource, kTISPropertyLocalizedName));
            if ([inputSourceName rangeOfString:@"com.apple."].length == 0) {
                [workingInputSourceList addObject:(__bridge id)(nextInputSource)];
            }
        }
        allInputSources = [workingInputSourceList copy];
        CFRelease(cfInputList);
    }
    return self;
}

- (NSInteger)numberOfItemsInMenu:(NSMenu*)menu {
    return [allInputSources count];
}

- (BOOL)menu:(NSMenu*)menu updateItem:(NSMenuItem*)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel {
    TISInputSourceRef inputSource = (__bridge TISInputSourceRef)([allInputSources objectAtIndex:index]);
    NSString * nameOfInputSource = CFBridgingRelease(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName));
    [item setTitle:nameOfInputSource];
    [item setAction:@selector(methodSelected:)];
    [item setRepresentedObject:(__bridge id)inputSource];
    return YES;
}

/* indicates that the menu is being opened (displayed) or closed (hidden).  Do not modify the structure of the menu or the menu items from within these callbacks. */
- (void)menuWillOpen:(NSMenu *)menu {
}
- (void)menuDidClose:(NSMenu *)menu {
    
}

/* Indicates that menu is about to highlight item.  Only one item per menu can be highlighted at a time.  If item is nil, it means all items in the menu are about to be unhighlighted. */
- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item {
    
}


/* Given a menu that is about to be opened on the given screen, return a rect, in screen coordinates, within which the menu will be positioned.  If you return NSZeroRect, or if the delegate does not implement this method, the menu will be confined to the bounds appropriate for the given screen.  The returned rect may not be honored in all cases, such as if it would force the menu to be too small.
 */
- (NSRect)confinementRectForMenu:(NSMenu *)menu onScreen:(NSScreen *)screen {
    return NSZeroRect;
}


-(TISInputSourceRef)inputSourceForName:(NSString*)inputSourceName {
    for(int i=0; i < [allInputSources count]; ++i) {
        TISInputSourceRef nextSource = (__bridge TISInputSourceRef)[allInputSources objectAtIndex:i];
        NSString * nextInputName = CFBridgingRelease(TISGetInputSourceProperty(nextSource, kTISPropertyLocalizedName));
        if ([nextInputName isEqualToString:inputSourceName]) {
            return nextSource;
        }
    }
    return NULL;
}


@end
