//
//  SUsageParser.h
//  iiusage
//
//  Created by Daniel Grigg on 6/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

extern NSString* NOTIF_USAGE;
extern NSString* NOTIF_PARSE_ERROR;

@class SUsage;
@class SUsageCategory;

@interface SUsageParser : NSOperation {
@private
  NSData *usage_data;
  NSMutableString* pcdata;
  NSString* xpath;
  SUsage* parsed_usage;
  BOOL accumulate_pcdata;
  SUsageCategory* parsing_category;
  NSMutableDictionary* parsed_categories;
}

@property (copy, readonly) NSData *usage_data;
- (id)initWithData:(NSData *)data; 

@end
