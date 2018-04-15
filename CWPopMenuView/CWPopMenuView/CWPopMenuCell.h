//
//  CWPopMenuCell.h
//  CWPopMenu
//
//  Created by CWDev on 2018/2/25.
//  Copyright © 2018年 CWDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWPopMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labText;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
