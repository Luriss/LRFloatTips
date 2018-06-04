//
//  LRFloatTips.h
//  hrcfc
//
//  Created by Luris on 2018/5/18.
//  Copyright © 2018年 Luris. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 对话框样式的悬浮小贴士说明
 可根据显示位置自动适配对话框箭头位置。
 */
@interface LRFloatTips : UIView


/**
 显示视图, 显示后，再次点击屏幕消失
 
 @param forView  需要添加的 View  eg.: 点击按钮button，则此处forView 传 button。
 @param content 内容
 */
+ (void)addTipsForView:(UIView *)forView
              content:(NSString *)content;

/**
 显示视图，显示后，再次点击屏幕消失 或 一段时间后消失

 @param forView  需要添加的 View eg.: 点击按钮button，则此处forView 传 button。
 @param content 内容
 @param delay 时间
 */
+ (void)addTipsForView:(UIView *)forView
              content:(NSString *)content
           afterDelay:(NSTimeInterval )delay;


@end
