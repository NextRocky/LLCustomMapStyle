//
//  ViewController.m
//  LLCustomeMap
//
//  Created by 罗李 on 17/1/5.
//  Copyright © 2017年 罗李. All rights reserved.
//

#import "ViewController.h"
#import "CSMapView.h"
#import "CSView.h"
@interface ViewController ()<CSMapViewDelegate>
@property (nonatomic, strong) NSArray *annotations;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMap];
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //  设置透明导航条
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    //  设置透明导航条
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}


-(void)setMap
{
    self.annotations = @[@{@"latitude":@"31.286725",//37.786725,114.412693
                           @"longitude":@"121.394694",
                           @"title":@"test-title-1",
                           @"subtitle":@"test-sub-title-11",
                           @"distance":@"10KM"
                           },
                         @{@"latitude":@"31.306725",
                           @"longitude":@"121.37069",
                           @"title":@"test-title-2",
                           @"subtitle":@"test-sub-title-22",
                           @"distance":@"10KM"
                           },
                         @{@"latitude":@"31.306725",
                           @"longitude":@"121.401696",
                           @"title":@"test-title-3",
                           @"subtitle":@"test-sub-title-33",
                           @"distance":@"10KM"
                           },
                         @{@"latitude":@"31.306725",
                           @"longitude":@"121.423698",
                           @"title":@"test-title-4",
                           @"subtitle":@"test-sub-title-44",
                           @"distance":@"10KM"
                           }
                         ];
    
    
    CSMapView *csMapView = [[CSMapView alloc]initWithDelegate:self];
    
    csMapView.frame = self.view.bounds;
    
    [self.view addSubview:csMapView];
    
    [csMapView startLoad];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}
// 标签个数
- (NSInteger)numbersWithCalloutViewForMapView{
    return self.annotations.count;
}
//  不同的经纬度
- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index{
    NSDictionary *dic = self.annotations[index];
    NSString *latitudeStr = dic[@"latitude"];//latitudeStr
    NSString *longitudeStr = dic[@"longitude"];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitudeStr.doubleValue , longitudeStr.doubleValue);
    return coordinate;
}
//  calloutContentView
- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index{
    NSDictionary *dic = self.annotations[index];
    CSView *cusView = [CSView cusShowViewWithBlock:^{
        [self.navigationController pushViewController:[UITableViewController new] animated:YES];
    } andFrame:CGRectMake(0, 0, 240, 80)];
    
    cusView.title = dic[@"test-title-4"];
    cusView.subTitle = dic[@"test-sub-title-44"];
    cusView.distance = dic[@"distance"];
    return cusView;
}
// 大头针图片
- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index{
    return [UIImage imageNamed:@"pin"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
