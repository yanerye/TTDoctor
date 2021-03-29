//
//  YKUserInfoVC.m
//  TTDoctor
//
//  Created by YK on 2020/6/18.
//  Copyright © 2020 YK. All rights reserved.
//

#import "YKUserInfoVC.h"
#import "YKUserInfoCell.h"
#import "MMPopupView.h"
#import "MMSheetView.h"
#import "YKChangePasswordVC.h"
#import "YKProvinceVC.h"
#import "YKHospitalVC.h"
#import "YKDepartmentsVC.h"
#import "YKPatientAreasVC.h"
#import "YKProfessionalNameVC.h"

@interface YKUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation YKUserInfoVC
{
    YKDoctor *_doctor;
    NSString *_provienceStr;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"头像",@"姓名",@"手机号",@"登录密码",@"省份",@"医院",@"科室",@"病区",@"职称"];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户与安全";
    self.view.backgroundColor = [UIColor whiteColor];
    _doctor = [YKDoctorHelper shareDoctor];
    _provienceStr = _doctor.province;
    [self layoutAllSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)layoutAllSubviews {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.view);
    }];
}


#pragma mark - init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBACOLOR(242, 242, 246);

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] init];
    view.backgroundColor = RGBACOLOR(242, 242, 246);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YKUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YKUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.userImageView.hidden = NO;
        cell.detailLabel.hidden = YES;
        NSString *picUrl = _doctor.picUrl;
        NSString *doctorImageStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,picUrl];
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:doctorImageStr] placeholderImage:[UIImage imageNamed:@"我的_医生默认"]];
    }else{
        cell.userImageView.hidden = YES;
        cell.detailLabel.hidden = NO;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.rightImageView.hidden = YES;
    }else{
        cell.rightImageView.hidden = NO;
    }
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.titleArray[indexPath.row];
    }else{
        cell.titleLabel.text = self.titleArray[indexPath.row + 4];
    }
    

    if (indexPath.section == 0 ) {
        if (indexPath.row == 1) {
            cell.detailLabel.text = _doctor.familyname;
        }else if (indexPath.row == 2){
            cell.detailLabel.text = _doctor.contactway;
        }else if (indexPath.row == 3){
            cell.detailLabel.text = @"";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.detailLabel.text = _doctor.province;
        }else if (indexPath.row == 1){
            cell.detailLabel.text = _doctor.hospitalName;
        }else if (indexPath.row == 2){
            cell.detailLabel.text = _doctor.deptName;
        }else if (indexPath.row == 3){
            cell.detailLabel.text = _doctor.patientAreaName;
        }else{
            cell.detailLabel.text = _doctor.professionalRanksName;
        }
    }
     
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            MMPopupItemHandler block = ^(NSInteger index){
                if (index == 0) {
                    [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
                } else if(index == 1) {
                    [self showImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                }
            };
            
            NSArray *items = @[MMItemMake(@"拍照", MMItemTypeNormal, block),
                               MMItemMake(@"从相册中选择", MMItemTypeNormal, block)];
            
            [[[MMSheetView alloc] initWithTitle:nil items:items] showWithBlock:nil];
        }else if (indexPath.row == 2){
            
        }else if (indexPath.row == 3){
            YKChangePasswordVC *vc = [[YKChangePasswordVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            YKProvinceVC *vc = [[YKProvinceVC alloc] init];
            vc.cityBlock = ^(NSDictionary *dic) {
                NSString * tempStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
                _provienceStr = tempStr;
                _doctor.province = tempStr;
                [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                [self.tableView reloadData];
                [self upDateDoctoeInfoWithKeyStr:@"province" value:dic[@"name"]];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            //选医院 先选省份
            if (_provienceStr.length == 0) {
                [YKAlertHelper showErrorMessage:@"请选择省份" inView:self.view];
            } else {
                YKHospitalVC *vc = [[YKHospitalVC alloc] init];
                vc.provienceStr = _provienceStr;
                vc.hospitalBlock = ^(NSDictionary *dic) {
                    NSString * tempStr = [NSString stringWithFormat:@"%@",dic[@"hospitalName"]];
                    _doctor.hospitalName = tempStr;
                    [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                    [self.tableView reloadData];
                    [self upDateDoctoeInfoWithKeyStr:@"hospitalId" value:dic[@"id"]];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.row == 2){
            YKDepartmentsVC *vc = [[YKDepartmentsVC alloc] init];
            vc.departmentBlock = ^(NSDictionary *dic) {
                NSString * tempStr = [NSString stringWithFormat:@"%@",dic[@"deptName"]];
                _doctor.deptName = tempStr;
                [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                [self.tableView reloadData];
                [self upDateDoctoeInfoWithKeyStr:@"deptId" value:dic[@"deptId"]];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            YKPatientAreasVC *vc = [[YKPatientAreasVC alloc] init];
            vc.areaBlock = ^(NSDictionary *dic) {
                NSString * tempStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
                _doctor.patientAreaName = tempStr;
                [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                [self.tableView reloadData];
                [self upDateDoctoeInfoWithKeyStr:@"patientAreaId" value:dic[@"id"]];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            YKProfessionalNameVC * vc = [[YKProfessionalNameVC alloc] init];
            vc.professionalBlock = ^(NSDictionary *dic) {
                NSString * tempStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
                _doctor.professionalRanksName = tempStr;
                [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                [self.tableView reloadData];
                [self upDateDoctoeInfoWithKeyStr:@"professionalRanksId" value:dic[@"id"]];
            };
            [self.navigationController pushViewController:vc animated:YES];

        }
    }


}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
}


#pragma merk - private

- (void)showImagePickerWithType:(UIImagePickerControllerSourceType)type {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //保存图片到相册
            UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
            //压缩图片
            image =  [self imageCompressForWidth:image targetWidth:800];
        }else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            image =  [self imageCompressForWidth:image targetWidth:image.size.width/2];
        }
        
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString * dataStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [YKHUDHelper showHUDInView:self.view];
        [[YKApiService service] updateDoctorImageWithImageData:dataStr completion:^(id responseObject, NSError *error) {
            if (!error) {
                [YKHUDHelper hideHUDInView:self.view];
                NSString * tempStr = [NSString stringWithFormat:@"%@",responseObject[@"user"][@"localPic"]];
                _doctor.picUrl = tempStr;
                [YKDoctorHelper updateDoctorWithDoctor:_doctor];
                [self.tableView reloadData];
            }else{
                [YKHUDHelper hideHUDInView:self.view];
                [YKAlertHelper showErrorMessage:error.localizedFailureReason inView:self.view];
            }
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 图片压缩

- (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        
    }
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 修改信息

- (void)upDateDoctoeInfoWithKeyStr:(NSString *)keyStr value:(NSString *)valueStr{
    [[YKApiService service] updateDoctorBaseInfoWithKeyStr:keyStr valueStr:valueStr completion:^(id responseObject, NSError *error) {
        if (!error) {
            
        }else{
            [YKAlertHelper showErrorMessage:@"修改失败" inView:self.view];
        }
    }];
}

@end
