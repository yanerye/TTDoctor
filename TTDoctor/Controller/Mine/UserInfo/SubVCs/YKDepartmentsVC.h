//
//  YKDepartmentsVC.h
//  TTDoctor
//
//  Created by YK on 2020/6/22.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^ChooseDepartmentBlock)(NSDictionary *dic);

@interface YKDepartmentsVC : YKBaseVC

@property (nonatomic, copy)ChooseDepartmentBlock departmentBlock;

@end


