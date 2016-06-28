//
//  BlueView.h
//  
//
//  Created by 刘博通 on 16/6/16.
//
//

#import <UIKit/UIKit.h>
#import "RedView.h"

@interface BlueView : UIView
@property (nonatomic, weak) id<RedViewDelegate> delegate;
-(void)initForDelegate:(id<RedViewDelegate>)delegate;


@end
