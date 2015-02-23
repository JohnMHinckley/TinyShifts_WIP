//
//  TableDatum.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/22/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableDatum : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* backgroundImageFilename;
@property (nonatomic, strong) NSString* supplementaryImageFilename;

@end
