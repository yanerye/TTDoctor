//
//  YKHospitalVC.h
//  TTDoctor
//
//  Created by YK on 2020/6/22.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^ChooseHospitalBlock)(NSDictionary *dic);


@interface YKHospitalVC : YKBaseVC

@property (nonatomic, copy) NSString *provienceStr;

@property (nonatomic, copy)ChooseHospitalBlock hospitalBlock;

@end


