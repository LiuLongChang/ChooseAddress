//
//  ChooseLocationView.h
//  ChooseLocation
//
//  Created by langyue on 16/8/30.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLocationView : UIView



@property(nonatomic,copy)NSString* addressStr;
@property(nonatomic,copy)void(^chooseFinish)();




@end
