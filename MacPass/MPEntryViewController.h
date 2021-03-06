//
//  MPEntryViewController.h
//  MacPass
//
//  Created by michael starke on 18.02.13.
//  Copyright (c) 2013 HicknHack Software GmbH. All rights reserved.
//

#import "MPViewController.h"

APPKIT_EXTERN NSString *const MPEntryTableUserNameColumnIdentifier;
APPKIT_EXTERN NSString *const MPEntryTableTitleColumnIdentifier;
APPKIT_EXTERN NSString *const MPEntryTablePasswordColumnIdentifier;
APPKIT_EXTERN NSString *const MPEntryTableParentColumnIdentifier;
APPKIT_EXTERN NSString *const MPEntryTableURLColumnIdentifier;


@class KdbGroup;
@class MPOutlineViewDelegate;

@interface MPEntryViewController : MPViewController <NSTableViewDelegate>

@property (assign) KdbGroup *activeGroup;
@property (readonly, retain) NSArrayController *entryArrayController;
@property (nonatomic, retain) NSString *filter;

/* Clear the Search filter*/
- (void)clearFilter;

@end
