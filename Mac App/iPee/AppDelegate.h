//
//  AppDelegate.h
//  ip toolbar
//
//  Created by Max Mitchell on 27/05/2016.
//  Copyright © 2016 crypter. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>


@property (nonatomic) NSUserDefaults *storedStuff;
@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) NSMenu *mainMenu;
@property (nonatomic) NSStatusBar *statusBar;
@property (nonatomic) NSString *ip;

//settings menu bar
@property (nonatomic) NSMenuItem* notification;
@property (nonatomic) NSMenuItem* showOnStartupItem;
@property (nonatomic) NSMenuItem* item1;
@property (nonatomic) NSMenuItem* item2;
@property (nonatomic) NSMenuItem* item3;
@property (nonatomic) NSMenuItem* item4;
@property (nonatomic) NSMenuItem* item5;
@property (nonatomic) NSMenuItem* item6;
@property (nonatomic) NSMenuItem* item7;
@property (nonatomic) NSMenuItem* item8;
@property (nonatomic) NSMenuItem* item9;

@end

