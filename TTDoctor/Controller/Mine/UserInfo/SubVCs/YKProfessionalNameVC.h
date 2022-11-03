//
//  YKProfessionalNameVC.h
//  TTDoctor
//
//  Created by YK on 2020/6/22.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^ProfessionalNameBlock)(NSDictionary *dic);

@interface YKProfessionalNameVC : YKBaseVC

@property (nonatomic, copy)ProfessionalNameBlock professionalBlock;


@end


