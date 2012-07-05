//
//  SAppDelegate.h
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface SAppDelegate : UIResponder <UIApplicationDelegate> {
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigation_controller;
@property (strong, nonatomic) IBOutlet RootViewController *root_view_controller;

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;
@end
