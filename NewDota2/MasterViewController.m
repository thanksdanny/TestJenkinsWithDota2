//
//  MasterViewController.m
//  NewDota2
//
//  Created by Danny Ho on 5/16/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailTableViewController.h"
#import "HeroTableViewCell.h"
#import <UIImageView+WebCache.h>

#define kAPI_KEY @"87294A1C296C1FB71635BC8CA95F2028"

/*
 数据线存储到一个plist里，往后增强存储到数据库coredata中，往后扩展
 */


@interface MasterViewController ()
{
    // 取程序沙盒地址，生成实例，不需做属性，所以不用声明property
    NSString *docPath;
}

@property (nonatomic, strong) NSArray *heroList;
@property NSURLSession *session;
@property NSDictionary *herosDetail;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 生成一次session，避免重复生成
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // 沙盒地址,返回一个数组的第0个对象，也就是路径
    docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@", docPath);
    
    // 配置UI
    [self configureUI];
    
    // 获取数据
    [self setupDataSource];
    
}

#pragma mark - configure UI

- (void)configureUI {
    self.title = @"Dota 2 Heropedia";
    
}

# pragma mark - 获取网络数据

// 从api获取英雄列表数据
- (void)fetchHeroListData {
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=%@&language=zh_cn", kAPI_KEY]];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        self.heroList = json[@"result"][@"heroes"];
        
        // 存储到plist
        [self.heroList writeToFile:[docPath stringByAppendingPathComponent:@"ListData.plist"] atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{ // 强制在主线程执行
            [self.tableView reloadData]; // 取回来以后要reload一下data
        });
    }];
    
    [dataTask resume];

}

// 从api获取详情页数据
- (void)fetchHeroDetailData {
    NSURL *apiURL = [NSURL URLWithString:@"http://www.dota2.com/jsfeed/heropickerdata"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.herosDetail = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        // 存储到plist
        [self.herosDetail writeToFile:[docPath stringByAppendingPathComponent:@"DetailData.plist"] atomically:YES];
    }];
    
    [dataTask resume];
}

// 获取英雄的ability数据
- (void)fetchHeroAbilityData {
    NSURL *apiURL = [NSURL URLWithString:@"http://www.dota2.com/jsfeed/abilitydata"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (!data) {
//            NSLog(@"lol");
//        }
        NSDictionary *abilityData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil][@"abilityData"];
        // 上面这句代码与之前有些不同，结尾处添加个字段[@"abilitydata"]去获取对应数据
        
        // 存储到plist
        [abilityData writeToFile:[docPath stringByAppendingPathComponent:@"AbilityData.plist"] atomically:YES];
    }];
    
    [dataTask resume];
}


// 判断本地有没缓存，没有就网上读取
- (void)setupDataSource {
    // 判断 ListData
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:@"ListData.plist"]]) {
        NSLog(@"有ListData.plist");
        self.heroList = [NSArray arrayWithContentsOfFile:[docPath stringByAppendingPathComponent:@"ListData.plist"]];
    } else {
        [self fetchHeroListData];
    }
    
    // 判断 DetailData
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:@"DetailData.plist"]]) {
        NSLog(@"有DetailData.plist");
        self.herosDetail = [NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:@"DetailData.plist"]];
    } else {
        [self fetchHeroDetailData];
    }
    
    // 判断 AbilityData
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:@"AbilityData.plist"]]) {
        NSLog(@"有Ability嘅数据啊");
    } else {
        [self fetchHeroAbilityData];
    }
}

# pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TODETAIL"]) {
        DetailTableViewController *detailVC = [segue destinationViewController];
        
        NSString *selectedHero = [self.heroList[self.tableView.indexPathForSelectedRow.row][@"name"] stringByReplacingOccurrencesOfString:@"npc_dota_hero_" withString:@""];
        detailVC.heroName = selectedHero;//只需把名字转过去即可，不需把后面的那串json传过去 // self.herosDetail[selectedHero]; // 把json字典传给detailVC
        
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
