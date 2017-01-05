//
//  CSAnnotationView.h
//  weiboOC
//
//  Created by 罗李 on 16/11/3.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import <MapKit/MapKit.h>
@class CSAnnotationView;
@protocol CSAnnotationViewDelegate <NSObject>

- (void)didSelectedAnnotationView:(CSAnnotationView *)view;

@end
@interface CSAnnotationView : MKAnnotationView
@property (nonatomic, strong) UIView *contentView;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<CSAnnotationViewDelegate>)delegate;
@end


