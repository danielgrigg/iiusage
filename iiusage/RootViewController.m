//
//  RootViewController.m
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "RootViewController.h"
#import "SSettingsViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize ui_settings = _ui_settings;
@synthesize ui_usage = _ui_usage;

- (void)show_settings:(id)sender {
  NSLog(@"show_settings stub");
  
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
    assert(cell != nil);
    
    cell.textLabel.text = @"stub-label";
    cell.detailTextLabel.text = @"stub-detail";  
    return cell;
  }


@end
