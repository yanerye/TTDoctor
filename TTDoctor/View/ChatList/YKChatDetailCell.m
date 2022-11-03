//
//  YKChatDetailCell.m
//  TTDoctor
//
//  Created by YK on 2020/7/6.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKChatDetailCell.h"

@interface YKChatDetailCell()
//头像
@property (nonatomic, strong) UIImageView *logoImageView;
//文字
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UILabel     *messageLabel;
//图片
@property (nonatomic, strong) UIImageView *pictureImageView;
//问卷
@property (nonatomic, strong) UIImageView *quessionBackImage;
@property (nonatomic, strong) UIImageView *quessionImageView;
@property (nonatomic, strong) UILabel     *quessionNameLabel;
@property (nonatomic, strong) UILabel     *quessionStateLabel;
//患教
@property (nonatomic, strong) UIImageView *teachBackImage;
@property (nonatomic, strong) UIImageView *teachImageView;
@property (nonatomic, strong) UILabel     *teachNameLabel;


@end

@implementation YKChatDetailCell
{
    YKDoctor *_doctor;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGBACOLOR(237, 239, 243);
        _doctor = [YKDoctorHelper shareDoctor];
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    [self createLogoImageView];
    
    [self createBubbleImageView];
    [self createMessageLabel];
    
    [self createPictureImageView];
    
    [self createQuessionBackImage];
    [self createQuessionImageView];
    [self createQuessionNameLabel];
    [self createQuessionStateLabel];
    
    [self createTeachBackImage];
    [self createTeachImageView];
    [self createTeachNameLabel];
}

#pragma mark - 创建子视图

- (void)createLogoImageView{
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.hidden = YES;
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 20;
    [self addSubview:_logoImageView];
}

- (void)createBubbleImageView{
    _bubbleImageView = [[UIImageView alloc] init];
    _bubbleImageView.hidden = YES;
    [self addSubview:_bubbleImageView];
}

- (void)createMessageLabel{
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.hidden = YES;
    _messageLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_messageLabel];
    _messageLabel.numberOfLines=0;
    _messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _messageLabel.font = [UIFont systemFontOfSize:15];
    _messageLabel.textColor = [UIColor blackColor];
}

- (void)createPictureImageView{
    _pictureImageView = [[UIImageView alloc] init];
    _pictureImageView.backgroundColor = [UIColor lightGrayColor];
    _pictureImageView.hidden = YES;
    _pictureImageView.layer.cornerRadius = 4;//设置那个圆角的有多圆
    _pictureImageView.layer.borderWidth = 0.5;//设置边框的宽度
    _pictureImageView.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    _pictureImageView.layer.masksToBounds = YES;//设为NO去试试。设置YES是保证添加的图片覆盖视图的效果
    [self addSubview:_pictureImageView];
}

#pragma mark - 问卷相关控件

- (void)createQuessionBackImage{
    _quessionBackImage = [[UIImageView alloc] init];
    _quessionBackImage.hidden = YES;
    _quessionBackImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGtR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quessionDetail)];
    [_quessionBackImage addGestureRecognizer:tapGtR];
    [self addSubview:_quessionBackImage];
}

- (void)createQuessionImageView{
    _quessionImageView = [[UIImageView alloc] init];
    _quessionImageView.hidden = YES;
    [self.quessionBackImage addSubview:_quessionImageView];
}

- (void)createQuessionNameLabel{
    _quessionNameLabel = [[UILabel alloc] init];
    _quessionNameLabel.hidden = YES;
    _quessionNameLabel.backgroundColor = [UIColor clearColor];
    [self.quessionBackImage addSubview:_quessionNameLabel];
    _quessionNameLabel.numberOfLines=0;
    _quessionNameLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _quessionNameLabel.font = [UIFont systemFontOfSize:13];
    _quessionNameLabel.textColor = [UIColor whiteColor];
}

- (void)createQuessionStateLabel{
    _quessionStateLabel = [[UILabel alloc] init];
    _quessionStateLabel.hidden = YES;
    _quessionStateLabel.backgroundColor = [UIColor clearColor];
    [self.quessionBackImage addSubview:_quessionStateLabel];
    _quessionStateLabel.font = [UIFont systemFontOfSize:12];
    _quessionStateLabel.textColor = RGBACOLOR(70, 150, 212);
}

#pragma mark - 患教相关控件

- (void)createTeachBackImage{
    _teachBackImage = [[UIImageView alloc] init];
    _teachBackImage.hidden = YES;
    [self addSubview:_teachBackImage];
}

- (void)createTeachImageView{
    _teachImageView = [[UIImageView alloc] init];
    _teachImageView.hidden = YES;
    [self.teachBackImage addSubview:_teachImageView];
}

- (void)createTeachNameLabel{
    _teachNameLabel = [[UILabel alloc] init];
    _teachNameLabel.hidden = YES;
    _teachNameLabel.backgroundColor = [UIColor clearColor];
    [self.teachBackImage addSubview:_teachNameLabel];
    _teachNameLabel.numberOfLines=0;
    _teachNameLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _teachNameLabel.font = [UIFont systemFontOfSize:13];
    _teachNameLabel.textColor = RGBACOLOR(70, 150, 212);
}

#pragma mark - 赋值

- (void)configUI:(YKMessageModel *)messageModel patientImage:(NSString *)patientImage{
    self.messageModel = messageModel;
    
    _logoImageView.hidden = NO;
    _logoImageView.frame = [messageModel logoFrame];
    
    _bubbleImageView.hidden = NO;
    _bubbleImageView.frame = [messageModel bubbleFrame];
    
    if (messageModel.messageSenderType == MessageSenderTypeMe) {
        NSString *tempString = [NSString stringWithFormat:@"%@%@",BASE_SERVER,_doctor.picUrl];
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:tempString]];
        _bubbleImageView.image = [[UIImage imageNamed:@"气泡_蓝色"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentRight;
    }else{
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:patientImage]];
        _bubbleImageView.image = [[UIImage imageNamed:@"气泡_白色"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }

    
    switch (messageModel.messageType) {
        case MessageTypeText:
            _messageLabel.hidden = NO;
            _messageLabel.frame = [messageModel messageFrame];
            _messageLabel.text = messageModel.content;
            if (_messageLabel.frame.size.height == 20) {
                if (messageModel.messageSenderType == MessageSenderTypeMe) {
                    _messageLabel.textAlignment = NSTextAlignmentRight;
                }else{
                    _messageLabel.textAlignment = NSTextAlignmentLeft;
                }
            }else{
                _messageLabel.textAlignment = NSTextAlignmentLeft;
            }
            break;
            
        case MessageTypeImage:
        {
            _pictureImageView.hidden = NO;
            _pictureImageView.frame = [messageModel imageFrame];
            [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:messageModel.smallImg]];
        }
        break;
            
        case MessageTypeQuession:
            _quessionBackImage.hidden = NO;
            _quessionBackImage.frame = [messageModel quessionFrame];
            _quessionBackImage.image = [UIImage imageNamed:@"气泡_问卷"];
            
            _quessionImageView.hidden = NO;
            _quessionImageView.frame = CGRectMake(15, 8, 45, 45);
            _quessionImageView.image = [UIImage imageNamed:@"聊天_问卷"];
            
            _quessionNameLabel.hidden = NO;
            _quessionNameLabel.frame = CGRectMake(70, 8, 112, 45);
            _quessionNameLabel.text = [NSString stringWithFormat:@"%@",messageModel.content];

            _quessionStateLabel.hidden = NO;
            _quessionStateLabel.frame = CGRectMake(156, 60, 60, 18);
            _quessionStateLabel.text = @"未答复";
            
            break;
            
        case MessageTypeTeach:
            _teachBackImage.hidden = NO;
            _teachBackImage.frame = [messageModel teachFrame];
            _teachBackImage.image = [UIImage imageNamed:@"气泡_患教"];
            
            _teachImageView.hidden = NO;
            _teachImageView.frame = CGRectMake(15, 10, 45, 45);
            _teachImageView.image = [UIImage imageNamed:@"聊天_患教"];
            
            _teachNameLabel.hidden = NO;
            _teachNameLabel.frame = CGRectMake(70, 10, 120, 45);
            _teachNameLabel.text = [NSString stringWithFormat:@"%@",messageModel.content];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 点击事件

- (void)quessionDetail{
    if ([self.delegate respondsToSelector:@selector(CheckQuessionDetailWithURL:)]) {
        [self.delegate CheckQuessionDetailWithURL:self.messageModel.quessionUrl];
    }
}


    
@end
