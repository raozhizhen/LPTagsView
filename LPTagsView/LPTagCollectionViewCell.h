//
//  LPTagCollectionViewCell.h
//  startupTools
//
//  Created by jm on 15/12/11.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import <LPBaseTableViewCell.h>
#import "LPTagModel.h"
#import "LPTagCellModel.h"
/**
 *  标签cell
 **/

@protocol LPTagCellSwitchTagDelegate <NSObject>

/**
 *  返回选择的标签
 *
 *  @param tagModel 选择的标签
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell switchTag:(LPTagModel *)model;

/**
 *  取消选择的标签
 *
 *  @param tagModel 标签
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell disSwitchTag:(LPTagModel *)tagModel;

/**
 *  超出最大标签选择数
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell exceedsTheMaximumNumberOfOptions:(NSInteger)maximumNumber;

/**
 *  刷新cell高度
 *
 *  @param height 高度
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell reloadCollectionViewCellHeight:(CGFloat)height;

@end

@interface LPTagCollectionViewCell :LPBaseTableViewCell

/**设置frame和标签数组，初始化标签cell的样式*/
- (instancetype)initWithTagModelArray:(NSArray<LPTagModel *> *)array withSelectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, assign) NSInteger maximumNumber;/**<最多选项数,默认不限制*/

@property (nonatomic, assign) NSInteger maximumHeight;/**<最大高度,默认不限制*/

@property (nonatomic, weak) id <LPTagCellSwitchTagDelegate> switchTagDelegate;

@property (nonatomic, strong) NSArray<LPTagModel *> *tagArray;/**<标签数组,可以从这里获取所有标签选中信息*/

@property (nonatomic, strong) LPTagCellModel *selectedTagCellModel;

@property (nonatomic, strong) LPTagCellModel *notSelectedTagCellModel;

@property (nonatomic, assign) BOOL disableChoose;

+ (NSString *)cellReuseIdentifier;

@end
