//
//  LPTagCellModel.m
//  LPSelectTagsDemo
//
//  Created by jm on 16/2/29.
//  Copyright © 2016年 Jim. All rights reserved.
//

#import "LPTagCellModel.h"

@implementation LPTagCellModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _textFont = [UIFont systemFontOfSize:12];
        _textColor = [UIColor blackColor];
        _radius = 0;
        _boardWidth = 0;
        _backgroundColor = [UIColor whiteColor];
        _textInsets = UIEdgeInsetsMake(6, 8, 6, 8);
    }
    return self;
}

@end
