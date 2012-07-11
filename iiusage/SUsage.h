//
//  SUsage.h
//  iiusage
//
//  Created by Daniel Grigg on 7/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUsageCategory : NSObject {
  NSString* category;
  long long bytes_used;
  long long bytes_allocated;
  BOOL is_shaped;
}
@property (nonatomic, strong) NSString* category;
@property (nonatomic, assign) long long bytes_used;
@property (nonatomic, assign) long long bytes_allocated;
@property (nonatomic, assign) BOOL is_shaped;

-(id) init_with_category_name:(NSString*)a_category; 
-(BOOL) over_quota;

@end


@interface SUsage : NSObject {
@private
  int days_remaining;
  NSDictionary* categories;
}

@property (nonatomic, assign) int days_remaining;
@property (nonatomic, assign) long long peak_used_bytes;
@property (nonatomic, assign) long long offpeak_used_bytes;
@property (nonatomic, strong) NSDictionary* categories;

@end
