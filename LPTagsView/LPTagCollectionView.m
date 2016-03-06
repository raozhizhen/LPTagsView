//
//  LPTagCollectionView.m
//  SocialSport
//
//  Created by jm on 15/10/13.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import "LPTagCollectionView.h"
#import "LPTagCell.h"
#import "UICollectionViewLeftAlignedLayout.h"

static NSString * const kSelectedTagcellReuseIdentifier = @"selectedTagcellReuseIdentifier";
static NSString * const kNotSelectedTagcellReuseIdentifier = @"notSelectedTagcellReuseIdentifier";

@interface LPTagCollectionView() <UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout>

@end

@implementation LPTagCollectionView {
    LPTagCellModel *_selectedTagCellModel;
    LPTagCellModel *_notSelectedTagCellModel;
    
    NSIndexPath *_lastChoose;
    NSInteger _chooseNumber;
    BOOL _setUpHeight;
}

- (instancetype)initWithFrame:(CGRect)frame withTagModelArray:(NSArray<LPTagModel *> *)array selectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel {
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    flowLayout.minimumLineSpacing = 12;
    flowLayout.minimumInteritemSpacing = 12;
    flowLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    self = [self initWithFrame:frame collectionViewLayout:flowLayout withTagModelArray:array selectedTagCellModel:selectedTagCellModel notSelectedTagCellModel:notSelectedTagCellModel];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withTagModelArray:(NSArray<LPTagModel *> *)array selectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel {
    self = [self initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.allowsMultipleSelection = YES;
        self.scrollEnabled = NO;
        _selectedTagCellModel = selectedTagCellModel;
        _notSelectedTagCellModel = notSelectedTagCellModel;
        self.delegate = self;
        self.dataSource = self;
        self.maximumNumber = NSIntegerMax;
        _maximumHeight = NSIntegerMax;
        self.tagArray = array;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[LPTagCell class] forCellWithReuseIdentifier:kSelectedTagcellReuseIdentifier];
        [self registerClass:[LPTagCell class] forCellWithReuseIdentifier:kNotSelectedTagcellReuseIdentifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_tagArray[indexPath.row].isChoose) {
        LPTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSelectedTagcellReuseIdentifier forIndexPath:indexPath];
        cell.selectedTagCellModel = _selectedTagCellModel;
        cell.notSelectedTagCellModel = _notSelectedTagCellModel;
        cell.model = _tagArray[indexPath.row];
        _lastChoose = indexPath;
        return cell;
    } else {
        LPTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNotSelectedTagcellReuseIdentifier forIndexPath:indexPath];
        cell.selectedTagCellModel = _selectedTagCellModel;
        cell.notSelectedTagCellModel = _notSelectedTagCellModel;
        cell.model = _tagArray[indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_disableChoose)
        return;
    LPTagCell *cell = (LPTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (((LPTagModel *)_tagArray[indexPath.row]).isChoose) {
        [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        return;
    }
    if (_chooseNumber < _maximumNumber) {
        _chooseNumber ++;
        ((LPTagModel *)_tagArray[indexPath.row]).isChoose = YES;
        cell.model = _tagArray[indexPath.row];
        [self switchTag:cell.model];
    } else {
        if (_maximumNumber == 1) {
            [self collectionView:collectionView didDeselectItemAtIndexPath:_lastChoose];
            _chooseNumber ++;
            ((LPTagModel *)_tagArray[indexPath.row]).isChoose = YES;
            cell.model = _tagArray[indexPath.row];
            [self switchTag:cell.model];
            return;
        }
        [self exceedsTheMaximumNumberOfOptions];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_disableChoose)
        return;
    LPTagCell *cell = (LPTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (((LPTagModel *)_tagArray[indexPath.row]).isChoose) {
        ((LPTagModel *)_tagArray[indexPath.row]).isChoose = NO;
        _chooseNumber --;
        cell.model = _tagArray[indexPath.row];
        [self disSwitchTag:cell.model];
    } else {
        if  (self.allowsMultipleSelection) {
            [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }
        return;
    }
}

- (void)setMaximumNumber:(NSInteger)maximumNumber {
    _maximumNumber = maximumNumber;
    if (maximumNumber == 1) {
        self.allowsMultipleSelection = NO;
    } else if (maximumNumber <= 0) {
        self.disableChoose = YES;
    }
}

- (void)setTagArray:(NSArray *)tagArray {
    _tagArray = tagArray;
    _chooseNumber = 0;
    for (int i = 0; i < tagArray.count; i++) {
        if (((LPTagModel *)_tagArray[i]).isChoose) {
            _chooseNumber ++;
        }
    }
}

- (void)switchTag:(LPTagModel *)tagModel {
    if (self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(collectionView: switchTag:)]) {
        [self.tagDelegate collectionView:self switchTag:tagModel];
    }
}

- (void)disSwitchTag:(LPTagModel *)tagModel {
    if (self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(collectionView: disSwitchTag:)]) {
        [self.tagDelegate collectionView:self disSwitchTag:tagModel];
    }
}

- (void)exceedsTheMaximumNumberOfOptions{
    if (self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(collectionView: exceedsTheMaximumNumberOfOptions:)]) {
        [self.tagDelegate collectionView:self exceedsTheMaximumNumberOfOptions:self.maximumNumber];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentSizeHeight = MIN(self.contentSize.height, _maximumHeight);
    if (_height != contentSizeHeight && contentSizeHeight != 0 && _setUpHeight) {
        if (self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(collectionView:reloadHeight:)]) {
            _setUpHeight = NO;
            [self.tagDelegate collectionView:self reloadHeight:contentSizeHeight];
            if (contentSizeHeight < self.contentSize.height) {
                self.scrollEnabled = YES;
            } else {
                self.scrollEnabled = NO;
            }
        }
    }
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    _setUpHeight = YES;
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = font;
    UIEdgeInsets insets;
    font = _notSelectedTagCellModel.textFont;
    insets = _notSelectedTagCellModel.textInsets;
    CGSize size = [_tagArray[indexPath.row].name sizeWithAttributes:@{NSFontAttributeName:font}];
    return CGSizeMake((NSInteger)(size.width + insets.left + insets.right), (NSInteger)(size.height + insets.bottom));
}

@end
