//
//  ViewController.m
//  dispath_group
//
//  Created by liubotong on 16/6/7.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) dispatch_group_t group;
@property (nonatomic) NSArray *aaa;
@property (nonatomic) NSArray *ddd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_queue_t queeu =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self. group =dispatch_group_create();
    
    
    NSArray *aaa =@[@1,@2,@3,@4,@5,@6,@7];
    
    NSArray *ddd=@[@0,@2,@4,@6,@8,@10];
    
    dispatch_group_async(self.group,dispatch_get_main_queue(), ^{
        self.aaa =aaa;
    });
    
    
    dispatch_group_async(self.group,dispatch_get_main_queue(), ^{
        self.ddd =ddd;
       
    });

    
   
  
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [self test:self.ddd test1:self.aaa];
    });

}

-(void)test:(
NSArray *)ddd test1:(NSArray *)aaa
{
//    NSLog(@"%@",ddd);
//    NSLog(@"%@",aaa);
    
    while (YES) {
    
        //NSLog(@"1");
        
        for (int i; i<aaa.count; i++) {
        
            for (int j; j<ddd.count; j++) {
                
                int dddd =[ddd[j] intValue];
                int aaaa =[aaa[i] intValue];
                NSLog(@"%d",dddd +aaaa);
               
                if (dddd+aaaa ==12) {
                    NSLog(@"%d",dddd +aaaa);
                    return;
                }
                
            }
            
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
