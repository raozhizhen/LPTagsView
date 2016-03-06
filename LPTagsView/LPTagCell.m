//
//  LPTagCell.m
//  SocialSport
//
//  Created by jm on 15/10/13.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import "LPTagCell.h"

@implementation LPTagCell {
    UILabel *_textLabel;
    UIImageView *_imageView;
}

- (instancetype)initWithSelectedTagCellModel:(LPTagCellModel *)selectedTagCellModel notSelectedTagCellModel:(LPTagCellModel *)notSelectedTagCellModel reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _selectedTagCellModel = selectedTagCellModel;
        _notSelectedTagCellModel = notSelectedTagCellModel;
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {

    _textLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
    _textLabel.backgroundColor = [UIColor clearColor];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_textLabel];
}

- (void)setModel:(LPTagModel *)model {
    _model = model;
    _textLabel.text = model.name;
    if (_model.isChoose) {
        _textLabel.font = _selectedTagCellModel.textFont;
        _textLabel.textColor = _selectedTagCellModel.textColor;
        _textLabel.layer.cornerRadius = _selectedTagCellModel.radius;
        _textLabel.layer.borderColor = _selectedTagCellModel.boardColor.CGColor;
        _textLabel.layer.borderWidth = _selectedTagCellModel.boardWidth;
        _textLabel.layer.backgroundColor = _selectedTagCellModel.backgroundColor.CGColor;
    } else {
        _textLabel.font = _notSelectedTagCellModel.textFont;
        _textLabel.textColor = _notSelectedTagCellModel.textColor;
        _textLabel.layer.cornerRadius = _notSelectedTagCellModel.radius;
        _textLabel.layer.borderColor = _notSelectedTagCellModel.boardColor.CGColor;
        _textLabel.layer.borderWidth = _notSelectedTagCellModel.boardWidth;
        _textLabel.layer.backgroundColor = _notSelectedTagCellModel.backgroundColor.CGColor;
    }    
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass(self);
}

@end
