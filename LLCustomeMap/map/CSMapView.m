//
//  mapView.m
//  weiboOC
//
//  Created by 罗李 on 16/11/3.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import "CSMapView.h"
#import "CSMapAnnotation.h"
#import "CSAnnotationView.h"
#import "UIView+Frame.h"
#import "CSView.h"

@interface CSMapView ()<MKMapViewDelegate,CLLocationManagerDelegate,CSAnnotationViewDelegate>

@property (nonatomic, weak) id<CSMapViewDelegate> csMapDelegate;

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, strong) CSMapAnnotation *calloutAnnotation;

@property (nonatomic, strong) UIStepper *stepper;

@end

@implementation CSMapView



- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupMap];
//        [self keepPGS];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<CSMapViewDelegate>)delegate
{
    if (self = [self init]) {
        self.csMapDelegate = delegate;
    }
    return self;
}

-(void)setupMap
{

    self.manager = [CLLocationManager new];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.manager requestWhenInUseAuthorization];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            self.manager.allowsBackgroundLocationUpdates = YES;
        }
    }
    
    self.gaoDeMapView = [[MKMapView alloc]init];
    self.gaoDeMapView.delegate = self;
    self.gaoDeMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [self addSubview:self.gaoDeMapView];
    

    
    self.span = 13000;
    
    [self setupUI];
}

- (void)setupUI
{
    //  MKCoordinateRegion adjustRegion = [self.gaoDeMapView regionThatFits:region];

    //  显示到自己的位置
    // 1. self.gaoDeMapView.userTrackingMode = MKUserTrackingModeFollow;
    // 2.MKCoordinateRegion myRegion = MKCoordinateRegionMake(self.gaoDeMapView.userLocation.location.coordinate, self.gaoDeMapView.region.span);
    //  self.gaoDeMapView.userLocation.location.coordinate
    //  self.gaoDeMapView.region.span
    
    
    //  控制显示的范围
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.gaoDeMapView.userLocation.location.coordinate, self.span, self.span);
    //  显示自己的区域
    [self.gaoDeMapView setRegion:region animated:YES];
}
- (void)startLoad
{
    for (NSInteger i=0; i < [self.csMapDelegate numbersWithCalloutViewForMapView]; i++) {
        //  遍历获取经纬度
        CLLocationCoordinate2D coordinate = [self.csMapDelegate coordinateForMapViewWithIndex:i];
        NSLog(@"%f----%f",coordinate.latitude,coordinate.longitude);
//          设置显示的大小
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, self.span, self.span);
//          设置默认的显示大小
         MKCoordinateRegion adjustRegion = [self.gaoDeMapView regionThatFits:region];
#warning
//          展示哪一个位置
        [self.gaoDeMapView setRegion:region animated:YES];
        
        
        [self customeAnnotationWithCoordinate:coordinate andTag:i];
    }
}
//  持续定位
- (void)keepPGS
{
    self.manager = [CLLocationManager new];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.manager requestWhenInUseAuthorization];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            self.manager.allowsBackgroundLocationUpdates = YES;
        }
    }
    self.manager.delegate = self;
    self.manager.distanceFilter = 10;
    [self.manager startUpdatingLocation];
}
#pragma mark- 自定义大头针
- (void)customeAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate andTag:(NSInteger)tag;
{
    CSMapAnnotation *basicAnnotation = [CSMapAnnotation new];
    basicAnnotation.coordinate = coordinate;
    basicAnnotation.tag = tag;

    [self.gaoDeMapView addAnnotation:basicAnnotation];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gaoDeMapView.frame = self.bounds;
}
- (void)gaoDeMapViewTap:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self.gaoDeMapView];
    CLLocationCoordinate2D coordinate = [self.gaoDeMapView convertPoint:tapPoint toCoordinateFromView:self.gaoDeMapView];
    NSInteger tag = coordinate.latitude + coordinate.longitude;
    [self customeAnnotationWithCoordinate:coordinate andTag:tag];
}

#pragma mark - delegateMothod
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
}

#pragma mark- mapView 的代理方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLGeocoder *geocoder = [CLGeocoder new];
    //  地理编码
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error != nil) {
            NSLog(@"该地点不存在");
            return;
        }
        CLPlacemark *placemark = placemarks.lastObject;
        
//        NSLog(@"%f,%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if ([view.annotation isKindOfClass:NSClassFromString(@"CSMapAnnotation")]) {
        CSMapAnnotation *headAnnotation = (CSMapAnnotation *)view.annotation;
       
        //  点击同一个annotation
        if (self.calloutAnnotation != headAnnotation) {
            //  只让显示一个annotation
            if (self.calloutAnnotation) {
                [mapView removeAnnotation:self.calloutAnnotation];
                self.calloutAnnotation = nil;
            }
            //  点击了annotation
            if (!self.calloutAnnotation.selected) {
                CSMapAnnotation *calloutAnnotation = [CSMapAnnotation new];
                calloutAnnotation.coordinate = headAnnotation.coordinate;
                calloutAnnotation.tag = headAnnotation.tag;
                self.calloutAnnotation = calloutAnnotation;
                self.calloutAnnotation.selected = !self.calloutAnnotation.selected;
                [mapView addAnnotation:calloutAnnotation];
                //  移动到中间的位置
                [mapView setCenterCoordinate:self.calloutAnnotation.coordinate animated:YES];
            }else{
                [mapView removeAnnotation:self.calloutAnnotation];
                self.calloutAnnotation = nil;
            
            }
        }
    }
    
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *systemKey = @"systemView";
    static NSString *cdKey = @"csCalloutView";
    
    if ([annotation isKindOfClass:NSClassFromString(@"CSMapAnnotation")]) {
        CSMapAnnotation *myAnnotation = (CSMapAnnotation*)annotation;
        if (!myAnnotation.selected) {
            
            MKAnnotationView *systemAnntotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:systemKey];
            if (!systemAnntotationView) {
                systemAnntotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:systemKey];
            }
            
            systemAnntotationView.canShowCallout = NO;
            systemAnntotationView.image = [self.csMapDelegate baseMKAnnotationViewImageWithIndex:0  ];
            
            return systemAnntotationView;
        
        }else{
    
            if ([annotation isKindOfClass:NSClassFromString(@"CSMapAnnotation")]) {
        
                CSAnnotationView *csAnnotationView = (CSAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"csCalloutView"];
      
                if (!csAnnotationView) {
            csAnnotationView = [[CSAnnotationView alloc]initWithAnnotation:myAnnotation reuseIdentifier:@"csCalloutView" andDelegate:self];
            
        }
                //  重复使用后会出现堆叠状况,所以要移除子控件
                for (UIView *subView in csAnnotationView.contentView.subviews) {
                    [subView removeFromSuperview];
                }
                csAnnotationView.canShowCallout = csAnnotationView.selected;
                 //  自定义view
                UIView *showView = [self.csMapDelegate mapViewCalloutContentViewWithIndex:self.calloutAnnotation.tag];
                csAnnotationView.frame = CGRectMake(0, 0, showView.Width, showView.Height + 15);
                [csAnnotationView.contentView addSubview:showView];
  
        return csAnnotationView;
        
        
    }
    }
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.gaoDeMapView removeFromSuperview];
    [self addSubview:self.gaoDeMapView];
    
}



- (void)didSelectedAnnotationView:(CSAnnotationView *)view
{
    
}





@end
