//
//  CSView.h
//  weiboOC
//
//  Created by 罗李 on 16/11/3.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) void(^buttonClickBlock)();
+ (instancetype)cusShowViewWithBlock:(void(^)())buttonClickBlock andFrame:(CGRect)frame;
@end
