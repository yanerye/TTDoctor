//
//  YKChatDetailVC.m
//  TTDoctor
//
//  Created by YK on 2020/7/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatDetailVC.h"
#import "IQKeyboardManager.h"
#import "YKChatKeyboardView.h"
#import "YKChatSelectView.h"
#import "YKMyQuestionnaireVC.h"
#import "UIView+FrameTool.h"
#import "YKMessageModel.h"
#import "YKChatDetailCell.h"
#import "YKWebVC.h"
#import <TZImagePickerController.h>
#import "MMPopupView.h"
#import "MMSheetView.h"


#define TOOLBAR_HEIGHT 50

#define SELECT_VIEW_HEIGHT 260


@interface YKChatDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,SelectTypeDelegate,DKSKeyboardDelegate,CheckMaterialDetailDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong)UITableView *contentTableView;

@property (nonatomic, strong)YKChatKeyboardView *keyboardView;

@property (nonatomic, strong)UIView *slelectBackgroundView;
@property (nonatomic, strong)YKChatSelectView *selectView;

@property (nonatomic, strong)UIView *quickReplyView;
@property (nonatomic, strong)UIView *quickReplyBackgroundView;
@property (nonatomic, strong)UITableView *quickReplyTableView;

@property (nonatomic, strong)NSMutableArray *quickReplyArray;
@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation YKChatDetailVC
{
    NSString * _lastID;
    dispatch_group_t _group;
}

- (NSMutableArray *)quickReplyArray{
    if (!_quickReplyArray) {
        _quickReplyArray = [NSMutableArray array];
    }
    return _quickReplyArray;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 239, 243);
    self.title = @"聊天详情";
    _lastID = @"0";
    [self layoutAllSubviews];
    [self getMessageRecore];
    [self getQuickReplyList];
    //发送问卷通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (getQuestionnaire:) name:@"sendQuestionnaire" object:nil];

}

- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//不显示工具条
}

- (void)viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;//显示工具条
}


- (void)layoutAllSubviews{
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.keyboardView];
    [self.view addSubview:self.slelectBackgroundView];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.quickReplyBackgroundView];
    [self.view addSubview:self.quickReplyView];

}

#pragma mark - Network

//第一次进入页面获取聊天记录
- (void)getMessageRecore{
    [YKHUDHelper showHUDInView:self.view];

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    NSString *accessPath = [NSString stringWithFormat:@"%@/app/chat-record/v2.0/msg/last/%@/%@",TOKEN_SERVER,self.chatId,_lastID];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:accessPath parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];
    
    NSURLSessionTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [YKHUDHelper hideHUDInView:self.view];
        if ([responseObject[@"code"] intValue] == 200) {
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSDictionary *dict in responseObject[@"data"]) {
                YKMessageModel *model = [[YKMessageModel alloc] init];
                model.messageType = [dict[@"type"] intValue];
                model.content = [NSString stringWithFormat:@"%@",dict[@"content"]];
                model.smallImg = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dict[@"smallImg"]];
                model.messageSenderType = [dict[@"client"] intValue];
                model.quessionUrl = [NSString stringWithFormat:@"%@",dict[@"quessionUrl"]];
                [tempArray addObject:model];
            }
            tempArray = (NSMutableArray *)[[tempArray reverseObjectEnumerator] allObjects];
            self.dataArray = tempArray;
            [self.contentTableView reloadData];
            [self doForceScrollToBottom];
        }else{
            [YKHUDHelper hideHUDInView:self.view];
            [YKAlertHelper showErrorMessage:@"网络错误" inView:self.view];
        }
    }];

    [task resume];
}


-(void)doForceScrollToBottom
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if(  self.contentTableView.contentSize.height - self.contentTableView.contentOffset.y > self.contentTableView.frame.size.height )
        {
            [self.contentTableView setContentOffset:CGPointMake(0, self.contentTableView.contentSize.height - self.contentTableView.frame.size.height)];
            
        }
        usleep(5000);
        if (self.dataArray.count > 1) {
            NSIndexPath* path = [NSIndexPath indexPathForRow: self.dataArray.count - 1 inSection:0];
            if( path ){
                [self.contentTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }

        
    });
}

//快捷回复列表
- (void)getQuickReplyList{
    [[YKApiService service] getQuickReplyListCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *tempArray = responseObject[@"rows"];
            for (NSDictionary *dict in tempArray) {
                [self.quickReplyArray addObject:dict];
            }
            [self.quickReplyTableView reloadData];
        }else{
            [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
        }
    }];
}

#pragma mark - init

- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH,KHEIGHT - TOOLBAR_HEIGHT - navBarHeight) style:UITableViewStylePlain];
        _contentTableView.backgroundColor = RGBACOLOR(237, 239, 243);
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _contentTableView;
}

- (YKChatKeyboardView *)keyboardView{
    if (!_keyboardView) {
        _keyboardView = [[YKChatKeyboardView alloc] initWithFrame:CGRectMake(0, KHEIGHT - TOOLBAR_HEIGHT - navBarHeight, KWIDTH, TOOLBAR_HEIGHT)];
        _keyboardView.delegate = self;
    }
    return _keyboardView;
}

- (UIView *)slelectBackgroundView{
    if (!_slelectBackgroundView) {
        _slelectBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT - navBarHeight)];
        _slelectBackgroundView.backgroundColor = [UIColor blackColor];
        _slelectBackgroundView.alpha = 0.5;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSelectAnimateHidden)];
        [_slelectBackgroundView addGestureRecognizer:tap];
        _slelectBackgroundView.hidden = YES;
    }
    return _slelectBackgroundView;
}

- (YKChatSelectView *)selectView{
    if (!_selectView) {
        _selectView = [[YKChatSelectView alloc] initWithFrame:CGRectMake(0,  KHEIGHT - navBarHeight, KWIDTH, SELECT_VIEW_HEIGHT)];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIView *)quickReplyBackgroundView{
    if (!_quickReplyBackgroundView) {
        _quickReplyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT - navBarHeight)];
        _quickReplyBackgroundView.backgroundColor = [UIColor blackColor];
        _quickReplyBackgroundView.alpha = 0.5;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setQuickReplyViewHidden)];
        [_quickReplyBackgroundView addGestureRecognizer:tap];
        _quickReplyBackgroundView.hidden = YES;
    }
    return _quickReplyBackgroundView;
}

- (UIView *)quickReplyView{
    if (!_quickReplyView) {
        _quickReplyView = [[UIView alloc] initWithFrame:CGRectMake(0, KHEIGHT, KWIDTH, SELECT_VIEW_HEIGHT)];
        _quickReplyView.backgroundColor = [UIColor whiteColor];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 40)];
        titleLabel.text = @"快捷回复";
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor =COMMONCOLOR;
        [_quickReplyView addSubview:titleLabel];
        
        self.quickReplyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 , KWIDTH, SELECT_VIEW_HEIGHT - 40) style:UITableViewStylePlain];
        self.quickReplyTableView.delegate = self;
        self.quickReplyTableView.dataSource = self;
        self.quickReplyTableView.tag = 100;
        [_quickReplyView addSubview:self.quickReplyTableView];
    }
    return _quickReplyView;
}

#pragma mark - UItableView开始滑动隐藏键盘

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
}

#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return self.quickReplyArray.count;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return 50;
    }
    
    YKMessageModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    if (tableView.tag == 100) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *dict = self.quickReplyArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        return cell;
    }
    YKChatDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKChatDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    YKMessageModel *model = self.dataArray[indexPath.row];
    [cell configUI:model patientImage:self.patientImage];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 100) {
        [self setQuickReplyViewHidden];
        NSDictionary *dict = self.quickReplyArray[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showQuickReply" object:dict];
    }
}

#pragma mark - 底部消息框事件代理
//发送的文案
- (void)textViewContentText:(NSString *)textStr {
    [self sendMessageWithContent:textStr];
}

//keyboard的frame改变
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
    // 获取对应cell的rect值（其值针对于UITableView而言）
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    CGRect rect = [self.contentTableView rectForRowAtIndexPath:lastIndex];
    CGFloat lastMaxY = rect.origin.y + rect.size.height;
    //如果最后一个cell的最大Y值大于tableView的高度
    if (lastMaxY <= self.contentTableView.height) {
        if (lastMaxY >= minY) {
            self.contentTableView.y = minY - lastMaxY;
        } else {
            self.contentTableView.y = 0;
        }
    } else {
        self.contentTableView.y += minY - self.contentTableView.maxY;
    }
}

- (void)showSendType{
    [self selectClick];
}

#pragma mark - 发送文本消息

-(void)sendMessageWithContent:(NSString *)content{
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    NSString *accessPath = [NSString stringWithFormat:@"%@/app/chat-record/v2.0/send",TOKEN_SERVER];
    // 请求参数字典
    NSDictionary *params = @{@"chatId":self.chatId,
                             @"client":@"1",
                             @"quessionId":@"",
                             @"type":@"2",
                             @"content":content
    };

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:accessPath parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ([responseObject[@"code"] intValue] == 200) {
            YKMessageModel *model = [[YKMessageModel alloc] init];
            NSDictionary *dict = responseObject[@"data"];
            model.messageType = [dict[@"type"] intValue];
            model.content = [NSString stringWithFormat:@"%@",dict[@"content"]];
            model.messageSenderType = [dict[@"client"] intValue];
            [self.dataArray addObject:model];
            
            [self.contentTableView reloadData];
            [self doForceScrollToBottom];
        }else{
            [YKAlertHelper showErrorMessage:@"发送失败" inView:self.view];
        }
    }];
    
    [task resume];
}

#pragma mark - 点击事件

- (void)selectClick{
    [self setSelectAnimate];
    self.slelectBackgroundView.hidden = NO;
}

-(void)setSelectAnimate
{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame = CGRectMake(0,  KHEIGHT - navBarHeight - 260, KWIDTH, SELECT_VIEW_HEIGHT);
    }];
}

-(void)setSelectAnimateHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame = CGRectMake(0, KHEIGHT - navBarHeight, KWIDTH, SELECT_VIEW_HEIGHT);
        self.slelectBackgroundView.hidden = YES;
    }];
}


- (void)setQuickReplyViewHidden{
    self.quickReplyBackgroundView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.quickReplyView.frame = CGRectMake(0,  KHEIGHT, KWIDTH, SELECT_VIEW_HEIGHT);
    }];
}

#pragma mark - 得到并发送问卷

//得到要发送的问卷
-(void)getQuestionnaire:(NSNotification *)notification
{
    _group = dispatch_group_create();

    NSArray *tempArray = [notification object];
    for (int i = 0; i < tempArray.count; i ++) {
        NSDictionary * dict = tempArray[i];
        [self sendQuestionnaireWithQuestionnaireDict:dict];
    }
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        [self.contentTableView reloadData];
        [self doForceScrollToBottom];
    });
}

- (void)sendQuestionnaireWithQuestionnaireDict:(NSDictionary *)questionnaireDict{
    
    dispatch_group_enter(_group);

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    NSString *accessPath = [NSString stringWithFormat:@"%@/app/chat-record/v2.0/send",TOKEN_SERVER];
    // 请求参数字典
    NSDictionary *params = @{@"chatId":self.chatId,
                             @"client":@"1",
                             @"quessionId":questionnaireDict[@"masterQuestionId"],
                             @"type":@"3",
                             @"content":@""
    };

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:accessPath parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ([responseObject[@"code"] intValue] == 200) {
            YKMessageModel *model = [[YKMessageModel alloc] init];
            NSDictionary *dict = responseObject[@"data"];
            model.messageType = [dict[@"type"] intValue];
            model.content = [NSString stringWithFormat:@"%@",dict[@"content"]];
            model.messageSenderType = [dict[@"client"] intValue];
            model.quessionUrl = [NSString stringWithFormat:@"%@",questionnaireDict[@"specialUrl"]];
            [self.dataArray addObject:model];
            dispatch_group_leave(_group);

        }else{
            [YKAlertHelper showErrorMessage:@"发送失败" inView:self.view];
        }
    }];
    
    [task resume];
}

#pragma mark - 选择发送消息类型代理

- (void)showQuickReplyView{
    [self setSelectAnimateHidden];
    self.quickReplyBackgroundView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.quickReplyView.frame = CGRectMake(0,  KHEIGHT - SELECT_VIEW_HEIGHT - navBarHeight, KWIDTH, SELECT_VIEW_HEIGHT);
    }];
}

- (void)jumpToMyQuestionnaire{
    [self setSelectAnimateHidden];
    YKMyQuestionnaireVC *vc = [[YKMyQuestionnaireVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTeach{
    
}

- (void)jumpToImage{
    [self setSelectAnimateHidden];
    
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            NSLog(@"选择拍照");
        } else if(index == 1) {
            //MaxImagesCount  可以选着的最大条目数
            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
            // 是否显示可选原图按钮
            imagePicker.allowPickingOriginalPhoto = NO;
            // 是否允许显示视频
            imagePicker.allowPickingVideo = NO;
            // 是否允许显示图片
            imagePicker.allowPickingImage = YES;
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
    };
    
    NSArray *items = @[MMItemMake(@"拍照", MMItemTypeNormal, block),
                       MMItemMake(@"从相册中选择", MMItemTypeNormal, block)];
    
    [[[MMSheetView alloc] initWithTitle:nil items:items] showWithBlock:nil];
}

#pragma mark - 选择照片代理

// 选择照片的回调
-(void)imagePickerController:(TZImagePickerController *)picker
      didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                sourceAssets:(NSArray *)assets
       isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    _group = dispatch_group_create();

    for (int i=0; i < assets.count; i++) {
        PHAsset *asset=assets[i];
        UIImage *tempImage = photos[i];
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
//        NSString * imageName = [[resource.assetLocalIdentifier componentsSeparatedByString:@"/"] firstObject];
        NSString * imageSuffix = [[resource.originalFilename componentsSeparatedByString:@"."] lastObject];
        [self sendImage:tempImage imageSuffix:imageSuffix];
    }

    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        [self.contentTableView reloadData];
        [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];

    });

}

#pragma mark - 发送图片
-(void)sendImage:(UIImage *)image imageSuffix:(NSString *)imageSuffix{
    
    dispatch_group_enter(_group);
    
    NSData *data = UIImageJPEGRepresentation(image, 0.7f);
    NSString *encodedImageStr =[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    NSString *accessPath = [NSString stringWithFormat:@"%@/app/chat-record/v2.0/send",TOKEN_SERVER];
    // 请求参数字典
    NSDictionary *params = @{@"chatId":self.chatId,
                             @"client":@"1",
                             @"quessionId":@"",
                             @"type":@"1",
                             @"content":encodedImageStr,
                             @"suffix":imageSuffix
    };

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:accessPath parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];
    
    NSURLSessionTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
        if ([responseObject[@"code"] intValue] == 200) {
            NSLog(@"%@",responseObject);
            YKMessageModel *model = [[YKMessageModel alloc] init];
            NSDictionary *dict = responseObject[@"data"];
            model.messageType = [dict[@"type"] intValue];
            model.smallImg = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dict[@"smallImg"]];
            model.messageSenderType = [dict[@"client"] intValue];
            [self.dataArray addObject:model];
            dispatch_group_leave(_group);

        }else{
            [YKAlertHelper showErrorMessage:@"发送消失失败" inView:self.view];
        }
    }];

    [task resume];
}


#pragma mark - 查看问卷患教详情代理

- (void)CheckQuessionDetailWithURL:(NSString *)quessionURL{
    YKWebVC *webVC = [[YKWebVC alloc] init];
    webVC.titleString = @"问卷详情";
    webVC.urlString = quessionURL;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)CheckTeachDetail{
    
}

@end
