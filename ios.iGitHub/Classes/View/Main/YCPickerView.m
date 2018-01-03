//
//  YCPickerView.m
//  ios.iGitHub
//
//  Created by yangc on 2018/1/2.
//  Copyright © 2018年 yangc. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "YCPickerView.h"

@interface YCPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray<NSNumber *> *defaultSelectRows;
@property (nonatomic, weak) UIPickerView *pickerView;

@end

@implementation YCPickerView

- (instancetype)initWithFrame:(CGRect)frame defaultSelectRows:(NSArray<NSNumber *> *)defaultSelectRows {
    if (self = [super initWithFrame:frame]) {
        self.defaultSelectRows = defaultSelectRows;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *toolBar = [[UIView alloc] init];
        toolBar.backgroundColor = YC_Color_RGB(240, 240, 240);
        [self addSubview:toolBar];
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done setTitleColor:YC_Color_RGB(18, 127, 247) forState:UIControlStateNormal];
        [done setTitleColor:YC_Color_RGB(204, 229, 253) forState:UIControlStateHighlighted];
        [done addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:done];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [self addSubview:pickerView];
        self.pickerView = pickerView;
        
        [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(YC_CellDefaultHeight);
        }];
        
        [done mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(toolBar.mas_top);
            make.trailing.mas_equalTo(toolBar.mas_trailing);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(YC_CellDefaultHeight);
        }];
        
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(toolBar.mas_bottom);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-100);
        }];
    }
    return self;
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
