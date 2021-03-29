//
//  YKChatSelectView.m
//  TTDoctor
//
//  Created by YK on 2020/7/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatSelectView.h"
#import "BFCButton.h"

@interface YKChatSelectView()

@property (nonatomic,strong) UIView *selectView;

@end

@implementation YKChatSelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.selectView];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(260);
    }];
    
}

#pragma mark - init

- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [UIView new];
        _selectView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"按类别发送";
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor =COMMONCOLOR;
        [_selectView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(_selectView);
            make.height.mas_equalTo(40);
        }];
        
        int k = 0;

        for (int i = 0; i < 2; i ++) {
            for (int j = 0; j < 3; j ++) {
                
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH / 3 * j, 40 + 110 * i, KWIDTH / 3, 110)];
                [_selectView addSubview:tempView];

                BFCButton *collectBtn = [BFCButton buttonWithType:UIButtonTypeCustom];
                collectBtn.tag = k;
                [collectBtn addTarget:self action:@selector(onButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
                collectBtn.alignType = BFCButtonAlignTypeTextBottom;
                if (k == 0) {
                    [collectBtn setImage:[UIImage imageNamed:@"选择_快捷回复"] forState:UIControlStateNormal];
                    [collectBtn setTitle:@"快捷回复" forState:UIControlStateNormal];
                }else if (k == 1){
                    [collectBtn setImage:[UIImage imageNamed:@"选择_预置问卷"] forState:UIControlStateNormal];
                    [collectBtn setTitle:@"预置问卷" forState:UIControlStateNormal];
                }else if (k == 2){
                    [collectBtn setImage:[UIImage imageNamed:@"选择_图片"] forState:UIControlStateNormal];
                    [collectBtn setTitle:@"图片" forState:UIControlStateNormal];
                }else if (k == 3){
                    [collectBtn setImage:[UIImage imageNamed:@"选择_患教"] forState:UIControlStateNormal];
                    [collectBtn setTitle:@"患教" forState:UIControlStateNormal];
                }else{
                    collectBtn.hidden = YES;
                }
                
                collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [collectBtn setTitleColor:RGBACOLOR(51, 51, 51) forState:UIControlStateNormal];
                [tempView addSubview:collectBtn];
                [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(tempView);
                    make.centerX.mas_equalTo(tempView);
                    make.height.mas_equalTo(80);
                }];
                
                k ++;

            }
        }
    }
    return _selectView;
}

#pragma mark - Event

- (void)onButtonsAction:(UIButton *)sender{
    if (sender.tag == 0) {
        if ([self.delegate respondsToSelector:@selector(showQuickReplyView)]) {
            [self.delegate showQuickReplyView];
        }
    }else if (sender.tag == 1) {
        if ([self.delegate respondsToSelector:@selector(jumpToMyQuestionnaire)]) {
            [self.delegate jumpToMyQuestionnaire];
        }
    }else if (sender.tag == 2){
        if ([self.delegate respondsToSelector:@selector(jumpToTeach)]) {
            [self.delegate jumpToImage];
        }
    }else if (sender.tag == 3){
        if ([self.delegate respondsToSelector:@selector(jumpToImage)]) {
            [self.delegate jumpToTeach];
        }
    }
}

@end
