//
//  CSAnnotationView.m
//  weiboOC
//
//  Created by 罗李 on 16/11/3.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import "CSAnnotationView.h"
#import <QuartzCore/QuartzCore.h>


#define Arror_height 15

@interface CSAnnotationView ()
@property (nonatomic, weak) id<CSAnnotationViewDelegate> delegate;

@end

@implementation CSAnnotationView


#pragma mark - contentView



- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<CSAnnotationViewDelegate>)delegate
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        //  显示callout
       
        
        self.backgroundColor = [UIColor clearColor];
#warning 
        
        self.centerOffset = CGPointMake(0, -55);
//        self.frame = CGRectMake(0, 0, 240, 100);
        if (delegate) {
            self.delegate = delegate;
            //  添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(annotationTapAction:)];
            [self addGestureRecognizer:tap];
        }
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 15)];
        contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:contentView];
        
        self.contentView = contentView;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}
-(void)annotationTapAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didSelectedAnnotationView:)]) {
            [self.delegate didSelectedAnnotationView:self];
    }

}
#warning
#pragma mark- 绘图
- (void)getDrawPath:(CGContextRef)context rect:(CGRect)rect
{
    CGRect rrect = rect;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDrawPath:context rect:self.bounds];
    CGContextFillPath(context);
    
    CGPathRef path = CGContextCopyPath(context);
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1;
    
    //insert
    self.layer.shadowPath = path;
    
}
@end
