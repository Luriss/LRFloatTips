# LRFloatTips
悬浮提示条



使用方法简单，一句话添加该功能。

eg..

- (void)buttonClicked:(UIButton *)btn

{

    switch (btn.tag)
    {
    
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




![image](https://github.com/Luriss/LRFloatTips/blob/master/LRFloatTips/showTips.gif)
