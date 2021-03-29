//
//  YKChatDetailCell.h
//  TTDoctor
//
//  Created by YK on 2020/7/6.
//  Copyright © 2020 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKMessageModel.h"

@protocol CheckMaterialDetailDelegate<NSObject>

-(void)CheckQuessionDetailWithURL:(NSString *)quessionURL;
-(void)CheckTeachDetail;

@end

@interface YKChatDetailCell : UITableViewCell

@property (nonatomic, strong) YKMessageModel *messageModel;

@property (nonatomic,weak) id<CheckMaterialDetailDelegate> delegate;

-(void)configUI:(YKMessageModel *)messageModel patientImage:(NSString *)patientImage;

@end


