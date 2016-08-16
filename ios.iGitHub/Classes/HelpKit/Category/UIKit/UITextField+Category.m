//
//  UITextField+Category.m
//  ios_utils
//
//  Created by yangc on 16-3-31.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "UIImage+Category.h"
#import "UITextField+Category.h"

@implementation UITextField (Category)

+ (instancetype)textFieldForSearchBarWithFrame:(CGRect)frame icon:(NSString *)icon placeholder:(NSString *)placeholder {
    UITextField *searchBar = [[UITextField alloc] initWithFrame:frame];
    searchBar.font = [UIFont systemFontOfSize:15];
    searchBar.background = [UIImage imageNamedForResize:@"search_navigationbar_textfield_background"];
    searchBar.placeholder = placeholder;
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchBar.enablesReturnKeyAutomatically = YES;
    searchBar.returnKeyType = UIReturnKeySearch;
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    leftView.frame = CGRectMake(0, 0, frame.size.height + 10, frame.size.height - 10);
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    searchBar.leftView = leftView;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    return searchBar;
}

@end
