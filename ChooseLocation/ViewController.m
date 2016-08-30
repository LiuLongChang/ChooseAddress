//
//  ViewController.m
//  ChooseLocation
//
//  Created by langyue on 16/8/30.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import "ViewController.h"
#import "ChooseLocationView.h"



@interface ViewController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate>


@property(nonatomic,strong)ChooseLocationView * chooseLocationView;
@property(nonatomic,strong)UIView * cover;
@property(weak,nonatomic)IBOutlet UILabel * addressLabel;



@end

@implementation ViewController



- (IBAction)chooseLocation:(UIButton *)sender {
    //选择地址按钮点击事件

    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
        self.cover.hidden = !self.cover.hidden;
        self.chooseLocationView.hidden = self.cover.hidden;
    }];

}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)) {
        return NO;
    }
    return YES;
}



-(void)tapCover:(UITapGestureRecognizer*)tap{
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}

-(UIView*)cover{
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];

        [[UIApplication sharedApplication].keyWindow addSubview:_cover];

        _chooseLocationView = [[ChooseLocationView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-350, [UIScreen mainScreen].bounds.size.width, 350)];
        [_cover addSubview:_chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.addressLabel.text = weakSelf.chooseLocationView.addressStr;
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.cover.hidden = YES;

            }];
        };

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;

    }
    return _cover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
