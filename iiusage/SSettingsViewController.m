//
//  SSettingsViewController.m
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "SSettingsViewController.h"
#import "SEditableCell.h"
#import "SAppDelegate.h"

@interface SSettingsViewController ()

@end

@implementation SSettingsViewController
@synthesize ui_username_cell, ui_password_cell;

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
  return @"Account";
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
  assert(0 == section);
  return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CELL_USERNAME = @"cell_username";
	static NSString *CELL_PASSWORD = @"cell_password";
  SAppDelegate* app_del = (SAppDelegate*)[[UIApplication sharedApplication] delegate];
  
  if (indexPath.row == 0) {
    SEditableCell *cell = (SEditableCell*)[tv dequeueReusableCellWithIdentifier:CELL_USERNAME];
    
    if (cell == nil) {		
      [[NSBundle mainBundle] loadNibNamed:@"UsernameCell" owner:self options:nil];
      cell = self.ui_username_cell;
      self.ui_username_cell = nil;
    }


    cell.label.text = @"User Name";
    cell.text_field.placeholder = @"name";
    if (app_del.username.length > 0) cell.text_field.text = app_del.username;

    return cell;
  }
  else// if (indexPath.row == 1) 
  {
    SEditableCell *cell = 
    (SEditableCell *)[tv dequeueReusableCellWithIdentifier:CELL_PASSWORD];
    
    if (cell == nil) {		
      [[NSBundle mainBundle] loadNibNamed:@"PasswordCell" owner:self options:nil];
      cell = self.ui_password_cell;
      self.ui_password_cell = nil;
    }

    cell.label.text = @"Password";
    if (app_del.password.length > 0) cell.text_field.text = app_del.password;
    cell.text_field.placeholder = @"Required";
    return cell;
  }

}

//- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
//  return [self isEditing];
//}

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
