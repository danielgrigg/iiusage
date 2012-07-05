//
//  SSettingsViewController.h
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEditableCell;
@class SPasswordCell;

@interface SSettingsViewController : UITableViewController <UITextFieldDelegate> {
@private
}
//@property (nonatomic, retain) IBOutlet UITableView* ui_settings_view;

@property (nonatomic, assign) IBOutlet SEditableCell *ui_username_cell;
@property (nonatomic, assign) IBOutlet SPasswordCell *ui_password_cell;

@end
