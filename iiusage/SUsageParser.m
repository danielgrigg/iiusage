//
//  SUsageParser.m
//  iiusage
//
//  Created by Daniel Grigg on 6/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "SUsageParser.h"
#import "SUsage.h"

NSString* NOTIF_USAGE = @"usage";
NSString* NOTIF_PARSE_ERROR = @"parse_error";

@interface SUsageParser () <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableString *pcdata;  
@property (nonatomic, strong) NSString *xpath;  
@property (nonatomic, strong) SUsage* parsed_usage;
@property (nonatomic, strong) SUsageCategory* parsing_category;
@property (nonatomic, strong) NSMutableDictionary* parsed_categories;
@end

@implementation SUsageParser

@synthesize usage_data, pcdata, xpath, parsed_usage, 
  parsing_category, parsed_categories;

- (id)initWithData:(NSData *)data { 
  if (self = [super init]) {    
    usage_data = [data copy];
  }
  return self;
}

- (void)publish_usage:(SUsage*)u {
  assert([NSThread isMainThread]);
  
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USAGE
                                                      object:self
                                                    userInfo:[NSDictionary dictionaryWithObject:u
                                                                                         forKey:NOTIF_USAGE]]; 
}

// the main function for this NSOperation, to start the parsing
- (void)main {
  
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.usage_data];
  [parser setDelegate:self];
  [parser parse];
  
  if (parsed_usage != nil) {
    
    [self performSelectorOnMainThread:@selector(publish_usage:)
                           withObject:self.parsed_usage
                        waitUntilDone:NO];
  }
}

static NSString* days_remaining_path = @"ii_feed/volume_usage/quota_reset/days_remaining";
static NSString* traffic_types_path = @"ii_feed/volume_usage/expected_traffic_types/type";
static NSString* quota_allocation_path = @"ii_feed/volume_usage/expected_traffic_types/type/quota_allocation";
static NSString* error_path = @"ii_feed/error";

#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
  self.xpath = @"";
  self.parsed_usage = [SUsage new];
  self.parsed_categories = [NSMutableDictionary new];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  self.parsed_usage.categories = 
    [[NSDictionary alloc] initWithDictionary:self.parsed_categories];
}

- (void)startParsingPCDATA 
{
  accumulate_pcdata = YES;
  self.pcdata = [NSMutableString new];
}

- (void)stopParsingPCDATA 
{
  accumulate_pcdata = NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict 
{
  
  if (NO) {
    [parser abortParsing];
  }
  
  self.xpath = [self.xpath stringByAppendingPathComponent:elementName];
  //  NSLog(@"start xpath: %@", self.xpath);
  
  if ([self.xpath isEqualToString:days_remaining_path]) {
    [self startParsingPCDATA];
  }
  else if ([self.xpath isEqualToString:traffic_types_path]) 
  {
    NSString *cname = [attributeDict valueForKey:@"classification"];
    self.parsing_category = 
      [[SUsageCategory alloc] init_with_category_name:cname];
    NSScanner* scanner = 
    [NSScanner scannerWithString:[attributeDict valueForKey:@"used"]];
    long long bytes_used = 0;
    if ([scanner scanLongLong:&bytes_used]) 
    {
      self.parsing_category.bytes_used = bytes_used;
    }
  }
  else if ([self.xpath isEqualToString:quota_allocation_path])
  {
    [self startParsingPCDATA];
  }
  else if ([xpath isEqualToString:error_path])
  {
    
  }
  
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {     
  
  //  NSLog(@"end xpath: %@", self.xpath);
  [self stopParsingPCDATA];
  
  if ([self.xpath isEqualToString:days_remaining_path]) 
  {
    NSScanner *scanner = [NSScanner scannerWithString:self.pcdata];
    int days_remaining;
    if ([scanner scanInt:&days_remaining]) 
    {
      self.parsed_usage.days_remaining = days_remaining;
    }
  }
  else if ([self.xpath isEqualToString:quota_allocation_path])
  {
    NSScanner *scanner = [NSScanner scannerWithString:self.pcdata];
    long long mb_allocated;
    if ([scanner scanLongLong:&mb_allocated]) 
    {
      self.parsing_category.bytes_allocated = 1000 * 1000 * mb_allocated;
    }
  }
  else if ([self.xpath isEqualToString:traffic_types_path]) 
  {
    [self.parsed_categories setObject:parsing_category 
                               forKey:parsing_category.category];
  }
  
  self.xpath = [self.xpath stringByDeletingLastPathComponent];
  
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if (accumulate_pcdata) {
    [self.pcdata appendString:string];
  }
}

- (void)handleParsingError:(NSError *)parseError 
{
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_PARSE_ERROR
                                                      object:self
                                                    userInfo:[NSDictionary dictionaryWithObject:parseError
                                                                                         forKey:NOTIF_PARSE_ERROR]];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
  parsed_usage = nil;
  
  if ([parseError code] != NSXMLParserDelegateAbortedParseError)
  {
    [self performSelectorOnMainThread:@selector(handleParsingError:)
                           withObject:parseError
                        waitUntilDone:NO];
  }
}

@end
