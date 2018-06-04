//
//  LRFloatTips.m
//  hrcfc
//
//  Created by Luris on 2018/5/18.
//  Copyright © 2018年 Luris. All rights reserved.
//

#import "LRFloatTips.h"

#define LR_CONTENT_LABEL_MIN_WIDTH (60)
#define LR_CONTENT_LABEL_MIN_HIGHT (30)
#define LR_CONTENT_LABEL_OFFSET (15)

#define LR_ARROW_HIGHT (8)


/**
 对话框箭头方向

 - LRFloatTipsArrowDirectionTopLeft:        上 -- 左
 - LRFloatTipsArrowDirectionTopCenter:      上 -- 中
 - LRFloatTipsArrowDirectionTopRight:       上 -- 右
 - LRFloatTipsArrowDirectionBottomLeft:     下 -- 左
 - LRFloatTipsArrowDirectionBottomCenter:   下 -- 中
 - LRFloatTipsArrowDirectionBottomRight:    下 -- 右
 */
typedef NS_ENUM(NSInteger, LRFloatTipsArrowDirection) {
    LRFloatTipsArrowDirectionTopLeft        = 0,
    LRFloatTipsArrowDirectionTopCenter,
    LRFloatTipsArrowDirectionTopRight,
    LRFloatTipsArrowDirectionBottomLeft,
    LRFloatTipsArrowDirectionBottomCenter,
    LRFloatTipsArrowDirectionBottomRight,
};



/**
 可设置文字内边距的 label
 */
@interface LRLabel :UILabel

@property (nonatomic, assign)UIEdgeInsets textInsets; // 控制字体与控件边界的间隙

@end


@implementation LRLabel

- (instancetype)init
{
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets
{
    _textInsets = textInsets;
    
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end



@interface LRFloatTips ()
{
    CGFloat     _screenW;       //  [UIScreen mainScreen].bounds.size.width
    CGFloat     _screenH;       //  [UIScreen mainScreen].bounds.size.height)
    
    BOOL        _isLeft;        // arrow is left?
    BOOL        _isTop;         // arrow is top ?
}


@property (nonatomic, assign)CGPoint        viewOrigin;     // 需要显示tips的View的(x,y)
@property (nonatomic, assign)CGSize         viewSize;       // 需要显示tips的View的(w,h)
@property (nonatomic, assign)CGSize         contentSize;    // tips内容大小 (w,h)
@property (nonatomic, strong)NSDictionary    *attributes;

@property (nonatomic, strong)LRLabel        *contentL;      // show tips label
@property (nonatomic, assign)LRFloatTipsArrowDirection  arrowDirection;


@end


@implementation LRFloatTips

- (instancetype)initWithView:(UIView *)forView content:(NSString *)content
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        NSAssert(forView, @"toView must not be nil");
        
        self.backgroundColor = [UIColor clearColor];
        _screenW = [UIScreen mainScreen].bounds.size.width;
        _screenH = [UIScreen mainScreen].bounds.size.height;
        
        // 转化为相对于屏幕的坐标
        CGRect frame = [self getViewFrameToWindow:forView];
        
        // 计算文字内容大小
        self.contentSize = [self calculateContentSize:content];

        self.viewOrigin = frame.origin;
        self.viewSize = frame.size;
        
        // 判断箭头位置
        [self adjustArrowDirection];

        // 添加文字展示 label
        [self addSubview:self.contentL];
        self.contentL.attributedText = [[NSAttributedString alloc] initWithString:content attributes:self.attributes];
    }
    return self;
}



#pragma mark --- Private Method

- (CGSize )calculateContentSize:(NSString *)string
{
    // 先高度一定，计算宽度
    CGSize  strSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, LR_CONTENT_LABEL_MIN_HIGHT)  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)  attributes:self.attributes context:nil].size;
    
    CGFloat w = strSize.width + LR_CONTENT_LABEL_OFFSET; // 加上一点，为了美观

    // 若计算后的文字长度超过最大长度，则以最大长度计算高度
    if (w > (_screenW - 30)) {
        w = _screenW - 30;
        strSize = [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT)  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)  attributes:self.attributes context:nil].size;
    }

    CGFloat h = strSize.height + LR_CONTENT_LABEL_OFFSET;
    
    if (h < LR_CONTENT_LABEL_MIN_HIGHT) {
        h = LR_CONTENT_LABEL_MIN_HIGHT;
    }
    
    if (w < LR_CONTENT_LABEL_MIN_WIDTH) {
        w = LR_CONTENT_LABEL_MIN_WIDTH;
    }
    
    return CGSizeMake(w, h);
}

// 判断箭头位置
- (void)adjustArrowDirection
{
    // 需要显示tips的View的中心 X,Y
    CGFloat centerX = self.viewOrigin.x + self.viewSize.width*0.5;
    CGFloat centerY = self.viewOrigin.y + self.viewSize.height*0.5;

    // 说明顶部空间不够，View需要放在下面,箭头向上
    if (centerY < _screenH*0.2) {
        _isTop = YES;
        CGFloat offsetR = centerX + self.contentSize.width*0.5;
        
        // 15 是离屏幕的距离，留出来，为了美观
        // 说明超出了屏幕宽度
        if (offsetR > (_screenW-LR_CONTENT_LABEL_OFFSET)) {
            _isLeft = NO;
            // 说明箭头位于右边
            self.arrowDirection = LRFloatTipsArrowDirectionTopRight;
            return;
        }
        
        CGFloat offsetL = centerX - self.contentSize.width*0.5;
        if (offsetL < LR_CONTENT_LABEL_OFFSET) {
            // 说明箭头位于左边
            _isLeft = YES;
            self.arrowDirection = LRFloatTipsArrowDirectionTopLeft;
            return;
        }
        
        // 说明箭头位于中间
        self.arrowDirection = LRFloatTipsArrowDirectionTopCenter;
        return;
    }
    
    // 说明顶部空间够，View需要放在上面,箭头向下
    _isTop = NO;
    CGFloat offsetR = centerX + self.contentSize.width*0.5;
    
    // 15 是离屏幕的距离，留出来，为了美观
    // 说明超出了屏幕宽度
    if (offsetR > (_screenW-LR_CONTENT_LABEL_OFFSET)) {
        _isLeft = NO;
        // 说明箭头位于右边
        self.arrowDirection = LRFloatTipsArrowDirectionBottomRight;
        return;
    }
    
    CGFloat offsetL = centerX - self.contentSize.width*0.5;
    if (offsetL < 15) {
        // 说明箭头位于左边
        _isLeft = YES;
        self.arrowDirection = LRFloatTipsArrowDirectionBottomLeft;
        return;
    }
    
    // 说明箭头位于中间
    self.arrowDirection = LRFloatTipsArrowDirectionBottomCenter;
}


// 移除View
- (void)dismissView
{
    if (self.contentL) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.contentL removeFromSuperview];
            [self removeFromSuperview];
            self.contentL = nil;
        }];
    }
}


/**
 显示 View
 */
- (void)showView
{
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 获取 文字展示 label的 frame

 @return frame
 */

- (CGRect )getContentLabelFrame
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    switch (self.arrowDirection) {
        case LRFloatTipsArrowDirectionTopLeft:{
            x = LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y + self.viewSize.height + LR_ARROW_HIGHT;
            break;
        }
        case LRFloatTipsArrowDirectionTopCenter:{
            x = self.viewOrigin.x + self.viewSize.width*0.5 - self.contentSize.width*0.5;
            y = self.viewOrigin.y + self.viewSize.height + LR_ARROW_HIGHT;
            break;
        }
        case LRFloatTipsArrowDirectionTopRight:{
            x = _screenW - self.contentSize.width - LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y + self.viewSize.height + LR_ARROW_HIGHT;
            break;
        }
        case LRFloatTipsArrowDirectionBottomLeft:{
            x = LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y - LR_ARROW_HIGHT - self.contentSize.height;
            break;
        }
        case LRFloatTipsArrowDirectionBottomCenter:{
            x = self.viewOrigin.x + self.viewSize.width*0.5 - self.contentSize.width*0.5;
            y = self.viewOrigin.y - LR_ARROW_HIGHT - self.contentSize.height;
            break;
        }
        case LRFloatTipsArrowDirectionBottomRight:{
            x = _screenW - self.contentSize.width - LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y - LR_ARROW_HIGHT - self.contentSize.height;
            break;
        }
    }

    return CGRectMake(x, y, self.contentSize.width, self.contentSize.height);
}

- (CGRect )getViewFrameToWindow:(UIView *)view
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (view.superview) {
        return [view.superview convertRect:view.frame toView:window];
    }
    
    return CGRectZero;
}

#pragma mark --- System Method

// 画箭头
- (void)drawRect:(CGRect)rect {
    
    if (self.isHidden) {
        return ;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.arrowDirection) {
        case LRFloatTipsArrowDirectionTopLeft:
        case LRFloatTipsArrowDirectionTopCenter:
        case LRFloatTipsArrowDirectionTopRight:{
            {
                CGContextSaveGState(context);
                {
                    CGFloat startX = self.viewOrigin.x + self.viewSize.width*0.5;
                    CGFloat startY = self.viewOrigin.y + self.viewSize.height;

                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(startX, startY)];
                    [path addLineToPoint:CGPointMake(startX + LR_ARROW_HIGHT, startY + LR_ARROW_HIGHT)];
                    [path addLineToPoint:CGPointMake(startX - LR_ARROW_HIGHT, startY + LR_ARROW_HIGHT)];
                    [path closePath];
                    
                    [[[UIColor blackColor] colorWithAlphaComponent:0.7] set];
                    [path fill];
                    
                    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:[self getContentLabelFrame] cornerRadius:5.0];
                    [[[UIColor blackColor] colorWithAlphaComponent:0.7] set];
                    [path2 fill];
                    [path appendPath:path2];
                }
                CGContextRestoreGState(context);
            }
            break;
        }
        case LRFloatTipsArrowDirectionBottomLeft:
        case LRFloatTipsArrowDirectionBottomCenter:
        case LRFloatTipsArrowDirectionBottomRight: {
            {
                CGContextSaveGState(context);
                {
                    CGFloat startX = self.viewOrigin.x + self.viewSize.width*0.5;
                    CGFloat startY = self.viewOrigin.y;

                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(startX, startY)];
                    [path addLineToPoint:CGPointMake(startX - LR_ARROW_HIGHT, startY - LR_ARROW_HIGHT)];
                    [path addLineToPoint:CGPointMake(startX + LR_ARROW_HIGHT, startY - LR_ARROW_HIGHT)];
                    [path closePath];
                    
                    [[[UIColor blackColor] colorWithAlphaComponent:0.7] set];
                    [path fill];
                    
                    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:[self getContentLabelFrame] cornerRadius:5.0];
                    [[[UIColor blackColor] colorWithAlphaComponent:0.7] set];
                    [path2 fill];
                    [path appendPath:path2];
                }
                CGContextRestoreGState(context);
            }
            break;
        }
    }
}

// 点击视图，退出
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![[touches anyObject].view isEqual:self.contentL]) {
        [self dismissView];
    }
}

#pragma mark ---  Setter & Getter

- (LRLabel *)contentL
{
    if (!_contentL) {
        _contentL = [[LRLabel alloc] initWithFrame:[self getContentLabelFrame]];
        _contentL.backgroundColor = [UIColor clearColor];
        _contentL.numberOfLines = 0;
        _contentL.textColor = [UIColor whiteColor];
        _contentL.textInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _contentL.userInteractionEnabled = YES;
    }
    return _contentL;
}

- (NSDictionary *)attributes
{
    if (!_attributes) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;// 字体的行间距
        paragraphStyle.alignment = NSTextAlignmentLeft;
        _attributes = @{
                        NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                        NSParagraphStyleAttributeName:paragraphStyle,
                        };
    }
    return _attributes;
}

#pragma mark ---  Public Method

+ (void)addTipsForView:(UIView *)forView content:(NSString *)content
{
    LRFloatTips *tips = [[LRFloatTips alloc] initWithView:forView content:content];
    [tips showView];
}


+ (void)addTipsForView:(UIView *)forView content:(NSString *)content afterDelay:(NSTimeInterval)delay
{
    LRFloatTips *tips = [[LRFloatTips alloc] initWithView:forView content:content];
    [tips showView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tips dismissView];
    });
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
