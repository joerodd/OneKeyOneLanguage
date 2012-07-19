//
//  S3InputMenuManager.h
//  OneKeyOneLanguage
//
//  Created by Michael Herring on 7/18/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@protocol S3InputMenuSelectionDelegate <NSObject>

@required

-(void) methodSelected:(id)sender;

@end

@interface S3InputMenuManager : NSObject <NSMenuDelegate>

@property (strong, readwrite) NSObject <S3InputMenuSelectionDelegate> * delegate;

@end
