//
//  LPTagCell.h
//  SocialSport
//
//  Created by jm on 15/10/13.
//  Copyright © 2015年 Loopeer. All rights reserved.
//
/**
 *  标签Cell
 */
#import <UIKit/UIKit.h>
#import "LPTagModel.h"
#import "LPTagCellModel.h"

@interface LPTagCell : UICollectionViewCell

@property (nonatomic, strong) LPTagModel *model;/**<标签model*/

@property (nonatomic, strong) LPTagCellModel *selectedTagCellModel;
@property (nonatomic, strong) LPTagCellModel *notSelectedTagCellModel;

/**初始化cell样式*/
- (instancetype)initWithSelectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel reuseIdentifier:(NSString *)reuseIdentifier;

+ (NSString *)cellReuseIdentifier;

@end
