//
//  CNMKOverlayView.h
//  cennavimapapi
//
//  Created by Lion on 13-3-12.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//

#import "CNMKOverlay.h"

@interface CNMKOverlayView : UIView {
@package
    id <CNMKOverlay> _overlay;
}

- (CNMKOverlayView *)initWithOverlay:(id <CNMKOverlay>)overlay;

@property (nonatomic, readonly) id <CNMKOverlay> overlay;

@property (nonatomic) int zoomLevel;

//@property (nonatomic, readonly) CNMKGeoRect region;

- (BOOL)updateOverlayViewRect:(CNMKScrRect)visibleRect;

@end
