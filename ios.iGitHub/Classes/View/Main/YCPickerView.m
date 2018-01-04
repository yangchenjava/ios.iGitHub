//
//  YCPickerView.m
//  ios.iGitHub
//
//  Created by yangc on 2018/1/2.
//  Copyright © 2018年 yangc. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "YCPickerView.h"

#define kPickerViewFrame CGRectMake(0, YC_ScreenHeight * 3 / 5 , YC_ScreenWidth, YC_ScreenHeight * 2 / 5)

@interface YCPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray<NSNumber *> *defaultSelectRows;
@property (nonatomic, weak) UIPickerView *pickerView;

@end

@implementation YCPickerView

- (instancetype)initWithDefaultSelectRows:(NSArray<NSNumber *> *)defaultSelectRows {
    if (self = [super initWithFrame:CGRectMake(0, YC_ScreenHeight, YC_ScreenWidth, YC_ScreenHeight)]) {
        self.defaultSelectRows = defaultSelectRows;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:kPickerViewFrame];
        view.backgroundColor = YC_Color_RGB(245, 245, 245);
        [self addSubview:view];
        
        UIView *toolBar = [[UIView alloc] init];
        toolBar.backgroundColor = YC_Color_RGB(220, 220, 220);
        [view addSubview:toolBar];
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done setTitleColor:YC_Color_RGB(18, 127, 247) forState:UIControlStateNormal];
        [done setTitleColor:YC_Color_RGB(204, 229, 253) forState:UIControlStateHighlighted];
        [done addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:done];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [view addSubview:pickerView];
        self.pickerView = pickerView;
        
        [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top);
            make.leading.mas_equalTo(view.mas_leading);
            make.trailing.mas_equalTo(view.mas_trailing);
            make.height.mas_equalTo(YC_CellDefaultHeight);
        }];
        
        [done mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(toolBar.mas_top);
            make.trailing.mas_equalTo(toolBar.mas_trailing);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(toolBar.mas_height);
        }];
        
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(toolBar.mas_bottom);
            make.leading.mas_equalTo(view.mas_leading);
            make.trailing.mas_equalTo(view.mas_trailing);
            make.bottom.mas_equalTo(view.mas_bottom).mas_offset(-YC_TabBarBottomSafeMargin);
        }];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = YC_ScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)setComponents:(NSArray<NSArray<NSString *> *> *)components {
    _components = components;
    [self.pickerView reloadAllComponents];
    if (self.defaultSelectRows.count) {
        for (NSInteger component = 0; component < self.defaultSelectRows.count; component++) {
            [self.pickerView selectRow:self.defaultSelectRows[component].integerValue inComponent:component animated:NO];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (!CGRectContainsPoint(kPickerViewFrame, [touches.anyObject locationInView:self])) {
        [self dismiss];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.components.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.components[component].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.components[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectComponent:row:title:)]) {
        [self.delegate pickerView:self didSelectComponent:component row:row title:self.components[component][row]];
    }
}

- (void)clickDone {
    if ([self.delegate respondsToSelector:@selector(pickerView:didClickDoneRows:titles:)]) {
        NSMutableArray <NSNumber *> *rows = [NSMutableArray arrayWithCapacity:self.components.count];
        NSMutableArray <NSString *> *titles = [NSMutableArray arrayWithCapacity:self.components.count];
        for (NSInteger component = 0; component < self.components.count; component++) {
            NSInteger row = [self.pickerView selectedRowInComponent:component];
            [rows addObject:@(row)];
            [titles addObject:self.components[component][row]];
        }
        [self.delegate pickerView:self didClickDoneRows:rows titles:titles];
    }
}

@end
