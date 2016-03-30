//
//  LPTagCollectionViewCell.m
//  StartupTools
//
//  Created by jm on 15/12/11.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import "LPTagCollectionViewCell.h"
#import "LPTagCollectionView.h"

@interface LPTagCollectionViewCell () <LPSwitchTagDelegate>

@end

@implementation LPTagCollectionViewCell {
    LPTagCollectionView *_tagCollectionView;
    NSArray<LPTagModel *> *_tagModelArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithTagModelArray:(NSArray<LPTagModel *> *)array withSelectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _tagArray = array;
        _selectedTagCellModel = selectedTagCellModel;
        _notSelectedTagCellModel = notSelectedTagCellModel;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _tagCollectionView = [[LPTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height) withTagModelArray:_tagArray selectedTagCellModel:_selectedTagCellModel notSelectedTagCellModel:_notSelectedTagCellModel];
    _tagCollectionView.tagDelegate = self;
    [self.contentView addSubview:_tagCollectionView];
}

- (void)setDisableChoose:(BOOL)disableChoose {
    _disableChoose = disableChoose;
    _tagCollectionView.disableChoose = disableChoose;
}

- (void)setMaximumNumber:(NSInteger)maximumNumber {
    _maximumNumber = maximumNumber;
    _tagCollectionView.maximumNumber = maximumNumber;
}

- (void)setMaximumHeight:(NSInteger)maximumHeight {
    _maximumHeight = maximumHeight;
    _tagCollectionView.maximumHeight = maximumHeight;
}

- (void)setSelectedTagCellModel:(LPTagCellModel *)selectedTagCellModel {
    _selectedTagCellModel = selectedTagCellModel;
    _tagCollectionView.selectedTagCellModel = _selectedTagCellModel;
}

- (void)setNotSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel {
    _notSelectedTagCellModel = notSelectedTagCellModel;
    _tagCollectionView.notSelectedTagCellModel = _notSelectedTagCellModel;
}


- (void)setTagArray:(NSArray<LPTagModel *> *)tagArray {
    _tagArray = tagArray;
    _tagCollectionView.tagArray = tagArray;
}

- (void)collectionView:(UICollectionView *)collectionView reloadHeight:(CGFloat)height {
    if (self.switchTagDelegate && [self.switchTagDelegate respondsToSelector:@selector(tableViewCell:reloadCollectionViewCellHeight:)]) {
        [self.switchTagDelegate tableViewCell:self reloadCollectionViewCellHeight:height];
        _tagCollectionView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, height);
    }
}

- (void)collectionView:(UICollectionView *)collectionView  switchTag:(LPTagModel *)tagModel {
    if (self.switchTagDelegate && [self.switchTagDelegate respondsToSelector:@selector(tableViewCell:switchTag:)]) {
        [self.switchTagDelegate tableViewCell:self switchTag:tagModel];
    }
}

- (void)collectionView:(UICollectionView *)collectionView  disSwitchTag:(LPTagModel *)tagModel {
    if (self.switchTagDelegate && [self.switchTagDelegate respondsToSelector:@selector(tableViewCell:disSwitchTag:)]) {
        [self.switchTagDelegate tableViewCell:self disSwitchTag:tagModel];
    }
}

- (void)collectionView:(UICollectionView *)collectionView exceedsTheMaximumNumberOfOptions:(NSInteger)maximumNumber {
    if (self.switchTagDelegate && [self.switchTagDelegate respondsToSelector:@selector(tableViewCell:exceedsTheMaximumNumberOfOptions:)]) {
        [self.switchTagDelegate tableViewCell:self exceedsTheMaximumNumberOfOptions:maximumNumber];
    }
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass(self);
}

@end
