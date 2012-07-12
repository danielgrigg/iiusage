//
//  SEditableCell.m
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import "SEditableCell.h"

@implementation SEditableCell

@synthesize text_field, label;


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
 
  [super setEditing:editing animated:animated];
//  text_field.enabled = editing;
}

@end
