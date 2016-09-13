//
//  WJGravityImageView.m
//  CoreMotion
//
//  Created by 幻想无极（谭启宏） on 16/9/13.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJGravityImageView.h"
#import "WJGravity.h"

#define SPEED 30

@implementation WJGravityImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _myImageView = [[UIImageView alloc]init];
    [self addSubview:_myImageView];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    _myImageView.image = image;
    [_myImageView sizeToFit];
    _myImageView.frame = CGRectMake(0, 0, self.frame.size.height *(_myImageView.frame.size.width / _myImageView.frame.size.height), self.frame.size.height);
    _myImageView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
}

-(void)startAnimate
{
    //剩余部分滑动速度
    float scrollSpeed = (_myImageView.frame.size.width - self.frame.size.width)/2/SPEED;
    [WJGravity sharedGravity].timeInterval = 0.05;
    
    [[WJGravity sharedGravity]startDeviceMotionUpdatesBlock:^(float x, float y, float z) {
        NSLog(@"%f,%f,%f",x,y,z);
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
            
            //范围最左边到最右边
            if (_myImageView.frame.origin.x <=0 && _myImageView.frame.origin.x >= self.frame.size.width - _myImageView.frame.size.width)
            {
                float invertedYRotationRate = y * -1.0;
                
                //左右晃动y变化最大
                
                //_myImageView现在中心点坐标＋偏移的距离
                float interpretedXOffset = _myImageView.center.x + invertedYRotationRate * (_myImageView.frame.size.width/[UIScreen mainScreen].bounds.size.width) * scrollSpeed;
                
                //改变中心点位置
                _myImageView.center = CGPointMake(interpretedXOffset, _myImageView.center.y);
            }
            
            //如果超出最右边，固定位置不变
            if (_myImageView.frame.origin.x >0)
            {
                _myImageView.frame = CGRectMake(0, _myImageView.frame.origin.y, _myImageView.frame.size.width, _myImageView.frame.size.height);
            }
            //如果超出最左边，固定位置不变
            if (_myImageView.frame.origin.x < self.frame.size.width - _myImageView.frame.size.width)
            {
                _myImageView.frame = CGRectMake(self.frame.size.width - _myImageView.frame.size.width, _myImageView.frame.origin.y, _myImageView.frame.size.width, _myImageView.frame.size.height);
            }
        } completion:nil];
        
        
    }];
}

-(void)stopAnimate
{
    [[WJGravity sharedGravity] stop];
}

@end
