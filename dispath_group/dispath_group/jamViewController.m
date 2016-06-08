//
//  jamViewController.m
//  
//
//  Created by 刘博通 on 16/6/7.
//
//

#import "jamViewController.h"
#import "AFNetworking.h"
@interface jamViewController ()

@end

@implementation jamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //http://mobile.trafficeye.com.cn:8087/EventService/raditiondetail?id=411874&restype=json
    
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)jam
{
    NSString *urlStr =@"http://mobile.trafficeye.com.cn:8087/EventService/raditiondetail?id=411874&restype=json";
    
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        //NSLog(@"%@",responseObject);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Jam" object:nil userInfo:responseObject];
        
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
