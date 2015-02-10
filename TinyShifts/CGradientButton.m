//
//  CGradientButton.m
//  ShinyButtonTest
//
//  Created by Dr. John M. Hinckley on 12/9/13.
//  Copyright (c) 2013 Hinckley Research Corporation. All rights reserved.
//

#import "CGradientButton.h"


@implementation CGradientButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initLayers];
    }
    return self;
}




-(void) initBorder
{
    CALayer* layer = self.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
}




-(void) addShineLayer
{
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = self.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.6f], //[NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.6f], //[NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [self.layer addSublayer:shineLayer];
}





-(void) addHighlightLayer
{
    highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:0.75f].CGColor;
    highlightLayer.frame = self.layer.bounds;
    highlightLayer.hidden = YES;
    [self.layer insertSublayer:highlightLayer below:shineLayer];
}




-(void) setHighlighted:(BOOL)highlighted
{
    highlightLayer.hidden = !highlighted;
    [super setHighlighted:highlighted];
}





-(void) initLayers
{
    [self initBorder];
    [self addShineLayer];
    [self addHighlightLayer];
}




-(void) awakeFromNib
{
    [self initLayers];
}






@end
