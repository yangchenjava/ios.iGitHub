//
//  YCPickerView.h
//  ios.iGitHub
//
//  Created by yangc on 2018/1/2.
//  Copyright © 2018年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCPickerView;

@protocol YCPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(YCPickerView *)pickerView didSelectComponent:(NSInteger)component row:(NSInteger)row title:(NSString *)title;
- (void)pickerView:(YCPickerView *)pickerView didClickDoneRows:(NSArray <NSNumber *> *)rows titles:(NSArray <NSString *> *)titles;

@end

@interface YCPickerView : UIView

@property (nonatomic, weak) id<YCPickerViewDelegate> delegate;
@property (nonatomic, strong) NSArray <NSArray <NSString *> *> *components;

- (instancetype)initWithFrame:(CGRect)frame defaultSelectRows:(NSArray <NSNumber *> *)defaultSelectRows;

@end
