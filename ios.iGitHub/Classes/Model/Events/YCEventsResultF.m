//
//  YCEventsResultF.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/21.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/NSString+Category.h>

#import "YCEventsResultF.h"

#define kMargin 8
#define kMarginContent 5

@implementation YCEventsResultF

- (void)setEvents:(YCEventsResult *)events {
    _events = events;

    CGFloat cellWidth = YC_ScreenWidth;

    CGFloat typeY = kMargin;
    CGFloat typeWH = 17;

    CGFloat avatarX = kMargin;
    CGFloat avatarY = typeY + typeWH + kMargin;
    CGFloat avatarWH = 35;

    _typeF = CGRectMake(avatarX + avatarWH - typeWH, typeY, typeWH, typeWH);
    _avatarF = CGRectMake(avatarX, avatarY, avatarWH, avatarWH);

    CGFloat dateX = CGRectGetMaxX(_typeF) + kMargin;
    CGFloat dateY = typeY;
    CGFloat dateW = cellWidth - dateX - kMargin;
    CGFloat dateH = typeWH;
    _dateF = CGRectMake(dateX, dateY, dateW, dateH);

    NSString *content, *desc;
    switch (self.events.type) {
        case EventsTypeCommitCommentEvent: {
            content = [NSString stringWithFormat:@"%@ commented on commit %@ in %@", self.events.actor.login, [self.events.payload.comment.commit_id substringToIndex:6], self.events.repo.name];
            desc = self.events.payload.comment.body;
            break;
        }
        case EventsTypeCreateEvent: {
            if (self.events.payload.ref_type == RefTypeRepository) {
                content = [NSString stringWithFormat:@"%@ created repository %@", self.events.actor.login, self.events.repo.name];
            } else if (self.events.payload.ref_type == RefTypeBranch) {
                content = [NSString stringWithFormat:@"%@ created branch %@ in %@", self.events.actor.login, self.events.payload.ref, self.events.repo.name];
            } else if (self.events.payload.ref_type == RefTypeTag) {
                content = [NSString stringWithFormat:@"%@ created tag %@ in %@", self.events.actor.login, self.events.payload.ref, self.events.repo.name];
            }
            desc = nil;
            break;
        }
        case EventsTypeDeleteEvent: {
            NSString *refType;
            if (self.events.payload.ref_type == RefTypeBranch) {
                refType = @"branch";
            } else if (self.events.payload.ref_type == RefTypeTag) {
                refType = @"tag";
            }
            content = [NSString stringWithFormat:@"%@ deleted %@ %@ in %@", self.events.actor.login, refType, self.events.payload.ref, self.events.repo.name];
            desc = nil;
            break;
        }
        case EventsTypeForkEvent: {
            content = [NSString stringWithFormat:@"%@ forked %@ to %@", self.events.actor.login, self.events.repo.name, self.events.payload.forkee.full_name];
            desc = nil;
            break;
        }
        case EventsTypeIssueCommentEvent: {
            content = [NSString stringWithFormat:@"%@ commented on issue #%ld in %@", self.events.actor.login, self.events.payload.issue.number, self.events.repo.name];
            desc = self.events.payload.comment.body;
            break;
        }
        case EventsTypeIssuesEvent: {
            content = [NSString stringWithFormat:@"%@ %@ issue #%ld in %@", self.events.actor.login, self.events.payload.action, self.events.payload.issue.number, self.events.repo.name];
            desc = self.events.payload.issue.title;
            break;
        }
        case EventsTypePullRequestEvent: {
            content = [NSString stringWithFormat:@"%@ %@ pull request #%ld in %@", self.events.actor.login, self.events.payload.action, self.events.payload.pull_request.number, self.events.repo.name];
            desc = self.events.payload.pull_request.title;
            break;
        }
        case EventsTypePushEvent: {
            NSString *branch = [self.events.payload.ref substringFromIndex:@"refs/heads/".length];
            content = [NSString stringWithFormat:@"%@ pushed to %@ at %@", self.events.actor.login, branch, self.events.repo.name];
            NSArray *commits = self.events.payload.commits;
            NSUInteger count = commits.count;
            if (count) {
                NSMutableString *str = [NSMutableString string];
                for (int i = 0; i < count; i++) {
                    YCCommitResult *commitResult = commits[i];
                    [str appendFormat:@"%@ - %@", [commitResult.sha substringToIndex:6], commitResult.message];
                    if (i != count - 1) {
                        [str appendString:@"\n"];
                    }
                }
                desc = [str copy];
            } else {
                desc = nil;
            }
            break;
        }
        case EventsTypeWatchEvent: {
            content = [NSString stringWithFormat:@"%@ starred %@", self.events.actor.login, self.events.repo.name];
            desc = nil;
            break;
        }
    }

    CGFloat contentX = dateX;
    CGFloat contentY = CGRectGetMaxY(_dateF) + kMarginContent;
    CGFloat contentW = dateW;
    CGFloat contentH = [content sizeWithFont:kFontContent size:CGSizeMake(contentW, MAXFLOAT)].height + 2;
    _contentF = CGRectMake(contentX, contentY, contentW, contentH >= avatarWH ? contentH : avatarWH + kMargin);

    CGFloat descX = contentX;
    CGFloat descY = CGRectGetMaxY(_contentF) + kMarginContent;
    CGFloat descW = contentW;
    CGFloat descH = [desc sizeWithFont:kFontDesc size:CGSizeMake(descW, MAXFLOAT)].height;
    _descF = CGRectMake(descX, descY, descW, descH);

    _cellHeight = (desc ? CGRectGetMaxY(_descF) : CGRectGetMaxY(_contentF)) + kMargin;
}

@end
