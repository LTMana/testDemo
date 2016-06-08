//
//  ViewController.m
//  dispath_group
//
//  Created by liubotong on 16/6/7.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "jamViewController.h"
#import "roadViewController.h"
@interface ViewController ()
@property (nonatomic) dispatch_group_t group;
@property (nonatomic) NSDictionary *jam;
@property (nonatomic) NSDictionary *road;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jam:) name:@"Jam" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(road:) name:@"Road" object:nil];
    
    
//    dispatch_queue_t queeu =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    self. group =dispatch_group_create();
//    
//    
//    NSArray *aaa =@[@1,@2,@3,@4,@5,@6,@7];
//    
//    NSArray *ddd=@[@0,@2,@4,@6,@8,@10];
//    
//    dispatch_group_async(self.group,dispatch_get_main_queue(), ^{
//        self.aaa =aaa;
//    });
//    
//    
//    dispatch_group_async(self.group,dispatch_get_main_queue(), ^{
//        self.ddd =ddd;
//       
//    });

    int a =0;
    void *b=0;
    
    [self indfd:b];
   
    
    [self inadfc:&a];
    
    NSLog(@"a%d",a);
    // Do any additional setup after loading the view, typically from a nib.
}



-(void)indfd:(void **)dd
{
    
    
    
    
   
}


-(void)inadfc:(int *)p
{
   // NSLog(@"%d",*p);
    
    *p=5;
}

-(void)jam:(NSNotification *)note
{
    self.jam =note.userInfo;
    [self jamDic:self.jam roadDic:self.road];
}
-(void)road:(NSNotification *)note
{
    self.road =note.userInfo;
    [self jamDic:self.jam roadDic:self.road];
    
}



-(void)jamDic:(NSDictionary *)jam roadDic:(NSDictionary *)road
{
    if (jam==nil ||road ==nil) return;
  
    
    
    NSLog(@"jam:%@ , road:%@",jam,road);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
//        [self test:self.ddd test1:self.aaa];
//    });

    jamViewController *jam=[[jamViewController alloc]init];
    [jam jam];
    
    roadViewController *road=[[roadViewController alloc]init];
    [road road];
    
    
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


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Jam" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Road" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
