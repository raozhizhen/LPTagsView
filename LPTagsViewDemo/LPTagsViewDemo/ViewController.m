//
//  ViewController.m
//  LPTagsViewDemo
//
//  Created by jm on 16/3/6.
//  Copyright © 2016年 Jim. All rights reserved.
//

#import "ViewController.h"
#import "LPTagCollectionViewCell.h"
#import <LPToast.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, LPTagCellSwitchTagDelegate>

@end

@implementation ViewController {
    LPTagCellModel *_selectedTagCellModel;
    LPTagCellModel *_notSelectedTagCellModel;
    
    UITableView *_tableView;
    NSArray *_tagArray;
    NSArray *_tagArray2;
    
    CGFloat _tagCellHeight;
    CGFloat _labelCellHeight;
}

- (void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[LPBaseTableViewCell class] forCellReuseIdentifier:[LPBaseTableViewCell cellReuseIdentifier]];
    [_tableView registerClass:[LPTagCollectionViewCell class] forCellReuseIdentifier:[LPTagCollectionViewCell cellReuseIdentifier]];
    [_tableView registerClass:[LPTagCollectionViewCell class] forCellReuseIdentifier:@"2312"];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置collectionviewCell初始高度
    _tagCellHeight = 40;
    _labelCellHeight = 40;
    
    //设置tagcell样式
    _selectedTagCellModel = [[LPTagCellModel alloc] init];
    _selectedTagCellModel.textColor = [UIColor whiteColor];
    _selectedTagCellModel.textFont = [UIFont systemFontOfSize:14];
    _selectedTagCellModel.radius = 12;
    _selectedTagCellModel.backgroundColor = [UIColor redColor];
    
    _notSelectedTagCellModel = [[LPTagCellModel alloc] init];
    _notSelectedTagCellModel.textColor = [UIColor blueColor];
    _notSelectedTagCellModel.textFont = [UIFont systemFontOfSize:12];
    _notSelectedTagCellModel.radius = 5;
    _notSelectedTagCellModel.boardWidth = 0.5;
    _notSelectedTagCellModel.boardColor = [UIColor blueColor];
    _notSelectedTagCellModel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //配置数据
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 40; i ++) {
        LPTagModel *model = [[LPTagModel alloc] init];
        model.name = [NSString stringWithFormat:@"标签 %li", i];
        model.isChoose = NO;
        [array addObject:model];
    }
    _tagArray = array.copy;
    array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 40; i ++) {
        LPTagModel *model = [[LPTagModel alloc] init];
        model.name = [NSString stringWithFormat:@"label %li", i];
        model.isChoose = NO;
        [array addObject:model];
    }
    _tagArray2 = array.copy;
    
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 10 && indexPath.row != 8) {
        LPBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LPBaseTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
        if (indexPath.row == 9) {
            cell.textLabel.text = @"点我查看选中的标签";
        } else {
            cell.textLabel.text = @"这是一个cell";
        }
        return cell;
    } else {
        if (indexPath.row == 8) {
            LPTagCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LPTagCollectionViewCell cellReuseIdentifier] forIndexPath:indexPath];
            cell.maximumNumber = 1;
            cell.switchTagDelegate = self;
            cell.selectedTagCellModel = _selectedTagCellModel;
            cell.notSelectedTagCellModel = _notSelectedTagCellModel;
            cell.tagArray = _tagArray;
            cell.maximumHeight = 200;
            return cell;
        } else {
            LPTagCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2312" forIndexPath:indexPath];
            cell.maximumNumber = 1;
            cell.selectedTagCellModel = _selectedTagCellModel;
            cell.notSelectedTagCellModel = _notSelectedTagCellModel;
            cell.switchTagDelegate = self;
            cell.tagArray = _tagArray2;
            return cell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 10 && indexPath.row != 8) {
        return 40;
    }
    if (indexPath.row == 8) {
        return _tagCellHeight;
    }
    return _labelCellHeight;
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell switchTag:(LPTagModel *)model {
    NSLog(@"添加了%@", model.name);
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell disSwitchTag:(LPTagModel *)tagModel {
    NSLog(@"去掉了%@", tagModel.name);
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell reloadCollectionViewCellHeight:(CGFloat)height {
    NSIndexPath *indexPath = [_tableView indexPathForCell:tableViewCell];
    if (indexPath.row == 8) {
        _tagCellHeight = height;
        NSLog(@"cell8----%f", height);
    } else {
        _labelCellHeight = height;
        NSLog(@"cell10----%f", height);
    }
    [_tableView beginUpdates];
    [_tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 9) {
        NSMutableArray *tagModelSelectArray = [[NSMutableArray alloc] init];
        NSMutableArray *tagModelSelectArray2 = [[NSMutableArray alloc] init];
        
        for (LPTagModel *tagModel in _tagArray) {
            if (tagModel.isChoose) {
                [tagModelSelectArray addObject:tagModel.name];
            }
        }
        for (LPTagModel *tagModel in _tagArray2) {
            if (tagModel.isChoose) {
                [tagModelSelectArray2 addObject:tagModel.name];
            }
        }
        
        [LPToast showToast:[NSString stringWithFormat:@"cell8:%@, cell10:%@", [tagModelSelectArray componentsJoinedByString:@","], [tagModelSelectArray2 componentsJoinedByString:@","]]];
    }
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell exceedsTheMaximumNumberOfOptions:(NSInteger)maximumNumber {
    [LPToast showToast:[NSString stringWithFormat:@"最多只能选择%li个标签", maximumNumber]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
