//
//  CWPopMenuView.m
//  CWPopMenu
//
//  Created by CWDev on 2018/2/25.
//  Copyright © 2018年 CWDev. All rights reserved.
//

#import "CWPopMenu.h"

#define distance (self.menuRadius + 3.0f)

@interface CWPopMenu()<UIGestureRecognizerDelegate>

//菜单视图
@property (nonatomic, readwrite, strong)UITableView *menuView;

//箭头位置枚举
@property (nonatomic, assign)CWPopMenuArrowPosition arrowPosition;

//箭头箭尖的坐标
@property (nonatomic, assign)CGPoint arrowPoint;

//菜单视图的大小
@property (nonatomic, assign)CGSize menuSize;

//菜单视图的frame起点坐标
@property (nonatomic, assign)CGPoint origin;

//绘制箭头的layer
@property (nonatomic, strong)CAShapeLayer *shLayer;

//标志位，是否为本文件内部方法调用(区分是否外部改变背景蒙版的backgroundColor和alpha)
@property (nonatomic, assign)BOOL isInsideInvok;

//视图是否已经展示
@property (nonatomic, assign)BOOL isShow;

@end

@implementation CWPopMenu

//显示菜单
- (void)showMenu:(BOOL)animated
{
    [self computeArrowPosition:_arrowPosition];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self bringSubviewToFront:window];
    if (animated) {
        self.menuView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:0.2 animations:^{
            self.menuView.transform = CGAffineTransformIdentity;
            self.menuView.alpha = 1.0;
            self.isInsideInvok = YES;
            self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:self.bgAlpha];
        } completion:^(BOOL finished) {
            //动画执行完添加手势，防止动画还未完成又点击了背景
            [self addTap];
            self.isShow = YES;
        }];
    }else{
        self.menuView.alpha = 1.0;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:self.bgAlpha];
        self.isShow = YES;
    }
}

//关闭菜单
- (void)closeMenu:(BOOL)animated
{
    self.isShow = NO;
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            self.menuView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.menuView.alpha = 0.0;
            self.shLayer.opacity = 0.0;
            self.isInsideInvok = YES;
            self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

- (UITableView *)menuView
{
    if (!_menuView) {
        _menuView = [[UITableView alloc]initWithFrame:CGRectZero];
    }
    return _menuView;
}

- (instancetype)initWithArrow:(CGPoint)point menuSize:(CGSize)size arrowStyle:(CWPopMenuArrowPosition)position
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.arrowPosition = position;
        self.arrowPoint = point;
        self.menuSize = size;
        [self setUpInit];
        [self addSubview:self.menuView];
    }
    return self;
}

//属性和视图初始化设置
- (void)setUpInit
{
    self.bgAlpha = 0.2;
    self.menuViewBgColor = [UIColor whiteColor];
    self.menuRadius = 5.f;
    self.arrowWidth = 15.f;
    self.arrowHeight = 10.f;
    self.cellHeight = 40.f;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    _menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuView.showsVerticalScrollIndicator = NO;
    _menuView.scrollEnabled = NO;
    _menuView.alpha = 1.0;
    _menuView.layer.cornerRadius = _menuRadius;
    _menuView.layer.masksToBounds = YES;

}

//设置菜单视图的frame
- (void)setUpMenuFrame
{
    switch (_arrowPosition) {
        case CWPopMenuArrowTopHeader:
            _origin = CGPointMake(_arrowPoint.x-distance-_arrowWidth*0.5, _arrowPoint.y+_arrowHeight);
            break;
        case CWPopMenuArrowTopCenter:
            _origin = CGPointMake(_arrowPoint.x-_menuSize.width*0.5, _arrowPoint.y+_arrowHeight);
            break;
        case CWPopMenuArrowTopfooter:
            _origin = CGPointMake(_arrowPoint.x+distance+_arrowWidth*0.5-_menuSize.width, _arrowPoint.y+_arrowHeight);
            break;
        case CWPopMenuArrowBottomHeader:
            _origin = CGPointMake(_arrowPoint.x-distance-_arrowWidth*0.5, _arrowPoint.y-_arrowHeight-_menuSize.height);
            break;
        case CWPopMenuArrowBottomCenter:
             _origin = CGPointMake(_arrowPoint.x-_menuSize.width*0.5, _arrowPoint.y-_arrowHeight-_menuSize.height);
            break;
        case CWPopMenuArrowBottomfooter:
            _origin = CGPointMake(_arrowPoint.x+distance+_arrowWidth*0.5-_menuSize.width, _arrowPoint.y-_arrowHeight-_menuSize.height);
            break;
        default:

            break;
    }
    self.menuView.frame = CGRectMake(_origin.x, _origin.y, _menuSize.width, _menuSize.height);
}

//背景蒙版单击手势
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
}

- (void)setArrowWidth:(CGFloat)arrowWidth
{
    if (_isShow) return;
    _arrowWidth = arrowWidth;
    [self setUpMenuFrame];
}

- (void) setArrowHeight:(CGFloat)arrowHeight
{
    if (_isShow) return;
    _arrowHeight = arrowHeight;
    [self setUpMenuFrame];
}

//设置菜单圆角
- (void)setMenuRadius:(CGFloat)menuRadius
{
    if (_isShow) return;
    _menuRadius = menuRadius;
    _menuView.layer.cornerRadius = _menuRadius;
    _menuView.layer.masksToBounds = YES;
    [self setUpMenuFrame];
}

//设置菜单背景色
- (void)setMenuViewBgColor:(UIColor *)menuViewBgColor
{
    if (_isShow) return;
    _menuViewBgColor = menuViewBgColor;
    self.menuView.backgroundColor = menuViewBgColor;
}

-(void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _menuView.dataSource = dataSource;
}

-(void)setDelegate:(id<UITableViewDelegate>)delegate
{
    _delegate = delegate;
    _menuView.delegate = delegate;
}

//接管蒙版frame设置
-(void)setFrame:(CGRect)frame
{
    if (_isShow) return;
    [super setFrame:[UIScreen mainScreen].bounds];
}

//设置cell高度
-(void)setCellHeight:(CGFloat)cellHeight
{
    if (_isShow) return;
    _cellHeight = cellHeight;
    self.menuView.rowHeight = cellHeight;
}

//接管背景色设置
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_isShow) return;
    if (!_isInsideInvok) {
        UIColor *color = [[UIColor blackColor]colorWithAlphaComponent:0];
        [super setBackgroundColor:color];
    }else{
        [super setBackgroundColor:backgroundColor];
    }
    _isInsideInvok = NO;
}

//接管透明度设置
-(void)setAlpha:(CGFloat)alpha
{
    if (_isShow) return;
    _bgAlpha = alpha;
}

//设置缩放动画锚点
-(void)setArrowPosition:(CWPopMenuArrowPosition)arrowPosition
{
    _arrowPosition = arrowPosition;
    switch (_arrowPosition) {
        case CWPopMenuArrowTopHeader:
            self.menuView.layer.anchorPoint = CGPointMake(0, 0);
            break;
        case CWPopMenuArrowTopCenter:
            self.menuView.layer.anchorPoint = CGPointMake(0.5, 0);
            break;
        case CWPopMenuArrowTopfooter:
            self.menuView.layer.anchorPoint = CGPointMake(1.0, 0);
            break;
        case CWPopMenuArrowBottomHeader:
            self.menuView.layer.anchorPoint = CGPointMake(0, 1.0);
            break;
        case CWPopMenuArrowBottomCenter:
            self.menuView.layer.anchorPoint = CGPointMake(0.5, 1.0);
            break;
        case CWPopMenuArrowBottomfooter:
            self.menuView.layer.anchorPoint = CGPointMake(1.0, 1.0);
            break;
        default:
            self.menuView.layer.anchorPoint = CGPointMake(1.0, 0);
            break;
    }
}

//根据位置枚举以及箭头高度和宽度计算绘制箭头的点
- (void)computeArrowPosition:(CWPopMenuArrowPosition)arrowPosition
{
    CGRect _menuFrame = _menuView.frame;
    CGFloat menuX = _menuFrame.origin.x;
    CGFloat menuY = _menuFrame.origin.y;
    CGFloat menuWidth = _menuFrame.size.width;
    CGFloat menuHeight = _menuFrame.size.height;
    
    switch (_arrowPosition) {
        case CWPopMenuArrowTopHeader:
        {
            CGPoint origin = CGPointMake(menuX+distance, menuY);
            CGPoint peak = CGPointMake(menuX+_arrowWidth*0.5 +distance, menuY-_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+_arrowWidth+distance, menuY);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            
            break;
        case CWPopMenuArrowTopCenter:
        {
            CGPoint origin = CGPointMake(menuX+(menuWidth-_arrowWidth)*0.5, menuY);
            CGPoint peak = CGPointMake(menuX+menuWidth*0.5, menuY-_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+(menuWidth+_arrowWidth)*0.5, menuY);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case CWPopMenuArrowTopfooter:
        {
            CGPoint origin = CGPointMake(menuX+menuWidth-_arrowWidth-distance, menuY);
            CGPoint peak = CGPointMake(menuX+menuWidth-_arrowWidth*0.5-distance, menuY-_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+menuWidth-distance, menuY);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case CWPopMenuArrowBottomHeader:
        {
            CGPoint origin = CGPointMake(menuX+distance, menuY+menuHeight);
            CGPoint peak = CGPointMake(menuX+_arrowWidth*0.5+distance, menuY+menuHeight+_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+_arrowWidth+distance, menuY+menuHeight);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case CWPopMenuArrowBottomCenter:
        {
            CGPoint origin = CGPointMake(menuX+(menuWidth-_arrowWidth)*0.5, menuY+menuHeight);
            CGPoint peak = CGPointMake(menuX+menuWidth*0.5, menuY+menuHeight+_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+(menuWidth+_arrowWidth)*0.5, menuY+menuHeight);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case CWPopMenuArrowBottomfooter:
        {
            CGPoint origin = CGPointMake(menuX+menuWidth-_arrowWidth-distance, menuY+menuHeight);
            CGPoint peak = CGPointMake(menuX+menuWidth-_arrowWidth*0.5-distance, menuY+menuHeight+_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+menuWidth-distance, menuY+menuHeight);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        default:
            
            break;
    }
}

//绘制箭头
- (void)drawArrowInLayer:(CGPoint)origin peak:(CGPoint)peak terminus:(CGPoint)terminus{
    //定义画图的path
    self.shLayer = [[CAShapeLayer alloc]init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    _shLayer.fillColor = self.menuViewBgColor.CGColor;
    
    //path移动到开始画图的位置
    [path moveToPoint:origin];
    [path addLineToPoint:peak];
    [path addLineToPoint:terminus];
    _shLayer.path = [path CGPath];
    
    //关闭path
    [path closePath];
    [self.layer addSublayer:_shLayer];
}

//蒙版背景点击事件
- (void)tapEvent
{
    [self closeMenu:YES];
}

//防止手势透传
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isMemberOfClass:[self class]]) {
        return YES;
    }
    return NO;
}

@end
