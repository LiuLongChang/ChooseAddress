//
//  AddressTableViewCell.m
//  ChooseLocation
//
//  Created by langyue on 16/8/30.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import "AddressTableViewCell.h"




@interface AddressTableViewCell()



@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;



@end



@implementation AddressTableViewCell


-(void)setItem:(AddressItem*)item{

    _item = item;
    _addressLabel.text = item.name;
    _addressLabel.textColor = item.isSelected ? [UIColor orangeColor] : [UIColor blackColor];
    _selectFlag.hidden = !item.isSelected;

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
