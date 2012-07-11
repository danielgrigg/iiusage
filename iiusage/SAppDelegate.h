//
//  SAppDelegate.h
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class SUsage;

@interface SAppDelegate : UIResponder <UIApplicationDelegate> {
  @private
  NSURLConnection *toolbox_connection;  
  NSMutableData* usage_data;
  NSOperationQueue* parse_queue;
  SUsage* usage;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigation_controller;
@property (strong, nonatomic) IBOutlet RootViewController *root_view_controller;

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) SUsage* usage;

- (void)receiveUsage:(NSNotification*) notif;
- (void)refresh_usage;
@end
