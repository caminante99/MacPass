//
//  MPToolbarDelegate.m
//  MacPass
//
//  Created by michael starke on 18.02.13.
//  Copyright (c) 2013 HicknHack Software GmbH. All rights reserved.
//

#import "MPToolbarDelegate.h"
#import "MPIconHelper.h"
#import "MPMainWindowController.h"

NSString *const MPToolbarItemAddGroup = @"AddGroup";
NSString *const MPToolbarItemAddEntry = @"AddEntry";
NSString *const MPToolbarItemEdit = @"Edit";
NSString *const MPToolbarItemDelete =@"Delete";
NSString *const MPToolbarItemAction = @"Action";
NSString *const MPToolbarItemSearch = @"Search";

@interface MPToolbarDelegate()

@property (retain) NSMutableDictionary *toolbarItems;
@property (retain) NSArray *toolbarIdentifiers;
@property (retain) NSDictionary *toolbarImages;

@end

@implementation MPToolbarDelegate


- (id)init
{
  self = [super init];
  if (self) {
    self.toolbarIdentifiers = @[ MPToolbarItemAddEntry, MPToolbarItemDelete, MPToolbarItemEdit, MPToolbarItemAddGroup, MPToolbarItemAction, NSToolbarFlexibleSpaceItemIdentifier, MPToolbarItemSearch ];
    self.toolbarItems = [NSMutableDictionary dictionaryWithCapacity:[self.toolbarItems count]];
    self.toolbarImages = [self createToolbarImages];
  }
  return self;
}

- (void)dealloc
{
  self.toolbarItems = nil;
  self.toolbarIdentifiers = nil;
  self.toolbarImages = nil;
  [super dealloc];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
  NSToolbarItem *item = self.toolbarItems[ itemIdentifier ];
  if( !item ) {
    
    item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    [item setAction:@selector(toolbarItemPressed:)];
    self.toolbarItems[itemIdentifier] = item;
    NSString *label = NSLocalizedString(itemIdentifier, @"");
    [item setLabel:label];
    [item release];
    
    if([itemIdentifier isEqualToString:MPToolbarItemSearch]) {
      NSSearchField *searchfield = [[NSSearchField alloc] initWithFrame:NSMakeRect(0, 0, 70, 32)];
      [item setView:searchfield];
      [searchfield setAction:@selector(updateFilter:)];
      [[searchfield cell] setSendsSearchStringImmediately:NO];
      [[searchfield cell] addObserver:self forKeyPath:@"controlSize" options:0 context:NULL];
      [[[searchfield cell] cancelButtonCell] setTarget:nil];
      [[[searchfield cell] cancelButtonCell] setAction:@selector(clearFilter:)];
      [searchfield release];
      self.searchItem = item;
    }
    else if([itemIdentifier isEqualToString:MPToolbarItemAction]) {
      NSPopUpButton *popupButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 50, 32) pullsDown:YES];
      [[popupButton cell] addObserver:self forKeyPath:@"controlSize" options:0 context:NULL];
      [[popupButton cell] setBezelStyle:NSTexturedRoundedBezelStyle];
      [[popupButton cell] setImageScaling:NSImageScaleProportionallyDown];
      [popupButton setTitle:@""];
      [popupButton sizeToFit];
      /*
       Built menu
       */
      NSMenu *menu = [NSMenu allocWithZone:[NSMenu menuZone]];
      NSMenuItem *menuItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"" action:NULL keyEquivalent:@""];
      [menuItem setImage:self.toolbarImages[itemIdentifier]];
      [menu addItem:menuItem];
      [menu addItemWithTitle:@"Foo" action:NULL keyEquivalent:@""];
      [menu addItemWithTitle:@"Bar" action:NULL keyEquivalent:@""];
      NSRect newFrame = [popupButton frame];
      newFrame.size.width += 20;
      
      [popupButton setFrame:newFrame];
      [popupButton setMenu:menu];
      /*
       Cleanup
       */
      [menuItem release];
      [menu release];
      
      
      [item setView:popupButton];
      [popupButton release];
    }
    else {
      NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
      [[button cell] setBezelStyle:NSTexturedRoundedBezelStyle];
      [[button cell] setImageScaling:NSImageScaleProportionallyDown];
      [button setTitle:itemIdentifier];
      [button setButtonType:NSMomentaryPushInButton];
      NSImage *image = self.toolbarImages[itemIdentifier];
      [button setImage:image];
      [button setImagePosition:NSImageOnly];
      [button sizeToFit];
      
      NSRect fittingRect = [button frame];
      fittingRect.size.width = MAX( (CGFloat)32.0,fittingRect.size.width);
      [button setFrame:fittingRect];
      [item setView:button];
      [button release];
    }
    return item;
  }
  
  return item;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
  return self.toolbarIdentifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
  return self.toolbarIdentifiers;
}

- (NSDictionary *)createToolbarImages{
  NSDictionary *imageDict = @{ MPToolbarItemAddEntry: [MPIconHelper icon:MPIconPassword],
                               MPToolbarItemAddGroup: [MPIconHelper icon:MPIconPassword],
                               MPToolbarItemDelete: [NSImage imageNamed:NSImageNameRemoveTemplate],
                               MPToolbarItemEdit: [MPIconHelper icon:MPIconNotepad],
                               MPToolbarItemAction: [NSImage imageNamed:NSImageNameActionTemplate]
                               };
  return imageDict;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSLog(@"Path:%@: Objecte:%@", keyPath, object);
}


@end
