//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 刘博通 on 16/11/1.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "oneViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import "NSObject+Claculate.h"
#import "CaculatorMake.h"
#import "Caculator.h"
#import "TwoViewController.h"
#import "FlagItem.h"
#import "redView.h"

@interface oneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (nonatomic ,strong) RACCommand *command;

@property (weak, nonatomic) IBOutlet redView *redView;
@end

@implementation oneViewController






- (void)viewDidLoad {
    [super viewDidLoad];
   
    //kvo
    [[self.redView rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x){
        
        NSLog(@"%@",x);
        
    }];
    
    //代理
    [[self.redView rac_signalForSelector:@selector(test)] subscribeNext:^(id x){
        self.redView.center = CGPointMake(12, 500);
    }];
    
    //监听文本框
    [self.nameText.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x){
        
        NSLog(@"键盘有动作");
        
    }];
    
    
    RACSignal *request1=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [subscriber sendNext:@"发送请求1"];
        
        return nil;
    }];
    
    RACSignal *request2=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [subscriber sendNext:@"发送请求2"];
        
        return nil;
    }];

  
    
    [self rac_liftSelector:@selector(updataUIR1:R2:) withSignalsFromArray:@[request1,request2]];
    

}


-(void)updataUIR1:(id)data R2:(id)data1
{
       NSLog(@"更新UI%@  %@",data,data1);
}


- (IBAction)requestData:(id)sender {
    
    
    
   
    

    
   // [self baseRacConmend];
    
}


-(void)baseRacConmend
{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        NSLog(@"执行命令");
        
        
        
        
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            
            NSURLSessionDataTask *task =[[AFHTTPSessionManager manager] GET:@"http://mobile.trafficeye.com.cn:8087/EventService/raditiondetail?id=100557279&restype=json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [subscriber sendNext:responseObject];
                
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendError:error];
                
            }];
            
            
            return [RACDisposable disposableWithBlock:^{
                
                [task cancel];
                
            }];
            
            
        }];
        
        
        
    }];
    
    
    
    _command = command;
    
    [command.executionSignals subscribeNext:^(id x) {
        
        
        NSLog(@"%@",[x class]);
        [x subscribeNext:^(NSDictionary *dict) {
            NSDictionary *dic =dict[@"response"][@"result"];
            [dic.rac_sequence.signal subscribeNext:^(id x) {
                
                
                
                RACTupleUnpack(NSString *key,NSString *value) = x;
                
                NSLog(@"%@,%@",key,value);
            }];
            
            
            
        }];
        
        
    }];
    
    [command execute:@1];

}


- (IBAction)preasentBtn:(id)sender {
    
    TwoViewController *twoVc =[[self storyboard] instantiateViewControllerWithIdentifier:@"twoVc"];
    [self presentViewController:twoVc animated:YES completion:nil];
    
    twoVc.delegateSignal =[RACSubject subject];
    
    
    [twoVc.delegateSignal subscribeNext:^(id x) {
        NSLog(@"点击了通知按钮");
    } ];
    
    
}


-(void)arrayWithDic
{
    NSArray *numbers =@[@1,@2,@3,@4];
    
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"NSArray:%@",x);
    }];
    
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        RACTupleUnpack(NSString *key , NSString *value) =x;
        
        NSLog(@"%@ %@",key,value);
        
    }];
    
}


-(void)valueForKeyModel
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        
        return [FlagItem flagWithDict:value];
        
    }] array];
    
    [flags.rac_sequence.signal subscribeNext:^(FlagItem *item) {
        NSLog(@"====%@,%ld====",item.name,(long)item.age);
    }];
    
}




-(void)addCaculatorMake
{
    NSInteger result =[NSObject makeCaculators:^(CaculatorMake *make) {
        make.add(1).add(3);
        make.add(2).subtraction(4).add(7);
    }];
    
    NSLog(@"计算结果是:%ld",(long)result);
    
}


-(void)addCaculator
{
    Caculator *c =[[Caculator alloc] init];
    
    
    
    BOOL isqule =[[[c caculator:^NSInteger(NSInteger result) {
        
        result += 2;
        result *= 5;
        return result;
        
        
    }] equle:^BOOL(NSInteger result) {
        
        return result == 10;
        
    }] isEqule];
    
    NSLog(@"是否相等:%d",isqule);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
