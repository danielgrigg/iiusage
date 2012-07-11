//
//  SSettingsViewController.m
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "SSettingsViewController.h"
#import "SEditableCell.h"
#import "SPasswordCell.h"
#import "SAppDelegate.h"

@interface SSettingsViewController ()

@end

@implementation SSettingsViewController
@synthesize ui_username_cell = _ui_username_cell;
@synthesize ui_password_cell = _ui_password_cell;

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark *UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"Login Details";
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
  assert(0 == section);
  return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *username_cell_id = @"SEditableCell";
	static NSString *password_cell_id = @"SPasswordCell";
  SAppDelegate* app_del = (SAppDelegate*)[[UIApplication sharedApplication] delegate];
  
  if (indexPath.row == 0) {
    SEditableCell *cell = 
    (SEditableCell *)[tv dequeueReusableCellWithIdentifier:username_cell_id];
    
    if (cell == nil) {		
      [[NSBundle mainBundle] loadNibNamed:@"SEditableCell" owner:self options:nil];
      cell = self.ui_username_cell;
      self.ui_username_cell = nil;
    }
    cell.text_field.text = app_del.username;
    return cell;
  }
  else {
    SPasswordCell *cell = 
    (SPasswordCell *)[tv dequeueReusableCellWithIdentifier:password_cell_id];
    
    if (cell == nil) {		
      [[NSBundle mainBundle] loadNibNamed:@"SPasswordCell" owner:self options:nil];
      cell = self.ui_password_cell;
      self.ui_password_cell = nil;
    }
    cell.password_field.text = app_del.password;
    return cell;
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  SAppDelegate* app_del = (SAppDelegate*)[[UIApplication sharedApplication] delegate];
  if (textField.tag == 1) {
    app_del.username = [textField text];
  }
  else if (textField.tag == 2) {
    app_del.password = [textField text];
  }
  return YES;
}


@end
