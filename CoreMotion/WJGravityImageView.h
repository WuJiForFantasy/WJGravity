//
//  WJGravityImageView.h
//  CoreMotion
//
//  Created by 幻想无极（谭启宏） on 16/9/13.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>

/**实现左右偏移显示图片左边右边部分*/
@interface WJGravityImageView : UIView

/**
 *  显示的图片
 */
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong,readonly) UIImageView * myImageView;

/**
 *  开始重力感应
 */
-(void)startAnimate;

/**
 *  停止重力感应
 */
-(void)stopAnimate;

@end
