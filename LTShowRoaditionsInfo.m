//
//  LTShowRoaditionsInfo.m
//
//
//  Created by 刘博通 on 16/5/12.
//
//

#import "LTShowRoaditionsInfo.h"
#import "LTRoadConditonDetailModel.h"
#import "LTRoadConfirmView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "TKTools.h"
#import "TKConstant.h"

static NSString *const LTValidUrl =@"http://mobile.trafficeye.com.cn:8000/api/v41/EventEvaluation";
@interface LTShowRoaditionsInfo ()
@property (weak, nonatomic) IBOutlet UIImageView *roadIcon;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *roaditionDetail;
@property (weak, nonatomic) IBOutlet UIButton *effectiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *nonEffectiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *publishUserLabel;


@property (assign, nonatomic)NSInteger effectiveBtnCilkCount;
@property (assign, nonatomic)NSInteger nonEffectiveBtnCilkCount;
@end

@implementation LTShowRoaditionsInfo

-(void)awakeFromNib
{
    self.autoresizingMask =UIViewAutoresizingNone;
    //self.translatesAutoresizingMaskIntoConstraints =NO;
}

-(void)setDetailModel:(LTRoadConditonDetailModel *)detailModel
{
    _detailModel =detailModel;
    
    if (detailModel.eventPublishUser!=5) {
        self.publishUserLabel.text =@"来自:世纪高通";
    }else
    {
        self.publishUserLabel.text =@"来自:热心用户";
    }
    
    if ([detailModel.roadName isEqualToString:@""]) {
        self.adressLabel.text=@"无名路";
    }else{
        self.adressLabel.text =detailModel.roadName;

    }
    self.roaditionDetail.text =detailModel.eventDescription;
    
    self.roadIcon.image =[UIImage imageNamed:detailModel.roadConditionIcon];
    if (!detailModel.validCount==0) {
        [self.effectiveBtn setTitle:[NSString stringWithFormat:@"有用(%ld)",(long)detailModel.validCount ] forState:UIControlStateNormal];
    }else{
        [self.effectiveBtn setTitle:@"有用" forState:UIControlStateNormal];
        
    }
    if (!detailModel.invalidCount==0) {
        [self.nonEffectiveBtn setTitle:[NSString stringWithFormat:@"无用(%ld)",(long)detailModel.invalidCount ] forState:UIControlStateNormal];
    }else{
        [self.nonEffectiveBtn setTitle:@"无用" forState:UIControlStateNormal];
        
    }
    
}

+(instancetype)getShowRoaditionView
{
    
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (IBAction)effective:(UIButton *)sender {
    
    self.effectiveBtnCilkCount++;
    [self requestValid:1];
    
}

- (IBAction)nonEffective:(UIButton *)sender {
    self.nonEffectiveBtnCilkCount++;
    [self requestValid:0];
}

-(void)requestValid:(NSInteger)ValidOrIncalid
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"pid"]=[TKTools getUUID];
    NSNumber *num=[TKTools getThingsFromPlistWithKey:kKeyForPhone];
    NSLog(@"num:%@",num);
    if ([TKTools getThingsFromPlistWithKey:kKeyForPhone]==nil) {
        params[@"phoneNum"]=[NSNull null];

    }else{
        params[@"phoneNum"]=[TKTools getThingsFromPlistWithKey:kKeyForPhone];
 
    }
        if ([TKTools getThingsFromPlistWithKey:kKeyForUid]==nil) {
        params[@"uid"]=@(0);
    }else{
        params[@"uid"]=[TKTools getThingsFromPlistWithKey:kKeyForUid];
    }
    params[@"eventId"]=@(self.detailModel.eventId);
    params[@"invalid"] =@(ValidOrIncalid);
    [[AFHTTPSessionManager manager] GET:LTValidUrl parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger invalidCount =[responseObject[@"invalidCount"] integerValue];
           NSInteger validCount =[responseObject[@"validCount"] integerValue];
        
        
        if (validCount!=0) {
            [self.effectiveBtn setTitle:[NSString stringWithFormat:@"有用(%ld)",validCount] forState:UIControlStateNormal];

        }
        
        if (invalidCount!=0) {
            [self.nonEffectiveBtn setTitle:[NSString stringWithFormat:@"无用(%ld)",invalidCount] forState:UIControlStateNormal];
            
        }

                                 
//        if (ValidOrIncalid ==0) {
//            if (invalidCount==0) {
//        
//                if(self.detailModel.invalidCount==0){
//                    
//                }else{
//                    [self.nonEffectiveBtn setTitle:[NSString stringWithFormat:@"无用(%ld)",(long)_detailModel.invalidCount] forState:UIControlStateNormal];
//                    
//                 }
//                
//            }else{
//                _detailModel.invalidCount+=1;
//                [self.nonEffectiveBtn setTitle:[NSString stringWithFormat:@"无用(%ld)",_detailModel.invalidCount] forState:UIControlStateNormal];
//
//            }
//            
//            
//        }else{
//            if (validCount==0) {
//                if (self.detailModel.validCount==0) {
//                    
//                }else{
//                [self.effectiveBtn setTitle:[NSString stringWithFormat:@"有用(%ld)",(long)_detailModel.validCount] forState:UIControlStateNormal];
//                }
//
//            }else{
//                _detailModel.validCount +=1;
//                [self.effectiveBtn setTitle:[NSString stringWithFormat:@"有用(%ld)",_detailModel.validCount] forState:UIControlStateNormal];
//
//          }
   // }
        
        [SVProgressHUD showInfoWithStatus:responseObject[@"desc"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"请检测网络"];
    }];
    
}


//if (invalidCount==0) {
//    [self.nonEffectiveBtn setTitle:[NSString stringWithFormat:@"无用(%ld)",_detailModel.invalidCount] forState:UIControlStateNormal];
//}else{
//    
//    [self.nonEffectiveBtn setTitle:[NSString stringWithFormat:@"无用(%ld)",_detailModel.invalidCount+1] forState:UIControlStateNormal];
//    
//}






/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
