//
//  ViewController.m
//  CWPopMenu
//
//  Created by CWDev on 2018/4/8.
//  Copyright © 2018年 CWDev. All rights reserved.
//

#import "ViewController.h"
#import "CWPopMenu.h"
#import "CWPopMenuCell.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)CWPopMenu *menu;

@property (nonatomic, strong)NSArray *array;

@property (nonatomic, assign)CGFloat sumHeight;


@end

@implementation ViewController

-(NSArray *)array
{
    if (!_array) {
        _array = @[@"选项1",@"选项2",@"选项3",@"选项4",@"选项5"];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.sumHeight = statusHeight + navHeight;
    
}

- (IBAction)addAction:(UIBarButtonItem *)sender {
    
    self.menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(self.view.frame.size.width-25, _sumHeight) menuSize:CGSizeMake(130, 200) arrowStyle:CWPopMenuArrowTopfooter];
    
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.menuViewBgColor = [UIColor whiteColor];
    _menu.alpha = 0.1;
    [_menu showMenu:YES];
    
}

- (IBAction)editAction:(UIBarButtonItem *)sender {
    self.menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(25, _sumHeight) menuSize:CGSizeMake(130, 200) arrowStyle:CWPopMenuArrowTopHeader];
    
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.menuViewBgColor = [UIColor whiteColor];
    _menu.alpha = 0.1;
    [_menu showMenu:YES];
}

- (IBAction)clickMe:(UIButton *)sender {
    self.menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(self.view.center.x, _sumHeight) menuSize:CGSizeMake(130, 200) arrowStyle:CWPopMenuArrowTopCenter];
    
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.menuViewBgColor = [UIColor whiteColor];
    _menu.alpha = 0.1;
    [_menu showMenu:YES];
}


- (IBAction)bottom1Action:(UIButton *)sender {
    self.menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(sender.center.x, sender.center.y-10) menuSize:CGSizeMake(130, 199) arrowStyle:CWPopMenuArrowBottomHeader];
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.menuViewBgColor = [UIColor whiteColor];
    _menu.bgAlpha = 0.1;
    [_menu showMenu:YES];
}


- (IBAction)bottom2Action:(UIButton *)sender {
    self.menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(sender.center.x, sender.center.y-10) menuSize:CGSizeMake(130, 199) arrowStyle:CWPopMenuArrowBottomCenter];
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.menuViewBgColor = [UIColor whiteColor];
    _menu.bgAlpha = 0.1;
    [_menu showMenu:YES];
}

- (IBAction)bottom3Action:(UIButton *)sender {
    self.menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(sender.center.x, sender.center.y-10) menuSize:CGSizeMake(130, 199) arrowStyle:CWPopMenuArrowBottomfooter];
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.menuViewBgColor = [UIColor whiteColor];
    _menu.bgAlpha = 0.1;
    [_menu showMenu:YES];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CWPopMenuCell *cell = [CWPopMenuCell cellWithTableView:tableView];
    cell.labText.text = self.array[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%@",self.array[indexPath.row]);
    [self.menu closeMenu:NO];
}

#pragma mark -- UIViewControllerTransitioningDelegate


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
