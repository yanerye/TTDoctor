//
//  CLTreeViewNode.h
//  TTDoctor
//
//  Created by YK on 2020/8/25.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTreeViewNode : NSObject

@property (nonatomic) int type; //节点类型
@property (nonatomic) id nodeData;//节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点

@end

