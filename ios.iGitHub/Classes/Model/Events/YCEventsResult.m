//
//  YCEventsResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCEventsResult.h"
#import "YCGitHubUtils.h"

@implementation YCEventsResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id", @"pbc" : @"public" };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"type"]) {
        static NSDictionary *eventType;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            eventType = @{
                @"CommitCommentEvent" : @(EventsTypeCommitCommentEvent),
                @"CreateEvent" : @(EventsTypeCreateEvent),
                @"DeleteEvent" : @(EventsTypeDeleteEvent),
                @"ForkEvent" : @(EventsTypeForkEvent),
                @"IssueCommentEvent" : @(EventsTypeIssueCommentEvent),
                @"IssuesEvent" : @(EventsTypeIssuesEvent),
                @"PullRequestEvent" : @(EventsTypePullRequestEvent),
                @"PushEvent" : @(EventsTypePushEvent),
                @"WatchEvent" : @(EventsTypeWatchEvent)
            };
        });
        return eventType[oldValue];
    } else if (property.type.class == [NSDate class]) {
        return [YCGitHubUtils.dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}

@end
