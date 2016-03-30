//
//  LPTagCollectionView.h
//  SocialSport
//
//  Created by jm on 15/10/13.
//  Copyright © 2015年 Loopeer. All rights reserved.
//
/**
 *  标签collectionView
 */
#import <Foundation/Foundation.h>
#import "LPTagModel.h"
#import "LPTagCellModel.h"

@protocol LPSwitchTagDelegate <NSObject>
/**
 *  返回选择的标签
 *
 *  @param tagModel 选择的标签
 */
- (void)collectionView:(UICollectionView *)collectionView switchTag:(LPTagModel *)tagModel;
/**
 *  取消选择的标签
 *
 *  @param tagModel 标签
 */
- (void)collectionView:(UICollectionView *)collectionView disSwitchTag:(LPTagModel *)tagModel;

/**
 *  超出最大标签选择数
 */
- (void)collectionView:(UICollectionView *)collectionView exceedsTheMaximumNumberOfOptions:(NSInteger)maximumNumber;

/**
 *  刷新LPTagCollectionView高度
 *
 *  @param tagModel 标签
 */
- (void)collectionView:(UICollectionView *)collectionView reloadHeight:(CGFloat)height;

@end

@interface LPTagCollectionView : UICollectionView

/**设置frame和标签数组，初始化标签cell的样式*/
- (instancetype)initWithFrame:(CGRect)frame withTagModelArray:(NSArray<LPTagModel *> *)array selectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel;

/**设置layout,frame和标签数组，初始化标签cell的样式*/
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withTagModelArray:(NSArray<LPTagModel *> *)array selectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel;

@property (nonatomic, assign) NSInteger maximumNumber;/**<最多选项数,默认不限制*/

@property (nonatomic, assign) NSInteger maximumHeight;/**<最大高度,默认不限制*/

@property (nonatomic, strong) NSArray<LPTagModel *> *tagArray;/**<标签数组*/

@property (nonatomic, strong) LPTagCellModel *selectedTagCellModel;

@property (nonatomic, strong) LPTagCellModel *notSelectedTagCellModel;

@property (nonatomic, weak) id <LPSwitchTagDelegate> tagDelegate;

@property (nonatomic, assign) BOOL disableChoose;/**<禁用选择，默认NO*/

@end
