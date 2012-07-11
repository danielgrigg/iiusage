//
//  SUsage.m
//  iiusage
//
//  Created by Daniel Grigg on 7/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "SUsage.h"

@implementation SUsageCategory

@synthesize category, bytes_used, bytes_allocated, is_shaped;

-(id) init_with_category_name:(NSString*)a_category 
{
  self.category = a_category;
  self.bytes_used = 0;
  self.bytes_allocated = 0;
  self.is_shaped = NO;
  return self;
}

-(BOOL) over_quota
{
  return bytes_used > bytes_allocated;
}

@end

@implementation SUsage

@synthesize days_remaining, peak_used_bytes, offpeak_used_bytes, categories;

@end
