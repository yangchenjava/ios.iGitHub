//
//  YCNewsTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIImageView+SDWebImageCategory.h>
#import <YCHelpKit/UIView+Category.h>

#import "FontAwesomeKit.h"
#import "YCGitHubUtils.h"
#import "YCNewsTableViewCell.h"

#define kUsername @"kUsername"
#define kReposname @"kReposname"
#define kForkeeReposname @"kForkeeReposname"
#define kIssueNumber @"kIssueNumber"

@interface YCNewsTableViewCell () <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@end

@implementation YCNewsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCNewsTableViewCell";
    YCNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCNewsTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSeparatorInset:UIEdgeInsetsMake(0, self.dateLabel.x, 0, 0)];

    self.contentLabel.delegate = self;
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.contentLabel.linkAttributes = @{(NSString *) kCTForegroundColorAttributeName : (id) YC_COLOR(65, 132, 192).CGColor};
    self.contentLabel.activeLinkAttributes =
        @{(NSString *) kCTForegroundColorAttributeName : (id) YC_COLOR(65, 132, 192).CGColor, (NSString *) kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:kCTUnderlineStyleSingle]};
    self.contentLabel.numberOfLines = 0;
}

- (void)setNews:(YCNewsResult *)news {
    _news = news;

    NSString *identifier;
    switch (self.news.type) {
        case NewsTypeForkEvent: {
            identifier = @"octicon-repo-forked";
            NSString *content = [NSString stringWithFormat:@"%@ forked %@ to %@", self.news.actor.login, self.news.repo.name, self.news.payload.forkee.full_name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:self.news.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:self.news.repo.name]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kForkeeReposname] withRange:[content rangeOfString:self.news.payload.forkee.full_name]];
            break;
        }
        case NewsTypeIssuesEvent: {
            identifier = @"octicon-issue-opened";
            NSString *title = self.news.payload.issue.title;
            NSString *content =
                [NSString stringWithFormat:@"%@ %@ issue #%ld in %@\r\n%@", self.news.actor.login, self.news.payload.action, self.news.payload.issue.number, self.news.repo.name, title];
            [self.contentLabel setText:content
                afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange range = [[mutableAttributedString string] rangeOfString:title];
                    // 颜色
                    [mutableAttributedString addAttribute:(NSString *) kCTForegroundColorAttributeName value:(__bridge id)[UIColor darkGrayColor].CGColor range:range];
                    // 字体大小
                    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
                    return mutableAttributedString;
                }];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:self.news.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kIssueNumber] withRange:[content rangeOfString:[NSString stringWithFormat:@"#%ld", self.news.payload.issue.number]]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:self.news.repo.name]];
            break;
        }
        case NewsTypeWatchEvent: {
            identifier = @"octicon-star";
            NSString *content = [NSString stringWithFormat:@"%@ starred %@", self.news.actor.login, self.news.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:self.news.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:self.news.repo.name]];
            break;
        }
    }
    FAKOcticons *icon = [FAKOcticons iconWithIdentifier:identifier size:MIN(self.typeImageView.width, self.typeImageView.height) error:NULL];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.typeImageView.image = [icon imageWithSize:self.typeImageView.size];

    UIImage *image = [UIImage imageNamed:@"avatar"];
    [self.avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:self.news.actor.avatar_url] placeholderImage:[image imageWithCircle:image.size]];

    self.dateLabel.text = [YCGitHubUtils dateStringWithDate:self.news.created_at];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *URLString = url.absoluteString;
    if ([URLString isEqualToString:kUsername] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:)]) {
        [self.delegate tableViewCell:self didClickUsername:self.news.actor.login];
    } else if ([URLString isEqualToString:kReposname] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:reposname:)]) {
        NSString *fullName = self.news.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self didClickUsername:[fullName substringToIndex:index] reposname:[fullName substringFromIndex:index + 1]];
    } else if ([URLString isEqualToString:kForkeeReposname] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:forkeeReposname:)]) {
        NSString *fullName = self.news.payload.forkee.full_name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self didClickUsername:[fullName substringToIndex:index] forkeeReposname:[fullName substringFromIndex:index + 1]];
    } else if ([URLString isEqualToString:kIssueNumber] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:reposname:number:)]) {
        NSString *fullName = self.news.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self didClickUsername:[fullName substringToIndex:index] reposname:[fullName substringFromIndex:index + 1] number:self.news.payload.issue.number];
    }
}

@end
