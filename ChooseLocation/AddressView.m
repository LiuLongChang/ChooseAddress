//
//  AddressView.m
//  ChooseLocation
//
//  Created by langyue on 16/8/30.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import "AddressView.h"
#import "UIView+Frame.h"


static CGFloat const BarItemMargin = 20;

@interface AddressView()

@property(nonatomic,strong)NSMutableArray * btnArray;

@end




@implementation AddressView

-(void)layoutSubviews{
    [super layoutSubviews];

    for (NSInteger i=0; i <= self.btnArray.count - 1; i++) {
        UIView * view = self.btnArray[i];
        if (i == 0) {
            view.left = BarItemMargin;
        }

        if (i > 0) {
            UIView * preView = self.btnArray[i-1];
            view.left = BarItemMargin + preView.right;
        }

    }

}



-(NSMutableArray*)btnArray{
    NSMutableArray * mArray = [NSMutableArray array];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
