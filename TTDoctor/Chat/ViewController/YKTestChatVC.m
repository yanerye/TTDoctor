//
//  YKTestChatVC.m
//  TTDoctor
//
//  Created by YK on 2020/9/3.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKTestChatVC.h"
#import "IQKeyboardManager.h"
#import "YKChatKeyboardView.h"
#import "YKChatSelectView.h"
#import "YKMyQuestionnaireVC.h"
#import "UIView+FrameTool.h"
#import "YKChatDetailCell.h"
#import "YKWebVC.h"
#import <TZImagePickerController.h>
#import "MMPopupView.h"
#import "MMSheetView.h"
#import "YKChatTextMessageCell.h"
#import "YKChatImageMessageCell.h"
#import "YKChatMessageModel.h"
#import "YKChatMessageManager.h"
#import "YKChatUserModel.h"
#import "YKChatDBManager.h"
#import "YBImageBrowser.h"
#import "SDImageCache.h"

#define TOOLBAR_HEIGHT 50

#define SELECT_VIEW_HEIGHT 260


@interface YKTestChatVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,SelectTypeDelegate,DKSKeyboardDelegate,CheckMaterialDetailDelegate,TZImagePickerControllerDelegate,YKShowOriginalImageDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)UITableView *contentTableView;

@property (nonatomic, strong)YKChatKeyboardView *keyboardView;

@property (nonatomic, strong)UIView *slelectBackgroundView;
@property (nonatomic, strong)YKChatSelectView *selectView;

@property (nonatomic, strong)UIView *quickReplyView;
@property (nonatomic, strong)UIView *quickReplyBackgroundView;
@property (nonatomic, strong)UITableView *quickReplyTableView;

@property (nonatomic, strong)NSMutableArray *quickReplyArray;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)NSMutableArray *pictureArray;

///手势处理相关
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> recognizerDelegate;

@end

@implementation YKTestChatVC
{
    dispatch_group_t _group;
    //输入文字的时候键盘高度
    CGFloat _keyboardH;
    //键盘是否显示
    CGFloat _isSHow;
    //条件锁
    NSConditionLock *_lock;
    //异步线程
    dispatch_queue_t _queue;

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

- (NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 239, 243);
    self.title = self.titleString;
    _keyboardH = 0;
    _isSHow = NO;
    [self layoutAllSubviews];
    [self getMessageRecore];
    [self getQuickReplyList];
    //发送问卷通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (getQuestionnaire:) name:@"sendQuestionnaire" object:nil];
    
    
    //获取最新的消息
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (getNewMessage:) name:@"newMessage" object:nil];
}


- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//不显示工具条
    [self updateRecognizerDelegate:YES];
}

- (void)viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;//显示工具条
    [self updateRecognizerDelegate:NO];
}

- (void)layoutAllSubviews{
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.keyboardView];
    [self.view addSubview:self.slelectBackgroundView];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.quickReplyBackgroundView];
    [self.view addSubview:self.quickReplyView];
    [self setRightItem];
}
#pragma mark  - 清空消息

- (void)setRightItem{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];

    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, 0, 62, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setTitle:@"清空消息" forState:UIControlStateNormal];
    mainAndSearchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [mainAndSearchBtn addTarget:self action:@selector(deleteMessage) forControlEvents:UIControlEventTouchUpInside];
     
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

- (void)deleteMessage{
    [[YKChatDBManager DBManager] deleteMessageWithUid:self.chatId];

    NSLog(@"清空");
}

#pragma mark  - 在页面收到消息

- (void)getNewMessage:(NSNotification *)noti{
    NSDictionary *tempDict = noti.object;
    NSLog(@"%@",tempDict);
    //接收文本消息
    if ([tempDict[@"type"] isEqualToString:@"CHAT_MESSAGE_NOTICE"]) {
        NSString *content = [NSString stringWithFormat:@"%@",tempDict[@"content"]];
        //网络请求的发送消息
        YKChatMessageModel *model = [YKChatMessageManager createTextMessage:self.userModel
                                                                    message:content
                                                                   isSender:NO];
        model.sendType = YKMessageSendTypeSuccess;
        [self sendMessageModel:model];
    }
//    if ([tempDict[@"data"] intValue] == [self.chatId intValue]) {
//            [self refreshNewMessage];
//    }else{
//        messageNumber++;
//        redView.hidden = NO;
//        numberLabel.hidden = NO;
//        numberLabel.text = [NSString stringWithFormat:@"%d",messageNumber];
//    }
    
}

#pragma mark - Network

- (void)getMessageRecore{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.dataArray = [[YKChatDBManager DBManager] messagesWithUser:self.userModel];
        //保存图片
        for (YKChatMessageModel *model in self.dataArray) {
            if (model.msgType == YKMessageTypeImage) {
                [self.pictureArray addObject:model.original];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentTableView reloadData];
            [self tableViewScrollToBottom:NO duration:0.25];
        });
    });
}


//快捷回复列表
- (void)getQuickReplyList{
    [[YKBaseApiSeivice service] getQuickReplyListCompletion:^(id responseObject, NSError *error) {
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
    
    YKChatMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [model cacheModelSize];
    return model.modelH+32;
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
    YKChatBaseCell *cell;
    YKChatMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (model.msgType == YKMessageTypeText) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        if (cell == nil) {
            cell = [[YKChatTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"];
        }
        [cell setConfig:model isShowName:NO];
    }else if (model.msgType == YKMessageTypeImage) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        if (cell == nil) {
            cell = [[YKChatImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        }
        cell.delegate = self;
        [cell setConfig:model isShowName:NO];
    }
    
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


//发送消息
- (void)sendMessageModel:(YKChatMessageModel *)model {
    [self addMessageModel:model];
}

//消息存储
- (void)addMessageModel:(YKChatMessageModel *)model {
    [self.dataArray addObject:model];
    [self.contentTableView reloadData];
    [self tableViewScrollToBottom:YES duration:0.25];

    [[YKChatDBManager DBManager] insertMessage:model chatWithUser:self.userModel];
}

//keyboard的frame改变
- (void)changeTableViewFrameWithKeyboardHeight:(CGFloat)keyboardHeight isShow:(BOOL)isShow{
    _keyboardH = keyboardHeight;
    _isSHow = isShow;
    [self tableViewScrollToBottom:YES duration:0.25];
}

- (void)tableViewScrollToBottom:(BOOL)animated duration:(CGFloat)duration {
    if (animated) {
        CGFloat contentH = self.contentTableView.contentSize.height;
        CGFloat tableViewH = self.contentTableView.bounds.size.height;
        
        CGFloat offsetY = 0;
        if (contentH < tableViewH) {
            offsetY = MAX(contentH + _keyboardH - tableViewH, 0);
        }
        else {
            offsetY = _keyboardH;
        }
        CGRect TRect = self.contentTableView.frame;
        //键盘隐藏并且输入框行数>1行并且contentH < tableViewH
        if (_isSHow == NO && _keyboardH > 0 && offsetY == _keyboardH) {
            TRect.origin.y = 0;
            TRect.size.height = KHEIGHT - navBarHeight - TOOLBAR_HEIGHT - _keyboardH;
        }else{
            TRect.origin.y = - offsetY;
            TRect.size.height = KHEIGHT - navBarHeight - TOOLBAR_HEIGHT;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.contentTableView.frame = TRect;
            if (self.dataArray.count) {
                [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataArray.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }];
    }
    else {
        if (self.dataArray.count) {
            [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataArray.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}


- (void)showSendType{
    [self selectClick];
}

#pragma mark - 发送文本消息

-(void)sendMessageWithContent:(NSString *)content{
    //网络请求的发送消息
    YKChatMessageModel *model = [YKChatMessageManager createTextMessage:self.userModel
                                                                message:content
                                                               isSender:YES];
    [self sendMessageModel:model];

    
    [[YKTokenApiService service] sendMessageWithChatId:self.chatId content:content requestMethod:@"PUT" completion:^(id responseObject, NSError *error) {
        if (!error) {
            
            //发送消息成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                model.sendType = YKMessageSendTypeSuccess;
                [[YKChatDBManager DBManager] updateMessageModel:model chatWithUser:self.userModel];
                [self.contentTableView reloadData];
            });
        }else{
            //发送消息失败
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                model.sendType = YKMessageSendTypeFailed;
                [[YKChatDBManager DBManager] updateMessageModel:model chatWithUser:self.userModel];
                [self.contentTableView reloadData];
            });
        }
            
    }];

    
}

#pragma mark - 语音发送

- (void)toolView:(YKChatKeyboardView *)toolView didChangeRecordType:(WZMRecordType)type{
    static NSInteger start;
    if (type == WZMRecordTypeBegin) {
        //开始录音
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        start = [date timeIntervalSince1970]*1000;
        NSLog(@"开始录音");
    }
    else if (type == WZMRecordTypeFinish) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger duration = [date timeIntervalSince1970]*1000 - start;
        NSLog(@"录音时长是%ld",duration/1000);
        NSLog(@"结束录音");

//        //结束录音
//        //将录音上传到服务器, 获取录音链接
//        NSString *voiceUrl = @"";
//        //创建录音model
//        YKChatMessageModel *model = [YKChatMessageManager createVoiceMessage:self.userModel
//                                                                      duration:duration/1000
//                                                                      voiceUrl:voiceUrl
//                                                                      isSender:YES];
//        [self sendMessageModel:model];
    }
    else {
        NSLog(@"取消录音");

    }


}

#pragma mark - 点击事件

- (void)selectClick{
    [self setSelectAnimate];
    self.slelectBackgroundView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
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
    //添加注释提交
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
    _lock = [[NSConditionLock alloc] initWithCondition:0];
    _queue = dispatch_queue_create("currentQueue", DISPATCH_QUEUE_CONCURRENT);

    for (int i=0; i < assets.count; i++) {
        PHAsset *asset=assets[i];
        UIImage *tempImage = photos[i];
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
//        NSString * imageName = [[resource.assetLocalIdentifier componentsSeparatedByString:@"/"] firstObject];
        NSString * imageSuffix = [[resource.originalFilename componentsSeparatedByString:@"."] lastObject];
        [self sendImage:tempImage imageSuffix:imageSuffix inde:i];
    }
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark - 发送图片
-(void)sendImage:(UIImage *)image imageSuffix:(NSString *)imageSuffix inde:(int)inde{
    NSLog(@"进入的顺序是%d",inde);

    //缩略图
    UIImage *thumImage = [self scaleImage:image toScale:0.5];

    //缩略图的base64字符串
    NSData *thumData = UIImageJPEGRepresentation(thumImage,1.0f);
    NSString *thumImageStr =[thumData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

    //原图的base64字符串
    NSData *originalData = UIImageJPEGRepresentation(image,1.0f);
    NSString *originalImageStr =[originalData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

    //发送状态正在发送中 图片使用base64字符串加载
    YKChatMessageModel *msgModel = [YKChatMessageManager createImageMessage:self.userModel thumbnail:thumImageStr original:originalImageStr thumImage:thumImage oriImage:image isSender:YES];
    [self sendMessageModel:msgModel];


    [[YKTokenApiService service] sendImageWithChatId:self.chatId content:originalImageStr suffix:imageSuffix requestMethod:@"PUT" completion:^(id responseObject, NSError *error) {
        if (!error) {
            dispatch_async(_queue, ^{
                [_lock lockWhenCondition:inde];
                NSLog(@"发送成功执行完成的顺序是%d",inde);

                NSString *original = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,responseObject[@"orignImg"]];
                NSString *thumbnail = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,responseObject[@"smallImg"]];

                //发送状态成功 存储大小图片的网址  更新数据库
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    msgModel.sendType = YKMessageSendTypeSuccess;
                    msgModel.thumbnail = thumbnail;
                    msgModel.original  = original;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:original completion:nil];
                    [[SDImageCache sharedImageCache] storeImage:thumImage forKey:thumbnail completion:nil];
                    [[YKChatDBManager DBManager] updateMessageModel:msgModel chatWithUser:self.userModel];
                    [self.pictureArray addObject:original];
                    [self.contentTableView reloadData];
                });
                [_lock unlockWithCondition:inde + 1];
            });
        }else{
            dispatch_async(_queue, ^{
                [_lock lockWhenCondition:inde];
                NSLog(@"发送失败执行完成的顺序是%d",inde);
                //发送状态失败 存储图片的base64字符串
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    msgModel.sendType = YKMessageSendTypeFailed;
                    [[YKChatDBManager DBManager] updateMessageModel:msgModel chatWithUser:self.userModel];
                    [self.pictureArray addObject:originalImageStr];
                    [self.contentTableView reloadData];
                });
                [_lock unlockWithCondition:inde + 1];
            });
        }
    }];
    
//    NSLog(@"进入的顺序是%d",inde);
//
//    //缩略图
//    UIImage *thumImage = [self scaleImage:image toScale:0.5];
//
//    //缩略图的base64字符串
//    NSData *thumData = UIImageJPEGRepresentation(thumImage,1.0f);
//    NSString *thumImageStr =[thumData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//
//    //原图的base64字符串
//    NSData *originalData = UIImageJPEGRepresentation(image,1.0f);
//    NSString *originalImageStr =[originalData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//
//    //发送状态正在发送中 图片使用base64字符串加载
//    YKChatMessageModel *msgModel = [YKChatMessageManager createImageMessage:self.userModel thumbnail:thumImageStr original:originalImageStr thumImage:thumImage oriImage:image isSender:YES];
//    [self sendMessageModel:msgModel];
//
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
//    NSString *accessPath = [NSString stringWithFormat:@"%@/app/chat-record/v2.0/send",TOKEN_SERVER];
//    // 请求参数字典
//    NSDictionary *params = @{@"chatId":self.chatId,
//                             @"client":@"1",
//                             @"quessionId":@"",
//                             @"type":@"1",
//                             @"content":originalImageStr,
//                             @"suffix":imageSuffix
//    };
//
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:accessPath parameters:params error:nil];
//    request.timeoutInterval = 10.f;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:accessToken forHTTPHeaderField:@"X-Access-Auth-Token"];
//
//    NSURLSessionTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        if ([responseObject[@"code"] intValue] == 200) {
//            dispatch_async(_queue, ^{
//                [_lock lockWhenCondition:inde];
//                NSLog(@"执行成功的顺序是%d",inde);
//
//                NSString *original = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,responseObject[@"data"][@"orignImg"]];
//                NSString *thumbnail = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,responseObject[@"data"][@"smallImg"]];
//
//                //发送状态成功 存储大小图片的网址  更新数据库
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    msgModel.sendType = YKMessageSendTypeSuccess;
//                    msgModel.thumbnail = thumbnail;
//                    msgModel.original  = original;
//                    [[SDImageCache sharedImageCache] storeImage:image forKey:original completion:nil];
//                    [[SDImageCache sharedImageCache] storeImage:thumImage forKey:thumbnail completion:nil];
//                    [[YKChatDBManager DBManager] updateMessageModel:msgModel chatWithUser:self.userModel];
//                    [self.pictureArray addObject:original];
//                    [self.contentTableView reloadData];
//                });
//                [_lock unlockWithCondition:inde + 1];
//            });
//        }else{
//            dispatch_async(_queue, ^{
//                [_lock lockWhenCondition:inde];
//                NSLog(@"执行失败的顺序是%d",inde);
//                //发送状态失败 存储图片的base64字符串
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    msgModel.sendType = YKMessageSendTypeFailed;
//                    [[YKChatDBManager DBManager] updateMessageModel:msgModel chatWithUser:self.userModel];
//                    [self.pictureArray addObject:originalImageStr];
//                    [self.contentTableView reloadData];
//                });
//                [_lock unlockWithCondition:inde + 1];
//            });
//        }
//    }];
//
//    [task resume];

}

#pragma mark - 点击查看大图

- (void)showOriginalImageWithCurrentImageURL:(NSString *)currentImageURL{
    
    NSMutableArray *datas = [NSMutableArray array];
    [self.pictureArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length > 100) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageData = ^NSData * _Nullable{
                NSData * imageData =[[NSData alloc] initWithBase64EncodedString:obj options:NSDataBase64DecodingIgnoreUnknownCharacters];
                return imageData;
            };
            [datas addObject:data];
        }else{
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj];
            [datas addObject:data];
        }
    }];
    NSInteger indexConstant  = [self.pictureArray indexOfObject:currentImageURL];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = indexConstant;
    [browser show];
}


#pragma mark - 查看问卷患教详情代理

- (void)CheckQuessionDetailWithURL:(NSString *)quessionURL{
    YKWebVC *webVC = [[YKWebVC alloc]init];
    webVC.titleString = @"问卷详情";
    webVC.urlString = quessionURL;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)CheckTeachDetail{
    
}

#pragma mark - 录音按钮手势冲突处理
//设置手势代理
- (void)updateRecognizerDelegate:(BOOL)appear {
    if (appear) {
        if (self.recognizerDelegate == nil) {
            self.recognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        }
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.delegate = self.recognizerDelegate;
    }
}

//是否响应触摸事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.navigationController.viewControllers.count <= 1) return NO;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.y > KHEIGHT - TOOLBAR_HEIGHT) {
            return NO;
        }
        if (point.x <= 100) {//设置手势触发区
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGFloat tx = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view].x;
        if (tx < 0) {
            return NO;
        }
    }
    return YES;
}

//是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    //UIScrollView的滑动冲突
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollow = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollow.bounds.size.width >= scrollow.contentSize.width) {
            return NO;
        }
        if (scrollow.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

@end


