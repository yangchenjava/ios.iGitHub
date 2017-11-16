//
//  YCEventsTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <FontAwesomeKit/FontAwesomeKit.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIImageView+SDWebImageCategory.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCBranchTableViewController.h"
#import "YCCommentResult.h"
#import "YCCommitDetailTableViewController.h"
#import "YCCommitResult.h"
#import "YCCommitTableViewController.h"
#import "YCEventsResult.h"
#import "YCEventsResultF.h"
#import "YCEventsTableViewCell.h"
#import "YCGitHubUtils.h"
#import "YCIssuesDetailTableViewController.h"
#import "YCIssuesResult.h"
#import "YCPayloadResult.h"
#import "YCProfileResult.h"
#import "YCProfileTableViewController.h"
#import "YCPullDetailTableViewController.h"
#import "YCReposDetailTableViewController.h"
#import "YCReposResult.h"

#define kUsername @"kUsername"
#define kReposname @"kReposname"
#define kForkeeReposname @"kForkeeReposname"
#define kIssueNumber @"kIssueNumber"
#define kPullRequestNumber @"kPullRequestNumber"
#define kCommit @"kCommit"
#define kBranch @"kBranch"
#define kTag @"kTag"
#define kComment @"kComment"
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

        NSDictionary *linkAttributes = @{(NSString *) kCTForegroundColorAttributeName : (id) YC_Color_RGB(65, 132, 192).CGColor};
        NSDictionary *activeLinkAttributes =
            @{(NSString *) kCTForegroundColorAttributeName : (id) YC_Color_RGB(65, 132, 192).CGColor, (NSString *) kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:kCTUnderlineStyleSingle]};

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
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kComment] withRange:[content rangeOfString:sha]];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

            self.descLabel.hidden = NO;
            self.descLabel.text = events.payload.comment.body;

            events.attrURL = [NSURL URLWithString:kComment];
            break;
        }
        case EventsTypeCreateEvent: {
            if (events.payload.ref_type == RefTypeRepository) {
                identifier = @"octicon-repo";
                NSString *content = [NSString stringWithFormat:@"%@ created repository %@", events.actor.login, events.repo.name];
                self.contentLabel.text = content;
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

                events.attrURL = [NSURL URLWithString:kReposname];
            } else if (events.payload.ref_type == RefTypeBranch) {
                identifier = @"octicon-git-branch";
                NSString *content = [NSString stringWithFormat:@"%@ created branch %@ in %@", events.actor.login, events.payload.ref, events.repo.name];
                self.contentLabel.text = content;
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kBranch] withRange:[content rangeOfString:events.payload.ref]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

                events.attrURL = [NSURL URLWithString:kBranch];
            } else if (events.payload.ref_type == RefTypeTag) {
                identifier = @"octicon-tag";
                NSString *content = [NSString stringWithFormat:@"%@ created tag %@ in %@", events.actor.login, events.payload.ref, events.repo.name];
                self.contentLabel.text = content;
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kTag] withRange:[content rangeOfString:events.payload.ref]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

                events.attrURL = [NSURL URLWithString:kTag];
            }

            self.descLabel.hidden = YES;
            self.descLabel.text = nil;
            break;
        }
        case EventsTypeDeleteEvent: {
            identifier = @"octicon-trashcan";
            if (events.payload.ref_type == RefTypeBranch) {
                NSString *content = [NSString stringWithFormat:@"%@ deleted branch %@ in %@", events.actor.login, events.payload.ref, events.repo.name];
                self.contentLabel.text = content;
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kBranch] withRange:[content rangeOfString:events.payload.ref]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

                events.attrURL = [NSURL URLWithString:kBranch];
            } else if (events.payload.ref_type == RefTypeTag) {
                NSString *content = [NSString stringWithFormat:@"%@ deleted tag %@ in %@", events.actor.login, events.payload.ref, events.repo.name];
                self.contentLabel.text = content;
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kUsername] withRange:[content rangeOfString:events.actor.login]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kTag] withRange:[content rangeOfString:events.payload.ref]];
                [self.contentLabel addLinkToURL:[NSURL URLWithString:kReposname] withRange:[content rangeOfString:events.repo.name]];

                events.attrURL = [NSURL URLWithString:kTag];
            }

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

            events.attrURL = [NSURL URLWithString:kForkeeReposname];
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

            events.attrURL = [NSURL URLWithString:kIssueNumber];
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

            events.attrURL = [NSURL URLWithString:kIssueNumber];
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

            events.attrURL = [NSURL URLWithString:kPullRequestNumber];
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

            NSArray *commits = events.payload.commits;
            NSUInteger count = commits.count;
            if (count) {
                self.descLabel.hidden = NO;

                NSMutableString *str = [NSMutableString string];
                for (int i = 0; i < count; i++) {
                    YCCommitResult *commitResult = commits[i];
                    [str appendFormat:@"%@ - %@", [commitResult.sha substringToIndex:6], commitResult.message];
                    if (i != count - 1) {
                        [str appendString:@"\n"];
                    }
                }
                NSString *desc = [str copy];
                self.descLabel.text = desc;

                for (int i = 0; i < count; i++) {
                    NSString *sha = [commits[i] sha];
                    [self.descLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kSha, sha]] withRange:[desc rangeOfString:[sha substringToIndex:6]]];
                }
            } else {
                self.descLabel.hidden = YES;
                self.descLabel.text = nil;
            }

            events.attrURL = [NSURL URLWithString:kCommit];
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

            events.attrURL = [NSURL URLWithString:kReposname];
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
    if ([URLString isEqualToString:kUsername]) {
        YCProfileTableViewController *vc = [[YCProfileTableViewController alloc] init];
        vc.username = self.eventsF.events.actor.login;
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kReposname]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kForkeeReposname]) {
        NSString *fullName = self.eventsF.events.payload.forkee.full_name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kIssueNumber]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCIssuesDetailTableViewController *vc = [[YCIssuesDetailTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        vc.number = self.eventsF.events.payload.issue.number;
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kPullRequestNumber]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCPullDetailTableViewController *vc = [[YCPullDetailTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        vc.number = self.eventsF.events.payload.pull_request.number;
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kCommit]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCCommitTableViewController *vc = [[YCCommitTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kBranch]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCBranchTableViewController *vc = [[YCBranchTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        vc.state = @"branches";
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kTag]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCBranchTableViewController *vc = [[YCBranchTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        vc.state = @"tags";
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString isEqualToString:kComment]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCCommitDetailTableViewController *vc = [[YCCommitDetailTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        vc.sha = self.eventsF.events.payload.comment.commit_id;
        [YCGitHubUtils pushViewController:vc];
    } else if ([URLString hasPrefix:kSha]) {
        NSString *fullName = self.eventsF.events.repo.name;
        NSUInteger index = [fullName rangeOfString:@"/"].location;

        YCCommitDetailTableViewController *vc = [[YCCommitDetailTableViewController alloc] init];
        vc.username = [fullName substringToIndex:index];
        vc.reposname = [fullName substringFromIndex:index + 1];
        vc.sha = [URLString substringFromIndex:kSha.length];
        [YCGitHubUtils pushViewController:vc];
    }
}

@end
