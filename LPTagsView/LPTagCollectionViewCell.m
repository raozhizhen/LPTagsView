//
//  LPTagCollectionViewCell.m
//  LPTagsViewDemo
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

- (instancetype)initWithTagModelArray:(NSArray<LPTagModel *> *)array withSelectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tagArray = array;
        _tagCollectionViewHeight = 40;
        _tagCollectionView = [[LPTagCollectionView alloc] initWithFrame:CGRectZero withTagModelArray:array selectedTagCellModel:selectedTagCellModel notSelectedTagCellModel:notSelectedTagCellModel];
        _tagCollectionView.tagDelegate = self;
        _tagModelArray = array;
        _tagCollectionView.height = _tagCollectionViewHeight;
        [self.contentView addSubview:_tagCollectionView];
        
        _tagCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _tagCollectionView.tagArray = array;
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagCollectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tagCollectionView)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tagCollectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tagCollectionView)]];
    }
    return self;
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

- (void)collectionView:(UICollectionView *)collectionView reloadHeight:(CGFloat)height {
    _tagCollectionViewHeight = height;
    if (self.switchTagDelegate && [self.switchTagDelegate respondsToSelector:@selector(tableViewCell:reloadCollectionViewCellHeight:)]) {
        [self.switchTagDelegate tableViewCell:self reloadCollectionViewCellHeight:height];
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
