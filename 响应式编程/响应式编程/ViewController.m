//
//  ViewController.m
//  响应式编程
//
//  Created by liubotong on 16/6/10.
//  Copyright (c) 2016年 LT. All rights reserved.
//

#import "ViewController.h"
#import "count.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@property (strong, nonatomic)count *c;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    count *c=[count sharedInstanceTool];
    _c=c;
    [c addObserver:self forKeyPath:@"count"options:NSKeyValueObservingOptionNew context:nil];
    
}




-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

   self.textlabel.text =change[@"new"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
