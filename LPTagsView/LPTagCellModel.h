//
//  LPTagCellModel.h
//  LPSelectTagsDemo
//
//  Created by jm on 16/2/29.
//  Copyright © 2016年 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPTagCellModel : UICollectionViewCell

@property (nonatomic, strong) UIFont *textFont;/**<文字字体,默认12号字体*/
@property (nonatomic, strong) UIColor *textColor;/**<文字颜色，默认blackColor*/
@property (nonatomic, assign) CGFloat radius;/**<圆角，默认0*/
@property (nonatomic, assign) CGFloat boardWidth;/**<边框宽度，默认0.5*/
@property (nonatomic, strong) UIColor *boardColor;/**<边框颜色，默认lightGrayColor*/
@property (nonatomic, strong) UIColor *backgroundColor;/**<cell背景颜色，默认whiteColor*/
@property (nonatomic, assign) UIEdgeInsets textInsets;/**<文字距离cell边框的距离，默认(6, 8, 6, 8),该参数只需要在未选中状态cellModel设置,因为文字是居中的 所以设置左右距离不一样没有效果*/

- (instancetype)init;

@end
