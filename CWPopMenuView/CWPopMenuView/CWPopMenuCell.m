//
//  CWPopMenuCell.m
//  CWPopMenu
//
//  Created by CWDev on 2018/2/25.
//  Copyright © 2018年 CWDev. All rights reserved.
//

#import "CWPopMenuCell.h"

@implementation CWPopMenuCell

static NSString *ID = @"PopMenuCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CWPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
