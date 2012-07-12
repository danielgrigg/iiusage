//
//  SEditableCell.h
//  iiusage
//
//  Created by Daniel Grigg on 5/07/12.
//  Copyright (c) 2012 Daniel Grigg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEditableCell : UITableViewCell {

}

@property (strong, nonatomic) IBOutlet UITextField *text_field;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
