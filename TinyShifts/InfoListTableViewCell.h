//
//  InfoListTableViewCell.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/17/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelInfoListTableCell;   // outlet for the displayed label in the cell
@property (nonatomic) NSInteger index;  // index of the cell in the table

@end
