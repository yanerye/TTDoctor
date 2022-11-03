//
//  YKPatientAreasVC.h
//  TTDoctor
//
//  Created by YK on 2020/6/22.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKBaseVC.h"

typedef void(^PatientAreasBlock)(NSDictionary *dic);

@interface YKPatientAreasVC : YKBaseVC

@property (nonatomic, copy)PatientAreasBlock areaBlock;


@end


