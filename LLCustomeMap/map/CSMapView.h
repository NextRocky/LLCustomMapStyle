//
//  mapView.h
//  weiboOC
//
//  Created by 罗李 on 16/11/3.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol CSMapViewDelegate <NSObject>

// 标签个数
- (NSInteger)numbersWithCalloutViewForMapView;
//  不同的经纬度
- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index;
//  calloutContentView
- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index;
// 大头针图片
- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index;

@end

@interface CSMapView : UIView

@property (nonatomic, strong)  MKMapView *gaoDeMapView;

@property (nonatomic, assign) double span;// default = 40000;

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithDelegate:(id<CSMapViewDelegate>)delegate;
- (void)startLoad;
@end
