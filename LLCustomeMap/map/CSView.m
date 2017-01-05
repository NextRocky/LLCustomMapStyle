//
//  CSView.m
//  weiboOC
//
//  Created by 罗李 on 16/11/3.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import "CSView.h"
#import <Masonry.h>
#import "UIView+Frame.h"

#define MARGIN 5
@interface CSView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CSView

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)setDistance:(NSString *)distance
{
    _distance = distance;
    self.distanceLabel.text = distance;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor redColor];
        _imageView.image = [UIImage imageNamed:@"pin"];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.backgroundColor = [UIColor blueColor];
        _subTitleLabel.textColor = [UIColor grayColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [UILabel new];
        _distanceLabel.backgroundColor = [UIColor redColor];
        _distanceLabel.textColor = [UIColor blueColor];
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton new];
        [_btn setTitle:@"GO" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _btn.backgroundColor = [UIColor redColor];
        [_btn addTarget:self action:@selector(goToAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btn];
    }
    return _btn;
}

- (void)goToAction:(UIButton *)sender
{
    if (self.buttonClickBlock) {
        self.buttonClickBlock();
    }
    
}

+ (instancetype)cusShowViewWithBlock:(void(^)())buttonClickBlock andFrame:(CGRect)frame
{
    
    return [[self alloc]initWithFrame:frame andBlock:buttonClickBlock];
}

- (instancetype)initWithFrame:(CGRect)frame andBlock:(void(^)())buttonClickBlock
{
    if (self = [super initWithFrame:frame]) {
        self.buttonClickBlock = buttonClickBlock;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(MARGIN) ;
        make.top.equalTo(self).offset(5);
        make.trailing.equalTo(self).offset(-5);
        make.height.mas_equalTo((self.Height - 4 * MARGIN) / 3) ;
    }];

    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(MARGIN);
        make.trailing.equalTo(self).offset(-MARGIN);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(MARGIN);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(MARGIN);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(MARGIN);
        make.height.width.mas_equalTo((self.Height - 4 * MARGIN) / 3);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imageView.mas_trailing).offset(MARGIN);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(MARGIN);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo((self.Height - 4 * MARGIN) / 3);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-MARGIN);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(MARGIN);
        make.height.mas_equalTo((self.Height - 4 * MARGIN) / 3);
        make.leading.equalTo(self.distanceLabel.mas_trailing).offset(MARGIN);
    }];
    
    /**
     *  1.添加约束的元素
     *  2.约束属性(top ,bottom ...)
     *  3.相对关系
     *  4.相对约束对象
     *  5.相对比例(0.0)
     *  6.约束距离
     */
#warning AutoResizing跟Autolayout不能共存,如果想要使用代码添加Autolayout 需要关闭AutoResizing
    //  关闭控件的autoResizing

    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //  创建约束
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.subTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:(MARGIN)];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.subTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.subTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.subTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(self.Height - 4 * MARGIN) / 3];
    //  添加约束 父控件添加
    [self addConstraints:@[top,leading,trailing,height]];


    
}
@end
