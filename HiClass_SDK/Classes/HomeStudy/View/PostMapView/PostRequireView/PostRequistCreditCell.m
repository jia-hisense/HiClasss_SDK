//
//  PostRequistCreditCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostRequistCreditCell.h"

@interface PostRequistCreditCell ()

@property (nonatomic, strong) UILabel *autCreditNum;
@property (nonatomic, strong) UILabel *autCreditNumDid;

@property (nonatomic, strong) UILabel *assCreditNum;
@property (nonatomic, strong) UILabel *assCreditNumDid;

@end

@implementation PostRequistCreditCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {
    UILabel *autStudy = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:autStudy];
    UILabel *autCont = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:autCont];

    UILabel *autCreditReq = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:autCreditReq];
    UILabel *autCreditNum = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:autCreditNum];

    UILabel *autCreditReqDid = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:autCreditReqDid];
    UILabel *autCreditNumDid = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:autCreditNumDid];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.backView addSubview:lineView];

    UILabel *assStudy = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:assStudy];
    UILabel *assCont = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:assCont];

    UILabel *assCreditReq = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:assCreditReq];
    UILabel *assCreditNum = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:assCreditNum];

    UILabel *assCreditReqDid = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:assCreditReqDid];
    UILabel *assCreditNumDid = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:assCreditNumDid];

    [autStudy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];
    [autCont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(autStudy.mas_bottom).offset(2);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];
    [autCreditReq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(autCont.mas_bottom).offset(12);
        make.right.greaterThanOrEqualTo(autCreditNum.mas_left).offset(3);
    }];
    [autCreditNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(autCont.mas_bottom).offset(12);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];
    [autCreditReqDid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(autCreditReq.mas_bottom).offset(5);
        make.right.greaterThanOrEqualTo(autCreditNumDid.mas_left).offset(3);
    }];
    [autCreditNumDid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(autCreditReq.mas_bottom).offset(5);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(autCreditReqDid.mas_bottom).offset(11.5);
        make.right.equalTo(self.backView.mas_right).offset(-16);
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.height.offset(0.5);
    }];

    [assStudy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(lineView.mas_bottom).offset(12);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];
    [assCont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(assStudy.mas_bottom).offset(2);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];
    [assCreditReq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(assCont.mas_bottom).offset(12);
        make.right.greaterThanOrEqualTo(assCreditNum.mas_left).offset(3);
    }];
    [assCreditNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(assCont.mas_bottom).offset(12);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];
    [assCreditReqDid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(assCreditReq.mas_bottom).offset(5);
        make.right.greaterThanOrEqualTo(assCreditNumDid.mas_left).offset(3);
    }];
    [assCreditNumDid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(assCreditReq.mas_bottom).offset(5);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];

    self.titleLabel.text = NSLocalizableString(@"creditsRequired", nil);

    autStudy.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    autStudy.text = NSLocalizableString(@"autonomousLearning", nil);
    autCont.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    autCont.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    autCont.text = NSLocalizableString(@"creditsEarnedByActivelystudyingKnowledge", nil);

    autCreditReq.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    autCreditReq.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    autCreditReq.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"creditsRequired", nil)];
    autCreditNum.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    autCreditNum.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.autCreditNum = autCreditNum;

    autCreditReqDid.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    autCreditReqDid.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    autCreditReqDid.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"creditHasBeenObtained", nil)];
    autCreditNumDid.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    autCreditNumDid.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    self.autCreditNumDid = autCreditNumDid;

    assStudy.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    assStudy.text = NSLocalizableString(@"assignedLearning", nil);
    assCont.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    assCont.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    assCont.text = NSLocalizableString(@"completeCredits", nil);

    assCreditReq.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    assCreditReq.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    assCreditReq.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"creditsRequired", nil)];
    assCreditNum.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    assCreditNum.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.assCreditNum = assCreditNum;

    assCreditReqDid.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    assCreditReqDid.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    assCreditReqDid.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"creditHasBeenObtained", nil)];
    assCreditNumDid.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    assCreditNumDid.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    self.assCreditNumDid = assCreditNumDid;

}

-(void)setModel:(HICPostMapDetailReqModel *)model {
    if (self.model == model) {
        return;
    }
    [super setModel:model];

    self.autCreditNum.text = [NSString stringWithFormat:@"%@%@", [HICCommonUtils formatFloat:model.selfStudyCredit],NSLocalizableString(@"credits", nil)];
    self.autCreditNumDid.text = [NSString stringWithFormat:@"%@%@", [HICCommonUtils formatFloat:model.mySelfStudyCredit],NSLocalizableString(@"credits", nil)];
    self.assCreditNum.text = [NSString stringWithFormat:@"%@%@", [HICCommonUtils formatFloat:model.assignStudyCredit],NSLocalizableString(@"credits", nil)];
    self.assCreditNumDid.text = [NSString stringWithFormat:@"%@%@", [HICCommonUtils formatFloat:model.myAssignStudyCredit],NSLocalizableString(@"credits", nil)];
}

@end
