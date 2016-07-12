//
//  ViewController.m
//  IbeaconsReceive
//
//  Created by iOS-aFei on 16/5/21.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) UILabel *statusLabel;

@property(nonatomic, strong) UILabel *rssiLabel;

@property(nonatomic, strong) CLBeaconRegion *myBeaconRegion;
//保持对beacon region（我们即将进行检测的跟踪

@property(nonatomic, strong) CLLocationManager *locationManager;
//保存locationmanager，它会更新发现的beacons

@property(nonatomic, strong) UIImageView *arrowImageView;

@property(nonatomic, strong) CLLocation *currentLocation;

@property(nonatomic, strong) UIImageView *backView;

@property(nonatomic, strong) UIImageView *mySelf;
//标示最近的位置

@property(nonatomic, strong) UIImageView * targetImageView;
//在地图上显示的自己位置

@end

@implementation ViewController

NSString *uuidString = @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
//基站的uuid

#define W                  0.6
//基站矩形宽
#define H                  0.8
//基站矩形长


//屏幕宽度
#define kwindoWidth        self.view.frame.size.width
//屏幕长度
#define kwindowHeight      self.view.frame.size.height


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubView];
    //初始化界面控件
    self.locationManager = [[CLLocationManager alloc] init];
    //初始化CLLocationManager，监测位置，监测区域
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //    设置定位精度
    [self.locationManager startUpdatingLocation];
    //开始更新位置变化
    [self.locationManager startUpdatingHeading];
    //开始接收航向更新，更新方向变化，设置 指南针信息
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
    //作为一个接收app广播的对象
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    //监测区域，相应处理在代理方法中
}
#pragma - mark初始化界面控件
- (void)initSubView {
    self.mySelf = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.mySelf.layer.cornerRadius = 25;
    self.mySelf.backgroundColor = [UIColor redColor];
    self.mySelf.alpha = 0.5;
    
    self.targetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(- 100, -100, 40, 40)];
    self.targetImageView.layer.cornerRadius = 20;
    self.targetImageView.backgroundColor = [UIColor blueColor];
//    self.targetImageView.alpha = 0.5;

    //初始化自己的图标
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, kwindoWidth, kwindoWidth*4/3)];
//    backImageView.image = [UIImage imageNamed:@"backGround"];
//    [self.view addSubview:backImageView];
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, kwindoWidth, kwindoWidth*4/3)];
    _backView.backgroundColor = [UIColor lightGrayColor];
//    _backView.alpha = 0.5;
     [_backView addSubview:self.targetImageView];
     [self.view addSubview:_backView];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kwindoWidth - 80, 40)];
    self.statusLabel.text = @"玩命搜索基站...";
    self.statusLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.statusLabel];
    
    self.rssiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, kwindoWidth - 80, 40)];
    self.rssiLabel.text = @"玩命搜索基站...";
    self.rssiLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rssiLabel];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    self.arrowImageView.frame = CGRectMake(kwindoWidth - 80, 20, 80, 80);
    [self.view addSubview:self.arrowImageView];
    

    
    //初始化四个基站
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 50, 50);
    button1.tag = 1;
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 setTitle:@"基站1" forState:UIControlStateNormal];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 25;
    button1.backgroundColor = [UIColor whiteColor];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kwindoWidth - 50, 0, 50, 50);
    button2.tag = 2;
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 setTitle:@"基站2" forState:UIControlStateNormal];
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 25;
    button2.backgroundColor = [UIColor whiteColor];

    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(0, kwindoWidth*4/3-50, 50, 50);
    button3.tag = 3;
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button3 setTitle:@"基站3" forState:UIControlStateNormal];
    button3.layer.masksToBounds = YES;
    button3.layer.cornerRadius = 25;
    button3.backgroundColor = [UIColor whiteColor];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(kwindoWidth - 50, kwindoWidth*4/3 - 50, 50, 50);
    button4.tag = 4;
    [button4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button4 setTitle:@"基站4" forState:UIControlStateNormal];
    button4.layer.masksToBounds = YES;
    button4.layer.cornerRadius = 25;
    button4.backgroundColor = [UIColor whiteColor];

    [_backView addSubview:button1];
    [_backView addSubview:button2];
    [_backView addSubview:button3];
    [_backView addSubview:button4];
    //添加四个基站
}

#pragma -mark进入基站信号区
- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

#pragma -mark离开基站信号区
-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
    self.statusLabel.text = @"失去连接！！！";
}

#pragma -mark开始监测区域的基站
- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region{
    
}


//获得UUID（查找的标示），来自beacon的major（外层标示）和minor（内存标示）。
-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    double l[4] = {0.0, 0.0, 0.0, 0.0};
    //定义到四个基站的距离数组

    double min;
    int flag;
    for (CLBeacon *foundBeacon in beacons) {
        // You can retrieve the beacon data from its properties
        NSString *uuid = foundBeacon.proximityUUID.UUIDString;
        NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
        NSLog(@"/%@——————————accuracy:%f",minor,foundBeacon.accuracy);
//         NSLog(@"proximity:%ld",(long)foundBeacon.proximity);
//        distance距离，单位为米
//        db信号强度
        NSLog(@"%ld",(long)foundBeacon.rssi);
//        获取到对应点的距离
        switch (minor.integerValue) {
            case 1:     
                l[0] = foundBeacon.accuracy;
                break;
            case 2:
                l[1] = foundBeacon.accuracy;
                break;
            case 3:
                l[2] = foundBeacon.accuracy;
                break;
            case 4:
                l[3] = foundBeacon.accuracy;
                break;
            default:
                break;
        }
    }
    
    
    //遍历求最近距离
    if(l[0] >= 0 && l[1] >= 0 && l[2] >= 0)
    {
        min  = l[0];
        flag = 0;
        for (int i = 0; i < 3; i++) {
            if (l[i] < min) {
                min = l[i];
                flag = i;
            }
        }
        
        UIButton *target =  [_backView viewWithTag:flag + 1];
        //在地图上获取到最近的基站
        [target addSubview:self.mySelf];
        //添加标志
//        self.mySelf.center = target.center;
        for (CLBeacon *foundBeacon in beacons) {
            if (foundBeacon.minor.intValue == flag + 1) {
                self.rssiLabel.text = [NSString stringWithFormat:@"RSSI：%ld",(long)foundBeacon.rssi];
            }
        }
        self.statusLabel.text = [NSString stringWithFormat:@"基站：%d 距离：%f",flag + 1,l[flag]];

        [self caculteLocationWithX:(l[0]*l[0] - l[1]*l[1] + W*W)/(W*2)
                             withY:(l[0]*l[0] - l[2]*l[2] + H*H)/(H*2)];

    }
}

//    计算对应在地图上的位置，并刷新坐标。
- (void)caculteLocationWithX:(double)xMeter withY:(double)yMeter {
//    NSLog(@"+++++++%f %f",xMeter,yMeter);
//    计算在地图上坐标
    double x,y;
    x = xMeter/W * kwindoWidth;
    y = yMeter/H * (kwindoWidth*4/3);
    if (x < 0) {
        x = 0;
    }
    if(x > kwindoWidth - 40) {
        x = kwindoWidth - 40;
    }
    if (y < 0) {
        y = 0;
    }
    if(y > (kwindoWidth*4/3 - 40)) {
        y = kwindoWidth*4/3 - 40;
    }

    self.targetImageView.frame = CGRectMake(x, y, 40, 40);
    
}

//定位失败时调用下列两个方法
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}


//使用Core Location来获取航向(heading)
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    CGFloat heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
    self.arrowImageView.transform = CGAffineTransformMakeRotation(heading);
 
//    angel.text=[[NSString alloc]initWithFormat:@"angle:%f",newHeading.magneticHeading];
//    arrow.transform = CGAffineTransformMakeRotation(heading);
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
