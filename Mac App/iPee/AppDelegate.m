//
//  AppDelegate.m
//  ip toolbar
//
//  Created by Max Mitchell on 27/05/2016.
//  Copyright © 2016 crypter. All rights reserved.
//

#import "AppDelegate.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

NSString* url_string = @"https://ipee.maxis.me/ipee";

NSString* network_error_string = @"No Internet!";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self onlyOneInstanceOfApp];
    _storedStuff = [NSUserDefaults standardUserDefaults];
    [self createStatusBarItem];
    [self updateIP:1];
    
    //check ip every 5 seconds
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateIP:) userInfo:nil repeats:YES];
}

-(void)setStatus:(NSString*)mess{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:mess];
    _statusItem.attributedTitle=attributedString;
}

#pragma mark - IP
-(void)updateIP:(int)x{
    
    NSURL *url = [NSURL URLWithString:url_string];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error){
             NSLog(@"error %@", error);
             [self setStatus:network_error_string];
         }else{
             NSString* ip = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [self setStatus:ip];
             
             if(![ip isEqual: _ip] && ip){ //if IP has changed
                 [self updateIPinfo];
                 
                 //send notification
                 if([_storedStuff integerForKey:@"notifications"] == 1 && x != 1 && _ip && ip){
                     NSUserNotification *notification = [[NSUserNotification alloc] init];
                     notification.title = @"Your IP has changed!";
                     notification.informativeText = [NSString stringWithFormat:@"From: %@ to: %@",_ip, ip];
                     [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
                 }
                 
                 _ip = ip;
             }
         }
     }];
}


-(void)updateIPinfo{
    if(_statusItem.menu){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?more",url_string]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (!error){
                 NSDictionary *moreInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:nil];
                 
                 NSArray *items = [NSArray arrayWithObjects:_item1,_item2,_item3,_item4,_item5,_item6,_item7,_item8,_item9, nil];
                 
                 //remove all of them
                 for (NSMenuItem *item in items) {
                     item.title = @"";
                     item.hidden = true;
                 }
                 
                 //add values
                 int x=0;
                 for(id key in moreInfo){
                     NSString* value = [moreInfo objectForKey:key];
                     if(![value  isEqual: @""] && ![key isEqual: @"IP"] && ![key isEqual: @"Location"]){
                         NSString* info = [NSString stringWithFormat:@"%@: %@",key,value];
                         
                         _item1.title = info;
                         x++;
                         int y = 0;
                         for (NSMenuItem *item in items) {
                             if(x == y){
                                 [item setTitle:info];
                                 [item setHidden:false];
                             }
                             y++;
                         }
                     }
                 }
                 [self setStatus:_ip];
             }else{
                 [self setStatus:_ip];
             }
         }];
        [_localIPAddress setTitle:[NSString stringWithFormat:@"Local IP: %@", [self getIPAddress]]];
    }
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

- (void)copyIP{
    NSString* ip = (NSString*)_statusItem.attributedTitle;
    if(ip != network_error_string){
        NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
        [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
        [pasteBoard setString:_ip forType:NSStringPboardType];
    }
}

#pragma mark - menu bar
- (void)createStatusBarItem {
    _statusBar = [NSStatusBar systemStatusBar];
    _statusItem = [_statusBar statusItemWithLength:NSVariableStatusItemLength];
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@"Searching..."];
    _statusItem.attributedTitle=attributedString;
    _statusItem.highlightMode = YES;
    _statusItem.menu = [self defaultStatusBarMenu];
    [_statusItem setTarget:self];
}

- (NSMenu *)defaultStatusBarMenu {
    NSMenu *mainMenu = [[NSMenu alloc] init];
    
    //----------IP details empty
    _item1 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item1 setTarget:self];
    [_item1 setEnabled:false];
    _item1.hidden = true;
    [mainMenu addItem:_item1];
    
    _item2 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item2 setTarget:self];
    [_item2 setEnabled:false];
    _item2.hidden = true;
    [mainMenu addItem:_item2];
    
    _item3 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item3 setTarget:self];
    [_item3 setEnabled:false];
    _item3.hidden = true;
    [mainMenu addItem:_item3];
    
    _item4 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item4 setTarget:self];
    [_item4 setEnabled:false];
    _item4.hidden = true;
    [mainMenu addItem:_item4];
    
    _item5 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item5 setTarget:self];
    [_item5 setEnabled:false];
    _item5.hidden = true;
    [mainMenu addItem:_item5];
    
    _item6 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item6 setTarget:self];
    [_item6 setEnabled:false];
    _item6.hidden = true;
    [mainMenu addItem:_item6];
    
    _item7 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item7 setTarget:self];
    [_item7 setEnabled:false];
    _item7.hidden = true;
    [mainMenu addItem:_item7];
    
    _item8 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item8 setTarget:self];
    [_item8 setEnabled:false];
    _item8.hidden = true;
    [mainMenu addItem:_item8];
    
    _item9 = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
    [_item9 setTarget:self];
    [_item9 setEnabled:false];
    _item9.hidden = true;
    [mainMenu addItem:_item9];
    
    //----------end
    
    [mainMenu addItem:[NSMenuItem separatorItem]];
    
    _localIPAddress = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Local IP: %@", [self getIPAddress]] action:NULL keyEquivalent:@""];
    [_localIPAddress setTarget:self];
    [_localIPAddress setEnabled:false];
    [mainMenu addItem:_localIPAddress];
    
    [mainMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem* copyIP = [[NSMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyIP) keyEquivalent:@"c"];
    [copyIP setTarget:self];
    [mainMenu addItem:copyIP];
    
    NSMenuItem* refreshTitle = [[NSMenuItem alloc] initWithTitle:@"Force refresh" action:@selector(updateIP:) keyEquivalent:@"r"];
    [refreshTitle setTarget:self];
    [mainMenu addItem:refreshTitle];
    
    _showOnStartupItem = [[NSMenuItem alloc] initWithTitle:@"Open iPee at login" action:@selector(openOnStartup) keyEquivalent:@""];
    
    if([self loginItemExistsWithLoginItemReference]){
        [_showOnStartupItem setState:NSOnState];
    }else{
        [_showOnStartupItem setState:NSOffState];
    }
    
    [_showOnStartupItem setTarget:self];
    [mainMenu addItem:_showOnStartupItem];
    
    _notification = [[NSMenuItem alloc] initWithTitle:@"Notifications" action:@selector(setNotifications) keyEquivalent:@""];
    
    if([_storedStuff integerForKey:@"notifications"] == 1){
        [_notification setState:NSOnState];
    }else{
        [_notification setState:NSOffState];
    }
    
    [_notification setTarget:self];
    [mainMenu addItem:_notification];
    
    [mainMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem* quit = [[NSMenuItem alloc] initWithTitle:@"Quit iPee" action:@selector(quit) keyEquivalent:@""];
    [quit setTarget:self];
    [mainMenu addItem:quit];
    
    // Disable auto enable
    [mainMenu setAutoenablesItems:NO];
    [mainMenu setDelegate:(id)self];
    return mainMenu;
}

-(void)setNotifications{
    if([_storedStuff integerForKey:@"notifications"] != 1){
        [_notification setState:NSOnState];
        [_storedStuff setInteger:1 forKey:@"notifications"];
    }else{
        [_notification setState:NSOffState];
        [_storedStuff setInteger:0 forKey:@"notifications"];
    }
    [_storedStuff synchronize];
}


#pragma mark - open on startup

- (BOOL)loginItemExistsWithLoginItemReference{
    BOOL found = NO;
    UInt32 seedValue;
    CFURLRef thePath = NULL;
    LSSharedFileListRef theLoginItemsRefs = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    NSString * appPath = [[NSBundle mainBundle] bundlePath];
    // We're going to grab the contents of the shared file list (LSSharedFileListItemRef objects)
    // and pop it in an array so we can iterate through it to find our item.
    CFArrayRef loginItemsArray = LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
    for (id item in (__bridge NSArray *)loginItemsArray) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
            if ([[(__bridge NSURL *)thePath path] hasPrefix:appPath]) {
                found = YES;
                break;
            }
            // Docs for LSSharedFileListItemResolve say we're responsible
            // for releasing the CFURLRef that is returned
            if (thePath != NULL) CFRelease(thePath);
        }
    }
    if (loginItemsArray != NULL) CFRelease(loginItemsArray);
    
    return found;
}

- (void)enableLoginItemWithURL
{
    if(![self loginItemExistsWithLoginItemReference]){
        LSSharedFileListRef loginListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
        
        if (loginListRef) {
            // Insert the item at the bottom of Login Items list.
            LSSharedFileListItemRef loginItemRef = LSSharedFileListInsertItemURL(loginListRef,
                                                                                 kLSSharedFileListItemBeforeFirst,
                                                                                 NULL,
                                                                                 NULL,
                                                                                 (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]],
                                                                                 NULL,
                                                                                 NULL);
            if (loginItemRef) {
                CFRelease(loginItemRef);
            }
            CFRelease(loginListRef);
        }
    }
}

- (void)removeLoginItemWithURL
{
    if([self loginItemExistsWithLoginItemReference]){
        LSSharedFileListRef loginListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
        
        LSSharedFileListItemRef loginItemRef = LSSharedFileListInsertItemURL(loginListRef,
                                                                             kLSSharedFileListItemBeforeFirst,
                                                                             NULL,
                                                                             NULL,
                                                                             (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]],
                                                                             NULL,
                                                                             NULL);
        
        // Insert the item at the bottom of Login Items list.
        LSSharedFileListItemRemove(loginListRef, loginItemRef);
    }
}

-(void)openOnStartup{
    if(![self loginItemExistsWithLoginItemReference]){
        [self enableLoginItemWithURL];
        [_showOnStartupItem setState:NSOnState];
    }else{
        [self removeLoginItemWithURL];
        [_showOnStartupItem setState:NSOffState];
    }
}


#pragma mark - quit

-(void)quit{
    [NSApp terminate:self];
}

- (void)onlyOneInstanceOfApp {
    if ([[NSRunningApplication runningApplicationsWithBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]] count] > 1) {
        NSLog(@"already running");
        [self quit];
    }
    
}

@end
