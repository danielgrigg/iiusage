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

}
@property (nonatomic, assign) IBOutlet SEditableCell* ui_username_cell;
@property (nonatomic, assign) IBOutlet SEditableCell* ui_password_cell;

@end
