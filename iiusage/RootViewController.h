//
//  RootViewController.h
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)show_settings:(id)sender;
- (IBAction)refresh_usage:(id)sender;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* ui_settings;
@property (nonatomic, retain) IBOutlet UITableView* ui_usage;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* ui_refresh;
@end
