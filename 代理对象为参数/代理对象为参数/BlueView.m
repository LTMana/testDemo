//
//  BlueView.m
//  
//
//  Created by 刘博通 on 16/6/16.
//
//

#import "BlueView.h"

@implementation BlueView


-(void)initForDelegate:(id<RedViewDelegate>)delegate
{

    _delegate =delegate;

}


-(IBAction)redCilck:(UIButton *)btn
{
    
    
    if (_delegate ||[_delegate respondsToSelector:@selector(RedView:cilkEvent:)]) {
        [self textBlue];
        [_delegate RedView:self cilkEvent:@"按钮被点击了"];
    }
    
    
}


-(void)textBlue
{
    [[[RedView alloc] init] addBlue:_delegate];
}
@end
