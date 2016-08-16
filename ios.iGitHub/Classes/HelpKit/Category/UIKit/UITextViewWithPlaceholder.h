//
//  UITextViewWithPlaceholder.h
//  ios_utils
//
//  Created by yangc on 16-5-3.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextViewWithPlaceholder : UITextView

@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;

@end
