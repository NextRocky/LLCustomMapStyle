//
//  CSMaoAnnotatoin.m
//  weiboOC
//
//  Created by 罗李 on 16/11/3.
//  Copyright © 2016年 罗李. All rights reserved.
//

#import "CSMapAnnotation.h"

@implementation CSMapAnnotation
- (instancetype)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
                          andTag:(NSInteger)tag
{
    if (self = [super init]) {
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        self.tag = tag;
    }
    return self;
}

@end
