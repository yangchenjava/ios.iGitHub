//
//  YCReposDetailTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/15.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <DateTools/DateTools.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <YCHelpKit/NSString+Category.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCProfileResult.h"
#import "YCReposBiz.h"
#import "YCReposDetailTableViewCell.h"
#import "YCReposResult.h"

@interface YCReposDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *stargazersLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchersLabel;
@property (weak, nonatomic) IBOutlet UILabel *forksLabel;
@property (weak, nonatomic) IBOutlet UIImageView *publicImageView;
@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UIImageView *languageImageView;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *issueImageView;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *branchImageView;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sizeImageView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation YCReposDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCReposDetailTableViewCell";
    YCReposDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCReposDetailTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setRepos:(YCReposResult *)repos {
    _repos = repos;

    self.stargazersLabel.text = [NSString stringWithFormat:@"%ld", self.repos.stargazers_count];
    self.watchersLabel.text = [NSString stringWithFormat:@"%ld", self.repos.watchers_count];
    self.forksLabel.text = [NSString stringWithFormat:@"%ld", self.repos.forks_count];

    // Public
    FAKOcticons *lockIcon = [FAKOcticons lockIconWithSize:MIN(self.publicImageView.width, self.publicImageView.height)];
    [lockIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.publicImageView.image = [lockIcon imageWithSize:self.publicImageView.size];

    self.publicLabel.text = self.repos.pvt ? @"Private" : @"Public";

    // Language
    FAKOcticons *packageIcon = [FAKOcticons packageIconWithSize:MIN(self.languageImageView.width, self.languageImageView.height)];
    [packageIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.languageImageView.image = [packageIcon imageWithSize:self.languageImageView.size];

    self.languageLabel.text = self.repos.language ? self.repos.language : @"N/A";

    // Issue
    FAKOcticons *issueOpenedIcon = [FAKOcticons issueOpenedIconWithSize:MIN(self.issueImageView.width, self.issueImageView.height)];
    [issueOpenedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.issueImageView.image = [issueOpenedIcon imageWithSize:self.issueImageView.size];

    self.issueLabel.text = [NSString stringWithFormat:@"%ld Issues", self.repos.open_issues_count];

    // Branch
    FAKOcticons *gitBranchIcon = [FAKOcticons gitBranchIconWithSize:MIN(self.branchImageView.width, self.branchImageView.height)];
    [gitBranchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.branchImageView.image = [gitBranchIcon imageWithSize:self.branchImageView.size];

    [YCReposBiz reposBranchOrTagWithUsername:self.repos.owner.login
        reposname:self.repos.name
        state:nil
        page:1
        success:^(NSArray *results) {
            self.branchLabel.text = [NSString stringWithFormat:@"%ld Branches", results.count];
        }
        failure:^(NSError *error) {
            YCLog(@"%@", error.localizedDescription);
        }];

    // Date
    FAKOcticons *calendarIcon = [FAKOcticons calendarIconWithSize:MIN(self.dateImageView.width, self.dateImageView.height)];
    [calendarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.dateImageView.image = [calendarIcon imageWithSize:self.dateImageView.size];

    self.dateLabel.text = [self.repos.created_at formattedDateWithFormat:@"MM/dd/yy"];

    // Size
    FAKOcticons *toolsIcon = [FAKOcticons toolsIconWithSize:MIN(self.sizeImageView.width, self.sizeImageView.height)];
    [toolsIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.sizeImageView.image = [toolsIcon imageWithSize:self.sizeImageView.size];

    self.sizeLabel.text = [NSString fileSizeUnit:self.repos.size * 1000];
}

@end
