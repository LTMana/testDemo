//
//  roadViewController.m
//  
//
//  Created by 刘博通 on 16/6/7.
//
//

#import "roadViewController.h"
#import "AFNetworking.h"
@interface roadViewController ()

@end

@implementation roadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  http://mobile.trafficeye.com.cn:8087/EventService/raditionshow/range?eventlevel=0,605&restype=json&lt=112.891742,28.302822&rb=113.02327,28.161818000000004
    
    
    
    // Do any additional setup after loading the view.
}

-(void)road
{
    NSString *urlStr =@"http://mobile.trafficeye.com.cn:8087/EventService/raditionshow/range?eventlevel=0,605&restype=json&lt=112.891742,28.302822&rb=113.02327,28.161818000000004";
    
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
       // NSLog(@"%@",responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Road" object:nil userInfo:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
