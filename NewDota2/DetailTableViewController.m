//
//  DetailTableViewController.m
//  NewDota2
//
//  Created by Danny Ho on 7/2/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "DetailTableViewController.h"
#import "AbilityCell.h"
#import "BioCell.h"
#import <UIImageView+WebCache.h>

@interface DetailTableViewController ()
{
    NSString *docPath; // 沙盒
}

@property NSString *heroBio;
@property NSURL *heroFullImageURL;
@property NSMutableDictionary *abilityList; // 取技能
@property (weak, nonatomic) IBOutlet UIImageView *heroFullImageView;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureUI];    
}

# pragma mark - 配置UI

- (void)configureUI {
    docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    // 取大图
    self.heroFullImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_vert.jpg", self.heroName]];
    [self.heroFullImageView sd_setImageWithURL:self.heroFullImageURL];
    
    // 取bio
    self.heroBio = [NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:@"DetailData.plist"]][self.heroName][@"bio"];
    
    // 取ability
    NSDictionary *allAbility = [NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:@"AbilityData.plist"]];
    
    // 因为技能是以（英雄名字_技能名）json格式做拼接，所以遍历出技能
    self.abilityList = [NSMutableDictionary dictionary];
    for (NSString *name in allAbility) {
        if ([name hasPrefix:[self.heroName stringByAppendingString:@"_"]]) { // 有这个前缀，就跳进去
            [self.abilityList setObject:allAbility[name] forKey:name];
        }
    }
    NSLog(@"%@", self.abilityList);
    
    // 调整bio cell 的高度
    self.tableView.estimatedRowHeight = 100; // 预估的行高
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 自动去判定行高
}

# pragma mark - tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Ability";
    } else {
        return @"Bio";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.abilityList.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AbilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AbilityCell" forIndexPath:indexPath];
        cell.abilityNameLabel.text = self.abilityList[[self.abilityList allKeys][indexPath.row]][@"dname"];
        cell.abilityDetailLabel.text = self.abilityList[[self.abilityList allKeys][indexPath.row]][@"desc"];
        cell.abilityDetailLabel.numberOfLines = 0; // 0就全部显示
        // 图片
        NSURL *abilityImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/abilities/%@_hp1.png", [self.abilityList allKeys][indexPath.row]]];
        [cell.abilityImageView sd_setImageWithURL:abilityImageURL];
        
        return cell;
    } else {
        BioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BioCell" forIndexPath:indexPath];
        cell.textLabel.text = self.heroBio;
        cell.textLabel.numberOfLines = 0; // 0就全部显示
        return cell;
    }
}

@end
