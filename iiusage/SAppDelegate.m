//
//  SAppDelegate.m
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "SAppDelegate.h"
#import "RootViewController.h"
#import "SUsageParser.h"
#import "SUsage.h"

@interface SAppDelegate ()
@property (nonatomic, strong) NSURLConnection *toolbox_connection;  
@property (nonatomic, strong) NSMutableData *usage_data;  
@property (nonatomic, strong) NSOperationQueue *parse_queue;

- (void)handleError:(NSError *)error;
- (BOOL)settings_valid;
- (NSDictionary*)load_plist_map:(NSString*)name;
- (void)save_plist_map:(NSString*)name
                      with:(NSDictionary*)root;
- (void)persist_settings;

@end

@implementation SAppDelegate

@synthesize window, root_view_controller, navigation_controller, usage,
  username, password, toolbox_connection, usage_data, parse_queue;

- (NSDictionary*)load_plist_map:(NSString*)name
{
  NSString *errorDesc = nil;
  NSPropertyListFormat format;
  NSString *plistPath;
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex:0];
  plistPath = [rootPath stringByAppendingPathComponent:
               [NSString stringWithFormat:@"%@.plist", name]];
  if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
    plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
  }
  NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
  NSDictionary *root = (NSDictionary *)[NSPropertyListSerialization
                                        propertyListFromData:plistXML
                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                        format:&format
                                        errorDescription:&errorDesc];
  if (!root) {
    NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
  }
  return root;
}

- (void)save_plist_map:(NSString*)name
                    with:(NSDictionary *)root
{
  NSString *error;
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString *plistPath = [rootPath stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"%@.plist", name]];
  
  NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:root
                                                                 format:NSPropertyListXMLFormat_v1_0
                                                       errorDescription:&error];
  if(plistData) 
  {
    [plistData writeToFile:plistPath atomically:YES];
  }
  else {
    NSLog(@"error saving plist: %@", error);
  }
}

- (BOOL) settings_valid 
{
  return username != nil && username.length > 0 && 
  password != nil && password.length > 0;
}

- (void) persist_settings
{
  NSDictionary* root = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"Username", password, @"Password", nil];
  [self save_plist_map:@"Settings" with:root];
}

- (void)receiveUsage:(NSNotification*) notif {
  assert([NSThread isMainThread]);
  usage = [[notif userInfo] valueForKey:NOTIF_USAGE];
  [self.root_view_controller.ui_usage reloadData];
}

- (void)refresh_usage
{
  if ([self settings_valid] != YES) return;
  
  NSString *url_str =
  [NSString stringWithFormat:@"https://toolbox.iinet.net.au/cgi-bin/new/volume_usage_xml.cgi?action=login&username=%@&password=%@",
   username, password];
  
  self.toolbox_connection = 
  [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url_str]] 
                                  delegate:self];
  
  NSAssert(self.toolbox_connection != nil, @"Failure to create URL connection.");
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  self.root_view_controller.ui_refresh.enabled = NO;
  
  self.parse_queue = [NSOperationQueue new];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveUsage:)
                                               name:NOTIF_USAGE
                                             object:nil];  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //    [self.window addSubview:self.navigation_controller.view];
  self.window.rootViewController= self.navigation_controller;  
  [self.window makeKeyAndVisible];
  
  NSDictionary* settings_map = [self load_plist_map:@"Settings"];
  
  self.username = [settings_map valueForKey:@"Username"];
  self.password = [settings_map valueForKey:@"Password"];
  
  if ([self settings_valid] != YES) 
  {
    [root_view_controller show_settings:nil];
  }
  else {
  //  [self refresh_usage];
  }  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark UINavigationController delegate methods

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController 
                    animated:(BOOL)animated 
{
  NSLog(@"will_show_view_controller");
  if (viewController == self.root_view_controller && 
      [self settings_valid])
  {
    [self persist_settings];
  }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if ((([httpResponse statusCode]/100) == 2)) { // && [[response MIMEType] isEqual:@"application/atom+xml"]) {
    self.usage_data = [NSMutableData data];
  } else {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                              NSLocalizedString(@"Network Error",
                                                @"Error message displayed when receving a connection error.")
                                                         forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
    [self handleError:error];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self.usage_data appendData:data];
  return;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
  self.root_view_controller.ui_refresh.enabled = YES;
  if ([error code] == kCFURLErrorNotConnectedToInternet) {
    // if we can identify the error, we can present a more precise message to the user.
    NSDictionary *userInfo =
    [NSDictionary dictionaryWithObject:
     NSLocalizedString(@"No Connection Error",
                       @"Error message displayed when not connected to the Internet.")
                                forKey:NSLocalizedDescriptionKey];
    NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                     code:kCFURLErrorNotConnectedToInternet
                                                 userInfo:userInfo];
    [self handleError:noConnectionError];
  } else {
    [self handleError:error];
  }
  self.toolbox_connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  self.toolbox_connection = nil;
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
  self.root_view_controller.ui_refresh.enabled = YES;
  
  [self.parse_queue addOperation:[[SUsageParser alloc] initWithData:self.usage_data]];  
  self.usage_data = nil;
}

- (void)handleError:(NSError *)error {
  NSString *errorMessage = [error localizedDescription];
  UIAlertView *alertView =
  [[UIAlertView alloc] initWithTitle:
   NSLocalizedString(@"Unable to connect",
                     @"Title for alert displayed when download or parse error occurs.")
                             message:errorMessage
                            delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil];
  [alertView show];
}



@end
