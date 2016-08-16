//
//  YCEventsTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>

#import "FontAwesomeKit.h"
#import "UIImage+Category.h"
#import "UIImageView+SDWebImageCategory.h"
#import "UIView+Category.h"
#import "YCEventsTableViewCell.h"
#import "YCGitHubUtils.h"

#define kUsername @"kUsername"
#define kReposname @"kReposname"
#define kForkeeReposname @"kForkeeReposname"
#define kIssueNumber @"kIssueNumber"
#define kPullRequestNumber @"kPullRequestNumber"
#define kBranch @"kBranch"
#define kSha @"kSha"

@interface YCEventsTableViewCell () <TTTAttributedLabelDelegate>

@property (nonatomic, weak) UIImageView *typeImageView;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) TTTAttributedLabel *contentLabel;
@property (nonatomic, weak) TTTAttributedLabel *descLabel;

@end

@implementation YCEventsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCEventsTableViewCell";
    YCEventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YCEventsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *typeImageView = [[UIImageView alloc] init];
        [self addSubview:typeImageView];
        self.typeImageView = typeImageView;

        UIImageView *avatarImageView = [[UIImageView alloc] init];
        [self addSubview:avatarImageView];
        self.avatarImageView = avatarImageView;

        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.font = kFontDate;
        [self addSubview:dateLabel];
        self.dateLabel = dateLabel;

        NSDictionary *linkAttributes = @{(NSString *) kCTForegroundColorAttributeName : (id) YC_COLOR(65, 132, 192).CGColor};
        NSDictionary *activeLinkAttributes =
            @{(NSString *) kCTForegroundColorAttributeName : (id) YC_COLOR(65, 132, 192).CGColor, (NSString *) kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:kCTUnderlineStyleSingle]};

        TTTAttributedLabel *contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = kFontContent;
        contentLabel.numberOfLines = 0;
        contentLabel.delegate = self;
        contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        contentLabel.linkAttributes = linkAttributes;
        contentLabel.activeLinkAttributes = activeLinkAttributes;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;

        TTTAttributedLabel *descLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        descLabel.textColor = [UIColor darkGrayColor];
        descLabel.font = kFontDesc;
        descLabel.numberOfLines = 0;
        descLabel.delegate = self;
        descLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        descLabel.linkAttributes = linkAttributes;
        descLabel.activeLinkAttributes = activeLinkAttributes;
        [self addSubview:descLabel];
        self.descLabel = descLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsMake(0, self.dateLabel.x, 0, 0);
}

- (void)setEventsF:(YCEventsResultF *)eventsF {
    _eventsF = eventsF;

    YCEventsResult *events = self.eventsF.events;

    NSString *identifier;
    self.contentLabel.frame = self.eventsF.contentF;
    self.descLabel.frame = self.eventsF.descF;
    switch (events.type) {
        case EventsTypeCommitCommentEvent: {
            identifier = @"octicon-comment";
            NSString *sha = [events.payload.comment.commit_id substringToIndex:6];
            NSString *content = [NSString stringWithFormat:@"%@ commented on commit %@ in %@", events.actor.login, sha, events.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kSha] withRange:[content rangeOfString:sha]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            self.descLabel.hidden = NO;
            self.descLabel.text = events.payload.comment.body;
            break;
        }
        case EventsTypeCreateEvent: {
            if (events.payload.ref_type == RefTypeRepository) {
                identifier = @"octicon-repo";
                NSString *content = [NSString stringWithFormat:@"%@ created repository %@", events.actor.login, events.repo.name];
                self.contentLabel.text = content;
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];
            } else if (events.payload.ref_type == RefTypeBranch) {
                identifier = @"octicon-git-branch";
                NSString *content = [NSString stringWithFormat:@"%@ created branch %@ in %@", events.actor.login, events.payload.ref, events.repo.name];
                self.contentLabel.text = content;
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kBranch] withRange:[content rangeOfString:events.payload.ref]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];
            }

            self.descLabel.hidden = YES;
            self.descLabel.text = nil;
            break;
        }
        case EventsTypeDeleteEvent: {
            identifier = @"octicon-trashcan";
            NSString *refType;
            if (events.payload.ref_type == RefTypeBranch) {
                refType = @"branch";
            } else if (events.payload.ref_type == RefTypeTag) {
                refType = @"tag";
            }
            NSString *content = [NSString stringWithFormat:@"%@ deleted %@ %@ in %@", events.actor.login, refType, events.payload.ref, events.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kBranch] withRange:[content rangeOfString:events.payload.ref]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            self.descLabel.hidden = YES;
            self.descLabel.text = nil;
            break;
        }
        case EventsTypeForkEvent: {
            identifier = @"octicon-repo-forked";
            NSString *content = [NSString stringWithFormat:@"%@ forked %@ to %@", events.actor.login, events.repo.name, events.payload.forkee.full_name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kForkeeReposname] withRange:[content rangeOfString:events.payload.forkee.full_name]];

            self.descLabel.hidden = YES;
            self.descLabel.text = nil;
            break;
        }
        case EventsTypeIssueCommentEvent: {
            identifier = @"octicon-comment";
            NSString *content = [NSString stringWithFormat:@"%@ commented on issue #%ld in %@", events.actor.login, events.payload.issue.number, events.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kIssueNumber] withRange:[content rangeOfString:[NSString stringWithFormat:@"#%ld", events.payload.issue.number]]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            self.descLabel.hidden = NO;
            self.descLabel.text = events.payload.comment.body;
            break;
        }
        case EventsTypeIssuesEvent: {
            identifier = @"octicon-issue-opened";
            NSString *content = [NSString stringWithFormat:@"%@ %@ issue #%ld in %@", events.actor.login, events.payload.action, events.payload.issue.number, events.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kIssueNumber] withRange:[content rangeOfString:[NSString stringWithFormat:@"#%ld", events.payload.issue.number]]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            self.descLabel.hidden = NO;
            self.descLabel.text = events.payload.issue.title;
            break;
        }
        case EventsTypePullRequestEvent: {
            identifier = @"octicon-git-pull-request";
            NSString *content = [NSString stringWithFormat:@"%@ %@ pull request #%ld in %@", events.actor.login, events.payload.action, events.payload.pull_request.number, events.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kPullRequestNumber] withRange:[content rangeOfString:[NSString stringWithFormat:@"#%ld", events.payload.pull_request.number]]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            self.descLabel.hidden = NO;
            self.descLabel.text = events.payload.pull_request.title;
            break;
        }
        case EventsTypePushEvent: {
            identifier = @"octicon-git-commit";
            NSString *branch = [events.payload.ref substringFromIndex:@"refs/heads/".length];
            NSString *content = [NSString stringWithFormat:@"%@ pushed to %@ at %@", events.actor.login, branch, events.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kBranch] withRange:[content rangeOfString:branch]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            if (events.payload.commits.count) {
                self.descLabel.hidden = NO;
                NSString *sha = [events.payload.head substringToIndex:6];
                NSString *desc = [NSString stringWithFormat:@"%@ - %@", sha, [events.payload.commits[0] message]];
                self.descLabel.text = desc;
                [self.descLabel addLinkToURL:[NSURL URLWithString:kSha] withRange:[desc rangeOfString:sha]];
            } else {
                self.descLabel.hidden = YES;
                self.descLabel.text = nil;
            }
            break;
        }
        case EventsTypeWatchEvent: {
            identifier = @"octicon-star";
            NSString *content = [NSString stringWithFormat:@"%@ starred %@", events.actor.login, events.repo.name];
            self.contentLabel.text = content;
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            self.descLabel.hidden = YES;
            self.descLabel.text = nil;
            break;
        }
    }
    self.typeImageView.frame = self.eventsF.typeF;
    FAKOcticons *icon = [FAKOcticons iconWithIdentifier:identifier size:MIN(self.typeImageView.width, self.typeImageView.height) error:NULL];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.typeImageView.image = [icon imageWithSize:self.typeImageView.size];

    self.avatarImageView.frame = self.eventsF.avatarF;
    UIImage *image = [UIImage imageNamed:@"avatar"];
    [self.avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:events.actor.avatar_url] placeholderImage:[image imageWithCircle:image.size]];

    self.dateLabel.frame = self.eventsF.dateF;
    self.dateLabel.text = [YCGitHubUtils dateStringWithDate:events.created_at];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *URLString = url.absoluteString;
    if ([URLString isEqualToString:kUsername] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:)]) {
        [self.delegate tableViewCell:self didClickUsername:self.eventsF.events.actor.login];
    } else if ([URLString isEqualToString:kReposname] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:reposname:)]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self didClickUsername:[fullName substringToIndex:index] reposname:[fullName substringFromIndex:index + 1]];
    } else if ([URLString isEqualToString:kForkeeReposname] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:forkeeReposname:)]) {
        NSString *fullName = self.eventsF.events.payload.forkee.full_name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self didClickUsername:[fullName substringToIndex:index] forkeeReposname:[fullName substringFromIndex:index + 1]];
    } else if ([URLString isEqualToString:kIssueNumber] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:reposname:issueNumber:)]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self didClickUsername:[fullName substringToIndex:index] reposname:[fullName substringFromIndex:index + 1] issueNumber:self.eventsF.events.payload.issue.number];
    } else if ([URLString isEqualToString:kPullRequestNumber] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:reposname:pullRequestNumber:)]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self
                    didClickUsername:[fullName substringToIndex:index]
                           reposname:[fullName substringFromIndex:index + 1]
                   pullRequestNumber:self.eventsF.events.payload.pull_request.number];
    } else if ([URLString isEqualToString:kBranch] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:reposname:branch:)]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self
                    didClickUsername:[fullName substringToIndex:index]
                           reposname:[fullName substringFromIndex:index + 1]
                              branch:[self.eventsF.events.payload.ref substringFromIndex:@"refs/heads/".length]];
    } else if ([URLString isEqualToString:kSha] && [self.delegate respondsToSelector:@selector(tableViewCell:didClickUsername:reposname:sha:)]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;
        [self.delegate tableViewCell:self didClickUsername:[fullName substringToIndex:index] reposname:[fullName substringFromIndex:index + 1] sha:self.eventsF.events.payload.head];
    }
}

@end
