//
//  PointReminderView.m
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/8/18.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import "PointReminderView.h"
#import "UIView+JWAdditions.h"
@implementation PointReminderModel


@end

@interface PointReminderView ()

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) PointReminderModel *model;
@end

@implementation PointReminderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor =
        [self addSubview:self.bgView];
        [self addSubview:self.mainLabel];
        [self addSubview:self.subLabel];
        [self addSubview:self.enterBtn];
        [self addSubview:self.closeBtn];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

}

- (void)setModel:(PointReminderModel *)model {
    _model = model;
    self.mainLabel.text = model.title;
    self.subLabel.text = model.subTitle;
    self.bgView.image = [UIImage imageNamed:model.type == PointReminderTypeNormal ?@"bgView" :@"bgView2"];
    CGRect frame = self.frame;
    self.bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.mainLabel.frame = CGRectMake(85, 20, 100, 20);
    [self.mainLabel sizeToFit];
    self.subLabel.frame = CGRectMake(CGRectGetMinX(self.mainLabel.frame), CGRectGetMaxY(self.mainLabel.frame) + 6, 100, 20);
    [self.subLabel sizeToFit];
    self.enterBtn.frame = CGRectMake(CGRectGetMaxX(self.mainLabel.frame) + 8, CGRectGetMidY(self.mainLabel.frame), 60, 20);
    [self.enterBtn sizeToFit];
    self.enterBtn.centerY = self.mainLabel.centerY;
    self.closeBtn.frame = CGRectMake(CGRectGetMaxX(frame) - 30, (frame.size.height - 15) / 2, 15, 15);
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
    }
    return _bgView;
}

- (UILabel *)mainLabel {
    if (!_mainLabel) {
        _mainLabel = [UILabel new];
        _mainLabel.font = [UIFont systemFontOfSize:12];
        _mainLabel.textColor = [UIColor whiteColor];
    }
    return _mainLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [UILabel new];
        _subLabel.font = [UIFont systemFontOfSize:12];
        _subLabel.textColor = [UIColor whiteColor];
    }
    return _subLabel;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"点击进入"];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, attrStr.length)];
        [_enterBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    }
    return _enterBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

@end
