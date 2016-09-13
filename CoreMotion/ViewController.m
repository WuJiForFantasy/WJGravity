//
//  ViewController.m
//  CoreMotion
//
//  Created by 幻想无极（谭启宏） on 16/9/13.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "WJGravityImageView.h"

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) NSOperationQueue *quene;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
////    // 初始化 CMMotionManager
////    
////    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1"]];
////    self.imageView.frame = CGRectMake(0, 0, 1000, 1000);
//////    self.imageView.image = [UIImage imageNamed:@"pic1"];
////    self.imageView.center = self.view.center;
////    
////    [self.view addSubview:self.imageView];
////    
////    self.motionManager = [[CMMotionManager alloc]init];
////    
////    // 初始化 NSOperationQueue
////    self.quene = [[NSOperationQueue alloc]init];
////    
////    // 调用加速器
//////    [self configureAccelerometer];
////    
////    // 调用陀螺仪
//////    [self configureGrro];
////    [self custom];
//////    self.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
//    
//    
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WJGravityImageView *imageView = [[WJGravityImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"pic1"];
    //    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
    [imageView startAnimate];
}
// 加速器的方法
- (void)configureAccelerometer
{
    /**
     * 5.0之前使用的是pull方式,之后使用push方式
     *
     // pull 方式
     // 判断加速器是否可以使用
     if ([_motionManager isAccelerometerAvailable]) {
     [_motionManager setAccelerometerUpdateInterval:1 / 40.0];
     [_motionManager startAccelerometerUpdates];
     }else{
     NSLog(@"加速器不能使用");
     }
     */
    
    // push 方式
    
    __weak ViewController *myself = self;
    
    if ([_motionManager isAccelerometerAvailable]) {
        // 设置加速器的频率
//        [_motionManager setAccelerometerUpdateInterval:0.1];
        // 开始采集数据
        [_motionManager startAccelerometerUpdatesToQueue:_quene withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            if (fabs(accelerometerData.acceleration.x) > 2.0 || fabs(accelerometerData.acceleration.y) > 2.0 || fabs(accelerometerData.acceleration.z) > 2.0) {
                NSLog(@"检测到震动");
            }
            NSLog(@"%.2f__%.2f__%.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
            
            double rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) - M_PI;
           
            dispatch_async(dispatch_get_main_queue(), ^{
                myself.imageView.transform = CGAffineTransformMakeRotation(rotation);
            });
            
            
        }];
    }else{
        NSLog(@"加速器不能使用");
    }
    
    
}

// 触摸结束的时候
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CMAcceleration acceleration = _motionManager.accelerometerData.acceleration;
    NSLog(@"%.2f__%.2f__%.2f",acceleration.x,acceleration.y,acceleration.z);
}

// 陀螺仪的使用
- (void)configureGrro
{
    if ([_motionManager isGyroAvailable]) {
        [_motionManager setGyroUpdateInterval:0.2];
        [self.motionManager startGyroUpdatesToQueue:_quene withHandler:^(CMGyroData *gyroData, NSError *error) {
            
            NSLog(@"%.2f__%.2f__%.2f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
            double gravityX = self.motionManager.deviceMotion.gravity.x;
            double gravityY = self.motionManager.deviceMotion.gravity.y;
            double gravityZ = self.motionManager.deviceMotion.gravity.z;
            //获取手机的倾斜角度：
            double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
            double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
            NSLog(@"%f   -----   %f",zTheta,xyTheta);
            self.imageView.transform = CGAffineTransformMakeRotation(xyTheta);
            //zTheta是手机与水平面的夹角， xyTheta是手机绕自身旋转的角度
//            self.imageView.transform = CGAffineTransformMakeRotation(-gyroData.rotationRate.x);
            
           
            
        }];
    }else{
        NSLog(@"陀螺仪不能使用");
    }
}

- (void)custom {
    if ([_motionManager isDeviceMotionAvailable]) {
        [_motionManager setDeviceMotionUpdateInterval:1];
        [self.motionManager startDeviceMotionUpdatesToQueue:_quene withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            double gravityX = motion.gravity.x;
            double gravityY = motion.gravity.y;
            double gravityZ = motion.gravity.z;
            NSLog(@"%f,%f,%f",gravityX,gravityY,gravityZ);
            //获取手机的倾斜角度：
            double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
            double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
            NSLog(@"%f-----%f",zTheta,xyTheta);
//            static NSInteger index = 1;
//            index++;

        double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.imageView.transform = CGAffineTransformMakeRotation(rotation);
                
            }];
           
        }];
    }
}

-(double)radians:(double)degrees

{    return degrees * M_PI/180;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
}

// 开始晃动的时候触发
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始晃动");
}

// 结束晃动的时候触发
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"晃动结束");
}

// 中断晃动的时候触发
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消晃动,晃动终止");
}

@end
