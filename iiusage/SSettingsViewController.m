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

@interface SSettingsViewController ()

@end

@implementation SSettingsViewController
//@synthesize ui_settings_view = _ui_settings_view;
@synthesize ui_username_cell = _ui_username_cell;
@synthesize ui_password_cell = _ui_password_cell;

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  //  [self.ui_settings_view.style = 
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
  
  /*
   UITableViewCell* cell;
   cell = [self.ui_settings_view dequeueReusableCellWithIdentifier:@"myCell"];
   if (cell == nil) {
   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
   }
   assert(cell != nil);
   
   //  cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
   //  cell.textLabel.textAlignment = UITextAlignmentCenter;
   //  cell.selectionStyle = UITableViewCellSelectionStyleGray; // UITableViewCellSelectionStyleNone;
   cell.textLabel.text = @"Username"; // [docsWithExtension(LOG_FILE_EXTENSION) objectAtIndex:indexPath.row];
   cell.detailTextLabel.text = @"foobar";
   */
  
	static NSString *username_cell_id = @"SEditableCell";
	static NSString *password_cell_id = @"SPasswordCell";
  
  if (indexPath.row == 0) {
    SEditableCell *cell = 
    (SEditableCell *)[tv dequeueReusableCellWithIdentifier:username_cell_id];
    
    if (cell == nil) {		
      [[NSBundle mainBundle] loadNibNamed:@"SEditableCell" owner:self options:nil];
      cell = self.ui_username_cell;
      self.ui_username_cell = nil;
    }
    cell.text_field.text = @"your-username";
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
    cell.password_field.text = @"your-password";
    return cell;
  }
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // If row is deleted, remove it from the list.
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // NSString* removePath = documentPath([self logNameByIndex:indexPath.row]);
    
    // [self.logsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
    //withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  NSLog(@"textfieldshouldreturn!"); 
  [textField resignFirstResponder];
  return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  NSLog(@"textfield should end editing");
  
  NSLog(@"tag %d", textField.tag);
  
  if (textField.tag == 0) {
 //   NSLog(@"username");
  }
  else if (textField.tag == 1) {
   // NSLog(@"password");
  }
  return YES;
}


@end
