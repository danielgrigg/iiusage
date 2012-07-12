//
//  RootViewController.m
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "RootViewController.h"
#import "SSettingsViewController.h"
#import "SAppDelegate.h"
#import "SUsage.h"
#import "SEditableCell.h"

@interface RootViewController ()
- (SAppDelegate*) app_delegate;
@end

@implementation RootViewController

@synthesize ui_settings, ui_usage, ui_refresh;

- (SAppDelegate*) app_delegate
{
  return (SAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)refresh_usage:(id)sender 
{
  [[self app_delegate] refresh_usage];
}

- (void)show_settings:(id)sender 
{
  SSettingsViewController *settings_controller = 
  [[SSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
  [self.navigationController pushViewController:settings_controller animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
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

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell* cell;
  
  cell = [self.ui_usage dequeueReusableCellWithIdentifier:@"usage_cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                  reuseIdentifier:@"usage_cell"];
    //    cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    //      cell.textLabel.textAlignment = UITextAlignmentCenter;
    
  }

  NSString* days_str = @"-";
  NSString* onpeak_str = @"-";
  NSString* offpeak_str = @"-";

  BOOL over_onpeak = NO, over_offpeak = NO;
  
  SAppDelegate* app_del = [self app_delegate];
  if (app_del.usage) 
  {
    days_str = [NSString stringWithFormat:@"%d days", app_del.usage.days_remaining];    
    if (app_del.usage.categories) 
    {
      SUsageCategory* peak = 
      (SUsageCategory*)[app_del.usage.categories objectForKey:@"peak"];
      over_onpeak = [peak over_quota];
      SUsageCategory* offpeak =
      (SUsageCategory*)[app_del.usage.categories objectForKey:@"offpeak"];
      over_offpeak = [offpeak over_quota];
      onpeak_str = [NSString stringWithFormat:@"%.1f GB", peak.bytes_used / 1.0e9];
      offpeak_str = [NSString stringWithFormat:@"%.1f GB", offpeak.bytes_used / 1.0e9];
    }
  }
  
  assert(cell != nil);
  if (indexPath.row == 2) {
    cell.textLabel.text = @"Rollsover";
    cell.detailTextLabel.text = days_str;
    
  }
  else if (indexPath.row == 0)
  {

    cell.textLabel.text = @"On-Peak";
    cell.detailTextLabel.text = onpeak_str;
    if (over_onpeak) cell.detailTextLabel.textColor = 
      [[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
  }
  else if (indexPath.row == 1)
  {
    cell.textLabel.text = @"Off-peak";
    cell.detailTextLabel.text = offpeak_str;
    if (over_onpeak) cell.detailTextLabel.textColor = 
      [[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
  }
  
  return cell;
}


@end
