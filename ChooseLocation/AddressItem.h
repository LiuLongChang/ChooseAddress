//
//  AddressItem.h
//  ChooseLocation
//
//  Created by langyue on 16/8/30.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressItem : NSObject



@property(nonatomic,copy)NSString * name;
@property(nonatomic,assign)BOOL isSelected;


+(instancetype)initWithName:(NSString*)name isSelected:(BOOL)isSelected;




@end
