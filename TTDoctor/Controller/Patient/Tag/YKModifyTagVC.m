//
//  YKModifyTagVC.m
//  TTDoctor
//
//  Created by YK on 2021/10/9.
//  Copyright © 2021 YK. All rights reserved.
//

#import "YKModifyTagVC.h"

@interface YKModifyTagVC ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation YKModifyTagVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutAllSubviews];
    [self createRightButtonItems];

}

- (void)layoutAllSubviews{
    [self.view addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(2);
        make.right.mas_equalTo(self.view).offset(-2);
        make.height.mas_equalTo(150);
    }];
    
}

- (void)createRightButtonItems {

    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = right2;
}

#pragma mark - init

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [UITextView new];
        _contentTextView.layer.cornerRadius = 8;
        _contentTextView.layer.borderColor = COMMONCOLOR.CGColor;
        _contentTextView.layer.borderWidth = 1;
        _contentTextView.font = [UIFont systemFontOfSize:16];
        
        _contentTextView.delegate = self;
        _contentTextView.text = self.contentStr;

    }
    return _contentTextView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.contentStr = textView.text;
}

#pragma mark - event

- (void)doneClick{
    
    if (self.contentStr.length  == 0) {
        [YKAlertHelper showErrorMessage:@"请输入标签" inView:self.view];
        return;
    }else{
        if ([self.titleString isEqualToString:@"添加标签"]) {
            [[YKBaseApiSeivice service] addPatientTagWithTagName:self.contentStr completion:^(id responseObject, NSError *error) {
                if (!error) {
                    if (self.block) {
                        self.block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
                }
            }];

            [self.navigationController popViewControllerAnimated:YES];
        }else if ([self.titleString isEqualToString:@"修改标签"]){
            [[YKBaseApiSeivice service] updatePatientTagWithTagId:self.tagId tagName:self.contentStr completion:^(id responseObject, NSError *error) {
                if (!error) {
                    if (self.block) {
                        self.block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
                }
            }];
        }
    }
    
}

@end
