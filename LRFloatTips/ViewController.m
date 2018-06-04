//
//  ViewController.m
//  LRFloatTips
//
//  Created by luris on 2018/6/4.
//  Copyright © 2018年 luris. All rights reserved.
//

#import "ViewController.h"
#import "LRFloatTips.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)demo
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor blackColor];
    btn1.frame = CGRectMake(30, 70, 30, 30);
    btn1.layer.cornerRadius = 15;
    btn1.tag  = 1;
    [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor blackColor];
    btn2.frame = CGRectMake(self.view.frame.size.width - 60, 70, 30, 30);
    btn2.layer.cornerRadius = 15;
    btn2.tag  = 2;
    [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn2];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = [UIColor blackColor];
    btn3.frame = CGRectMake(self.view.frame.size.width*0.5 - 15, self.view.frame.size.height*0.5 - 30, 30, 30);
    btn3.layer.cornerRadius = 15;
    btn3.tag  = 3;
    [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn3];
    
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.backgroundColor = [UIColor blackColor];
    btn4.frame = CGRectMake(30, self.view.frame.size.height - 60, 30, 30);
    btn4.layer.cornerRadius = 15;
    btn4.tag  = 4;
    [btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn4];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.backgroundColor = [UIColor blackColor];
    btn6.frame = CGRectMake(self.view.frame.size.width - 100,self.view.frame.size.height - 60, 30, 30);
    btn6.layer.cornerRadius = 15;
    btn6.tag  = 6;
    [btn6 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn6];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.backgroundColor = [UIColor blackColor];
    btn5.frame = CGRectMake(self.view.frame.size.width - 60,self.view.frame.size.height - 60, 30, 30);
    btn5.layer.cornerRadius = 15;
    btn5.tag  = 5;
    [btn5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn5];
}

- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
        {
            [LRFloatTips addTipsForView:btn content:@"我就是这么傲娇"];
        }
            break;
        case 2:
        {
            [LRFloatTips addTipsForView:btn content:@"我就是这么的骄傲！！！"];
        }
            break;
        case 3:
        {
            [LRFloatTips addTipsForView:btn content:@"秒杀一切的存在，速来跪舔"];
        }
            break;
        case 4:
        {
            [LRFloatTips addTipsForView:btn content:@"他们都不要脸"];
        }
            break;
        case 5:
        {
            [LRFloatTips addTipsForView:btn content:@"我的老家就住在这个屯，我是这个屯里土生土长的人,我的老家就住在这个屯，我是这个屯里土生土长的人" afterDelay:3];
        }
            break;
        case 6:
        {
            [LRFloatTips addTipsForView:btn content:@"我的老家就住在这个屯" afterDelay:3];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
