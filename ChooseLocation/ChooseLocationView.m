//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by langyue on 16/8/30.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "UIView+Frame.h"
#import "AddressItem.h"
#import "AddressTableViewCell.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width




static CGFloat const kTopViewHeight = 40;//顶部视图的高度
static CGFloat const kTopTabbarHeight = 30;//地址标签栏的高度


@interface ChooseLocationView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)AddressView * topTabbar;
@property(nonatomic,weak)UIScrollView * contentView;
@property(nonatomic,weak)UIView * underLine;
@property(nonatomic,strong)NSArray * dataSource;
@property(nonatomic,strong)NSArray * dataSource1;
@property(nonatomic,strong)NSArray * dataSource2;
@property(nonatomic,strong)NSMutableArray * tableViews;
@property(nonatomic,strong)NSMutableArray * topTabbarItems;


@end


@implementation ChooseLocationView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{

    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview:separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];


    AddressView * topTabbar = [[AddressView alloc] initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview:separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];


    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;




    _underLine.backgroundColor = [UIColor orangeColor];
    UIScrollView * contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kTopViewHeight - kTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(ScreenWidth, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    [self addTableView];
    _contentView.delegate = self;


}


#pragma mark - TableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([self.tableViews indexOfObject:tableView] == 0) {
        return self.dataSource.count;
    }else if([self.tableViews indexOfObject:tableView] == 1){
        return self.dataSource1.count;
    }else if([self.tableViews indexOfObject:tableView] == 2){
        return self.dataSource2.count;
    }
    return self.dataSource.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //省级别
    if ([self.tableViews indexOfObject:tableView] == 0) {

        AddressItem * item = self.dataSource[indexPath.row][@"addressItem"];
        cell.item = item;
        //市级别
    }else if ([self.tableViews indexOfObject:tableView] == 1){

        NSIndexPath * indexPath0 = [self.tableViews.firstObject indexPathForSelectedRow];
        if ([self addressDictToDataSource:self.dataSource[indexPath0.row][@"sub"]].count == 1) {
            AddressItem * item = self.dataSource1[indexPath.row];
            cell.item = item;
        }else{
            AddressItem * item = self.dataSource1[indexPath.row][@"addressItem"];
            cell.item = item;
        }
        //区级别
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        //
        AddressItem * item = self.dataSource2[indexPath.row];
        cell.item = item;
    }

    return cell;
}


#pragma mark - TableViewDelegate
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.tableViews indexOfObject:tableView] == 0) {

        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        //第二级数据源
        _dataSource1 = [self addressDictToDataSource:self.dataSource[indexPath.row][@"sub"]];

        if (_dataSource1.count == 1) {
            //此时为直辖市，第二级的地名都是区级别
            NSMutableArray * mArray = [NSMutableArray array];
            for (NSString * name in _dataSource1.firstObject[@"sub"]) {
                AddressItem * item = [AddressItem initWithName:name isSelected:NO];
                [mArray addObject:item];
            }
            _dataSource1 = mArray;
        }


        //之前有选中省 重新选择省 切换省。
        if (indexPath0 != indexPath && indexPath0) {

            for (int i=0; i<self.tableViews.count; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            AddressItem * item = self.dataSource[indexPath.row][@"addressItem"];
            [self scrollToNextItem:item.name];
            return indexPath;
            
        }


        //之前未选中省 第一次选择省
        [self addTopBarItem];
        [self addTableView];
        AddressItem * item = self.dataSource[indexPath.row][@"addressItem"];
        [self scrollToNextItem:item.name];


    }else if([self.tableViews indexOfObject:tableView] == 1){

        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        //重新选择市 切换市。
        if (indexPath0 != indexPath && indexPath0) {

            //如果发现省级别字典里sub关联的数组只有一个元素 说明是直辖市 这时2级界面为区级别
            if ([self.dataSource1[indexPath.row] isKindOfClass:[AddressItem class]]) {
                AddressItem * item = self.dataSource1[indexPath.row];
                [self setUpAddress:item.name];
                return indexPath;
            }

            NSMutableArray * mArray = [NSMutableArray array];
            NSArray * tempArray = _dataSource1[indexPath.row][@"sub"];
            for (NSString * name in tempArray) {
                AddressItem * item = [AddressItem initWithName:name isSelected:NO];
                [mArray addObject:item];
            }



            _dataSource2 = mArray;
            [self removeLastItem];
            [self addTopBarItem];
            [self addTableView];

            AddressItem * item = self.dataSource1[indexPath.row][@"addressItem"];
            [self scrollToNextItem:item.name];
            return indexPath;
        }


        //之前未选中市，第一次选择
        if ([self.dataSource1[indexPath.row] isKindOfClass:[AddressItem class]]) {
            AddressItem * item = self.dataSource1[indexPath.row];
            [self setUpAddress:item.name];
        }else{

            NSMutableArray * mArray = [NSMutableArray array];
            NSArray * tempArray = _dataSource1[indexPath.row][@"sub"];
            for (NSString * name in tempArray) {
                AddressItem * item = [AddressItem initWithName:name isSelected:NO];
                [mArray addObject:item];
            }
            _dataSource2 = mArray;

            [self addTopBarItem];
            [self addTableView];
            AddressItem * item = self.dataSource1[indexPath.row][@"addressItem"];
            [self scrollToNextItem:item.name];
        }

    }else if([self.tableViews indexOfObject:tableView] == 2){
        AddressItem * item = self.dataSource2[indexPath.row];
        [self setUpAddress:item.name];
    }

    return indexPath;
}







-(void)addTopBarItem{

    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topBarItem sizeToFit];
    topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];

}


//点击按钮 滚动到对应位置
-(void)topBarItemClick:(UIButton*)btn{
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index* ScreenWidth, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
-(void)changeUnderLineFrame:(UIButton*)btn{
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

//完成地址选择 执行chooseFinish代码块
-(void)setUpAddress:(NSString*)address{
    NSInteger index = self.contentView.contentOffset.x / ScreenWidth;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];

    [self changeUnderLineFrame:btn];

    NSMutableString * addressStr = [[NSMutableString alloc] init];
    for (UIButton * btn in self.topTabbarItems) {
        [addressStr appendString:btn.currentTitle];
        [addressStr appendString:@" "];
    }
    self.addressStr = addressStr;


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });

}



-(void)addTableView{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.tableViews.count * ScreenWidth, 0, ScreenWidth, _contentView.height)];
    [_contentView addSubview:tableView];
    [self.tableViews addObject:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}


//当重新选择省或者市的时候 需要将下级移除。
-(void)removeLastItem{
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];

    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];

}


//滚动到下级界面，并重新设置顶部按钮条上对应按钮的title
-(void)scrollToNextItem:(NSString*)preTitle{

    NSInteger index = self.contentView.contentOffset.x / ScreenWidth;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{

        CGSize size = self.contentView.contentSize;
        self.contentView.contentSize = CGSizeMake(size.width + ScreenWidth, 0);
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + ScreenWidth, offset.y);
        [self changeUnderLineFrame:[self.topTabbar.subviews lastObject]];

    }];

}


#pragma mark - getter 方法
//分割线
-(UIView*)separateLine{
    UIView * separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;

}


-(NSMutableArray*)tableViews{
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}


-(NSMutableArray*)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}


//升级省级数据源
-(NSArray*)dataSource{
    if (_dataSource == nil) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil];
        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray * mArray = [NSMutableArray array];
        for (NSDictionary * dict0 in dict[@"address"]) {
            NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
            [mDict setValue:dict0[@"sub"] forKey:@"sub"];
            AddressItem * item = [AddressItem initWithName:dict0[@"name"] isSelected:NO];
            [mDict setValue:item forKey:@"addressItem"];
            [mArray addObject:mDict];
        }
        _dataSource = mArray;
    }
    return _dataSource;
}



-(NSArray*)addressDictToDataSource:(NSArray*)array{
    NSMutableArray * mArray = [NSMutableArray array];
    for (NSDictionary * dict0 in array) {
        NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
        [mDict setValue:dict0[@"sub"] forKey:@"sub"];
        AddressItem * item = [AddressItem initWithName:dict0[@"name"] isSelected:NO];
        [mDict setValue:item forKey:@"addressItem"];
        [mArray addObject:mDict];
    }
    return mArray;
}


//市级别数据源
-(NSArray*)dataSource1{
    if (_dataSource1 == nil) {
        _dataSource1 = [NSArray array];
    }
    return _dataSource1;
}


//区级别数据源
-(NSArray*)dataSource2{
    if (_dataSource2 == nil) {
        _dataSource2 = [NSArray array];
    }
    return _dataSource2;
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
