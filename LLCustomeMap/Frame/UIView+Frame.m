//
//  UIView+Frame.m
//  weiboOC
//
//  Created by 罗李 on 16/10/29.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (CGFloat)CenterX
{
    return self.center.x;
}
- (CGFloat)CenterY
{
    return self.center.y;
}
- (CGFloat)X
{
    return self.frame.origin.x;
}
- (CGFloat)Y
{
    return self.frame.origin.y;
}

- (CGFloat)Width
{
    return self.frame.size.width;
}

- (CGFloat)Height
{
    return self.frame.size.height;
}

-(void)setCenterY:(CGFloat)CenterY
{
    CGPoint myCenter = self.center;
    myCenter.y = CenterY;
    self.center = myCenter;
    
}

-(void)setCenterX:(CGFloat)CenterX
{
    CGPoint myCenter = self.center;
    myCenter.x = CenterX;
    self.center = myCenter;
}
-(void)setX:(CGFloat)X
{
    CGRect myFrame = self.frame;
    myFrame.origin.x = X;
    self.frame = myFrame;
}
-(void)setY:(CGFloat)Y
{
    CGRect myFrame = self.frame;
    myFrame.origin.y = Y;
    self.frame = myFrame;
}

-(void)setWidth:(CGFloat)Width
{
    CGRect myFrame = self.frame;
    myFrame.size.width = Width;
    self.frame = myFrame;
}
-(void)setHeight:(CGFloat)Height
{
    CGRect myFrame = self.frame;
    myFrame.size.height = Height;
    self.frame = myFrame;
}


@end
