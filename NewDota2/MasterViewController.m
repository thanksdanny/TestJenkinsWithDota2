//
//  MasterViewController.m
//  NewDota2
//
//  Created by Danny Ho on 5/16/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "HeroTableViewCell.h"
#import <UIImageView+WebCache.h>

#define kAPI_KEY @"87294A1C296C1FB71635BC8CA95F2028"
//http://www.dota2/jsfeed/he

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *heroList;
@property NSURLSession *session;
@property NSDictionary *herosDetail;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; // 生成一次，全部都用到
    [self configureUI];
    [self fetchHeroList];
    [self fetchHeroDetailInfo];
}

#pragma mark - configure UI

- (void)configureUI {
    self.title = @"Dota 2 Heropedia";
    
}

# pragma mark - fetch api

- (void)fetchHeroList {
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=%@&language=zh_cn", kAPI_KEY]];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        self.heroList = json[@"result"][@"heroes"];
        
        dispatch_async(dispatch_get_main_queue(), ^{ // 强制在主线程执行
            [self.tableView reloadData]; // 取回来以后要reload一下data
        });
    }];
    
    [dataTask resume];

}

- (void)fetchHeroDetailInfo {
    NSURL *apiURL = [NSURL URLWithString:@"http://www.dota2.com/jsfeed/heropickerdata"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.herosDetail = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }];
    
    [dataTask resume];
}


# pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TODETAIL"]) {
        DetailViewController *detailVC = [segue destinationViewController];
        NSString *selectedHero = [self.heroList[self.tableView.indexPathForSelectedRow.row][@"name"] stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""];
        detailVC.hero = self.herosDetail[selectedHero]; // 把json字典传给detailVC
        
        NSString *urlString = [NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_vert.jpg", [self.heroList[self.tableView.indexPathForSelectedRow.row][@"name"] stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""]];
        detailVC.fullImageURL = [NSURL URLWithString:urlString]; // 把url传过去
    }
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.heroList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_full.png", [self.heroList[indexPath.row][@"name"] stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""]]; // stringByReplacingOccurrencesOfString 去掉字段中的npc_dota_hero_ 然后拼接字符串
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
   
    
    cell.nameLabel.text = self.heroList[indexPath.row][@"localized_name"];
    
    // [self.heroList[indexPath.row][@"name"] stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""];
    // 上面这段是取的英雄的名字，然后再提取里面的英雄的攻击类型，如下：
    cell.typeLabel.text = self.herosDetail[[self.heroList[indexPath.row][@"name"] stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""]][@"atk_l"];
    
    return cell;
}

@end
