//
//  YKProvinceVC.h
//  TTDoctor
//
//  Created by YK on 2020/6/18.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^ChooseCityControllerBlock)(NSDictionary *dic);

@interface YKProvinceVC : YKBaseVC

@property (nonatomic, copy)ChooseCityControllerBlock cityBlock;


@end


