//
//  YKConstantsDefine.h
//  TTDoctor
//
//  Created by YK on 2021/9/29.
//  Copyright © 2021 YK. All rights reserved.
//

#ifndef YKConstantsDefine_h
#define YKConstantsDefine_h

//屏幕宽度
#define KWIDTH [[UIScreen mainScreen] bounds].size.width
#define KHEIGHT [[UIScreen mainScreen] bounds].size.height

//颜色
#define RGBACOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define COMMONCOLOR [UIColor colorWithRed:0/255.0 green:221/255.0 blue:191/255.0 alpha:1.0]

//生产环境
#define BASE_SERVER @"https://gz.cscps.com.cn/sp"
#define TOKEN_SERVER @"https://gz.cscps.com.cn"
#define IMAGE_SERVER @"http://cd-oss.ttdoc.cn"

//中医慢病管理

//#define BASE_SERVER @"https://cd.ttdoc.cn/sp"
//#define TOKEN_SERVER @"https://cd.ttdoc.cn"
//#define IMAGE_SERVER @"https://cmcd-oss.oss-cn-beijing.aliyuncs.com"

//易康医生-科研

//#define IMAGE_SERVER  @"http://img.ttdoc.cn"
//#define BASE_SERVER @"http://s.ttdoc.cn"
//#define TOKEN_SERVER @"https://gz.cscps.com.cn"

// 是否是刘海屏
#define isNotch                [YKiPhoneGlobalConfig hasNotch]
// 底部安全区域
#define kSafeAreaBottom        [YKiPhoneGlobalConfig bottomSafeArea]
// 导航栏高度
#define navBarHeight        [YKiPhoneGlobalConfig navigationBarHight]
// 状态栏高度
#define staBarheight        [YKiPhoneGlobalConfig statusBarHight]

#endif /* YKConstantsDefine_h */
