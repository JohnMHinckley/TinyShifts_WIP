//
//  CGradientButton.h
//  ShinyButtonTest
//
//  Created by Dr. John M. Hinckley on 12/9/13.
//  Copyright (c) 2013 Hinckley Research Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CGradientButton : UIButton
{
    CAGradientLayer*    shineLayer;
    CALayer*            highlightLayer;
}

@end
