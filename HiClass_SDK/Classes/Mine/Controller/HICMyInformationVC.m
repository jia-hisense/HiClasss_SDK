//
//  HICMyInformationVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyInformationVC.h"
#import "HICCustomNaviView.h"
#import "HICMySettingCell.h"
#import "HICNetModel.h"
@interface HICMyInformationVC ()<HICCustomNaviViewDelegate,UITableViewDelegate,UITableViewDataSource,HICMysettingDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong)HICCustomNaviView *navi;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIImage *header;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)UIImageView *blackView;
@property (nonatomic ,strong)UILabel *blackLabel;
@end

@implementation HICMyInformationVC
-(UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 60, 101.5, 120, 120)];
        _blackView.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _blackView;
}
- (UILabel *)blackLabel{
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 221.5 + 8, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"temporarilyNoData", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_15;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blackLabel;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,8, HIC_ScreenWidth, 334) style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [self.view addSubview:_backView];
    }
    return _backView;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[NSLocalizableString(@"head", nil),NSLocalizableString(@"name", nil),NSLocalizableString(@"birthDay", nil),NSLocalizableString(@"sex", nil),NSLocalizableString(@"department", nil),NSLocalizableString(@"jobs", nil)];
    }
    return _titleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self configTable];
    [self createNavi];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"personalMessage", nil) rightBtnName:nil showBtnLine:NO];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
- (void)configTable{
    if ([HICCommonUtils isValidObject:_model]) {
        [self.backView addSubview:self.tableView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else{
        [self.backView addSubview:self.blackView];
        [self.backView addSubview:self.blackLabel];
    }
    
}
//  拍照提示框
-(void)alterHeadPortrait{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction* actionLibrary = [UIAlertAction actionWithTitle:NSLocalizableString(@"selectFromPhotoAlbum", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self choosephoto:1];
        }];
    [alert addAction:actionLibrary];
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:NSLocalizableString(@"takingPictures", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [self choosephoto:2];
    }];
    [alert addAction:takePhoto];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizableString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)choosephoto:(NSInteger)type{
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //通过相机，UIImagePickerControllerSourceTypeCamera
        //通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
    if (type == 1) {
      PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    PickerImage.allowsEditing = YES;
    PickerImage.delegate = self;
    PickerImage.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:PickerImage animated:YES completion:nil];
}
#pragma mark ---UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto 用来存放我们选择的图片
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.header = newPhoto;
    [self loadDataWithImage:newPhoto];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 网络请求方法
// 1. 图片上传借口
- (void)loadDataWithImage:(UIImage *)image {
    NSString *urlStr = [NSString stringWithFormat:@"%@/heduapi/pub_api/v1.0/file/upload", APP_UPLOAD_DOMAIN];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];

    NSString *paramUrl = [NSString stringWithFormat:@"%@?category=1&dirName=HeadPortraitFile&fileType=1&terminalType=1",urlStr];
    NSURL *reqURL = [NSURL URLWithString: paramUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reqURL];

    NSString *boundary = @"wfWiEWrgEFA9A78512weF7106A";
    request.HTTPMethod = @"POST";
   
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 30.f;

    NSData *imageData = [self imageCompressToData:image withSize:1];
    NSMutableData *paramData = [NSMutableData data];
    NSString *fileName = @"image.png";
    NSString *fileKey = @"fileData";
    NSString *accessToken = USER_TOKEN;
    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\";accessToken=\"%@\"\r\n\r\n",boundary,fileKey,fileName,accessToken];
    [paramData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
    [paramData appendData:imageData]; //加入文件的数据
    [paramData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //设置结尾
    [paramData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = paramData;
    //设置请求头总数据长度
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)paramData.length] forHTTPHeaderField:@"Content-Length"];

    // 上传
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task;

    task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 解析数据
            NSError *jsonError;
            NSDictionary *pesDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (!jsonError) {
                // 正确的解析道服务器数据
                NSNumber *code = [pesDic objectForKey:@"resultCode"];
                if (code.integerValue == 0) {
                    // 此时上传文件成功 -- 失败的情况都不做处理， 返回的数据字典keys值为空
                    NSArray *array = [pesDic objectForKey:@"data"];
                    if (array && [array isKindOfClass:NSArray.class] && array.count != 0) {
                        [mDic setDictionary:array.firstObject];
                        NSString *picUrl = [mDic valueForKey:@"fileUrl"];
                        [self uploadHeaderWith:picUrl];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //主线程执行
                            self.model.headPic = picUrl;
                            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        });
                    } else {
                        DDLogError(@"[WebSDK] -- 上传图片失败,返回的数据类型不正确：%@", pesDic);
                    }
                }
            }
        } else {
            DDLogError(@"[WebSDK] -- 上传图片失败：%@", error);
        }
    }];
    [task resume];

}

- (void)uploadHeaderWith:(NSString *)picUrl {
    [HICAPI uploadHeaderWith:picUrl success:^(NSDictionary * _Nonnull responseObject) {
        [RoleManager hiddenWindowLoadingView];
        NSString *toastStr = NSLocalizableString(@"profilePictureUploadedSuccessfully", nil);
        if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSDictionary.class]) {
            NSNumber *points = responseObject[@"data"][@"points"];
            if (points && points.integerValue > 0) {
                toastStr = [NSString stringWithFormat:@"%@，%@", toastStr, HICLocalizedFormatString(@"rewardPointsToast", points.integerValue)];
            }
        }
        [HICToast showWithText:toastStr];
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:NSLocalizableString(@"profilePictureUploadedFailed", nil)];
        [RoleManager hiddenWindowLoadingView];
    }];
}

///压缩图片
- (NSData *)imageCompressToData:(UIImage *)image withSize:(CGFloat)size{
    CGFloat compression = 1;
    NSData *data = [[NSData alloc] init];
    if ([image isKindOfClass:UIImage.class]) {
        data = UIImageJPEGRepresentation(image, compression);
        while (data.length > size*1024*1024 && compression > 0) {
            compression -= 0.09;
            data = UIImageJPEGRepresentation(image, compression); // When compression less than a value, this code dose not work
        }
    }
    return data;
}


#pragma mark - - - HICCustomNaviViewDelegate
- (void)leftBtnClicked {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark ----HICMysettingDelegate

- (void) changeHeader{
    [self alterHeadPortrait];
}
#pragma  mark -----uitableviewdelegate&&datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [HICCommonUtils isValidObject: _model] ? 6 : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 84;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMySettingCell *cell = (HICMySettingCell *)[tableView dequeueReusableCellWithIdentifier:@"myInfoCell"];
    if (!cell) {
      cell = [[HICMySettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myInfoCell"];
    }
    if (indexPath.row == 0) {
        [cell haveDiscoureLabel:NO isSwitch:NO haveRightLabel:NO haveRightImage:NO isHeader:YES andLeftStr:self.titleArr[indexPath.row] andRightStr:@""];
        if (self.header) {
           cell.header = self.header;
            cell.isHeader = YES;
        }else if ([NSString isValidStr:_model.headPic]){
//            UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.headPic]]];
            cell.headerPic = _model.headPic;
            cell.isHeader = YES;
        }else{
            cell.name = _model.name;
            cell.isHeader = NO;
        }
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
    }else{
        
        NSArray * arr = @[@"1",_model.name,[NSString isValidStr:_model.birthday]?_model.birthday:@"--",[_model.sex isEqualToString: @"1"]?NSLocalizableString(@"nan", nil):NSLocalizableString(@"nv", nil),_model.department,[NSString isValidStr:_model.post]?_model.post:@"--"];
        [cell haveDiscoureLabel:NO isSwitch:NO haveRightLabel:YES haveRightImage:NO isHeader:NO andLeftStr:self.titleArr[indexPath.row] andRightStr:arr[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}
@end
