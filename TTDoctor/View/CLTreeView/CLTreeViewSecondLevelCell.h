//
//  CLTreeViewSecondLevelCell.h
//  TTDoctor
//
//  Created by YK on 2020/8/25.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTreeViewNode.h"

@interface CLTreeViewSecondLevelCell : UITableViewCell

@property (nonatomic, strong) CLTreeViewNode *node; //data
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *rightImageView;


@end


