//
//  UnpleasantMoodTableViewCell.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnpleasantMoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUnpleasantMoodTableCell;
@property (nonatomic) NSInteger index;  // index of the cell in the table

@end
