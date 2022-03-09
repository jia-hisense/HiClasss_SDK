//
//  HICQuestionModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICQuestionModel : NSObject
/**
"questionId":"long,考题id",
"questionName":"string,考题名称",
"questionType":"integer,考题类型",
"difficulty":"integer,难度级别",
"status":"integer,试题状态",
"testingPoint":"string,考点名称列表，逗号分隔",
"questionStem":"string,题干",
"score":"integer,考题分值",
"blanks":"integer,填空题的填空数量",
"optionsType":"integer,选项类型",
"isReviewed":"string,是否批阅 0-未批阅，1已批阅",
"isRight":"string,是否正确，0-否，1-正确",
"actualScore":"integer,实际得分",
"optionList":Array[1],
"answerList":Array[1],
"answerResult":Object{...},
"analysis":"string,解析"
 "optionList":[
                    {
                        "id":"long,选项标识",
                        "value":"string,选项值"
                    }
                ],
                "answerList":[
                    {
                        "id":"long,答案标识",
                        "value":"string,答案值（ 选择/判断：选项ID  填空题：多个空拼接存储，按空的顺序存备选答案，部分填空无备选答案存储时需用占位符占位 其他题型：文字、图片url的json字符串）"
                    }
                ],
 "answerResult":{
                    "questionId":"long,考题标识",
                    "questionType":"integer,题型",
                    "questionOrder":"integer,考题序号",
                    "answers":[
                        {
                            "order":"integer,选项序号",
                            "id":"long,选项id",
                            "tag":"string,选项标签，针对选择/判断题型，如：A、B等",
                            "selected":"boolean,是否选中，针对选择/判断；(终端更换设备后重新获取题时可作为判断是否；终端更换设备后用于判断当前题是否答过）",
                            "value":"string,选择判断题为选项值，填空题为多个填空的json串，主观题为具体作答内容"
                        }
                    ]
                },
 */
@property (nonatomic ,assign)NSInteger questionId;//long,考题id",
@property (nonatomic ,assign)NSInteger questionType;//:"integer,难度级别",
@property (nonatomic ,assign)NSInteger difficulty;//"integer,难度级别",
@property (nonatomic ,assign)NSInteger status;//integer,试题状态",
@property (nonatomic ,assign)NSInteger score;//integer,考题分值",
@property (nonatomic ,assign)NSInteger blanks;//integer,填空题的填空数量"
@property (nonatomic ,assign)NSInteger optionsType;//:"integer,选项类型",
@property (nonatomic ,assign)NSInteger actualScore;//实际得分
@property (nonatomic ,strong)NSString *questionName;//"string,考题名称",
@property (nonatomic ,strong)NSString *testingPoint;//string,考点名称列表，逗号分隔"
@property (nonatomic ,strong)NSString *isReviewed;//是否批阅 0-未批阅，1已批阅",
@property (nonatomic ,strong)NSString *isRight;//是否正确，0-否，1-正确",
@property (nonatomic ,strong)NSString *analysis;//"string,解析"
@property (nonatomic ,strong)NSArray *optionList;//
@property (nonatomic ,strong)NSArray *answerList;//
@property (nonatomic ,strong)NSDictionary *answerResult;
@end

NS_ASSUME_NONNULL_END
