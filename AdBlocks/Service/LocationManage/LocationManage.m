//
//  LocationManage.m
//  daikuanchaoshi
//
//  Created by Sj03 on 2017/11/28.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#import "LocationManage.h"
#import <MapKit/MapKit.h>


@interface LocationManage ()<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager* locationManager;
@property (nonatomic, copy)void(^successBlock)(NSString * , NSString * ,NSString *name);
@property (nonatomic, copy)void(^faildBlock)(void);
@end


@implementation LocationManage
static LocationManage *manage = nil;
+ (instancetype)shareLocationManage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[LocationManage alloc] init];
    });
    return manage;
}


- (void)startLocation:(void(^)(NSString * , NSString *, NSString *name))successBlock andfailureBlock:(void(^)(void))faildBlock{
    self.successBlock = successBlock;
    self.faildBlock = faildBlock;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if (@available(iOS 9.0, *)) {
//            _locationManager.allowsBackgroundLocationUpdates =YES;
        } else {
            // Fallback on earlier versions
        }
    }
    [self.locationManager startUpdatingLocation];
    


}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.faildBlock();
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    [manager stopUpdatingLocation];
    NSString *lon = [NSString stringWithFormat:@"%f",oldCoordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",oldCoordinate.latitude];

    [self.locationManager stopUpdatingHeading];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *place in placemarks) {
            self.successBlock(lon, lat,place.locality);
        }
    }];
}
@end
