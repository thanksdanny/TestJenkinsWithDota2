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

#define kAPI_KEY @"87294A1C296C1FB71635BC8CA95F2028"
//http://www.dota2/jsfeed/he

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *heroList;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
}

#pragma mark - configure UI

- (void)configureUI {
    self.title = @"Dota 2 Heropedia";
    
    
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=%@&language=zh_cn", kAPI_KEY]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@", json[@"result"][@"heroes"]);
        self.heroList = json[@"result"][@"heroes"];
        
        dispatch_async(dispatch_get_main_queue(), ^{ // 强制在主线程执行
            [self.tableView reloadData]; // 取回来以后要reload一下data
        });
    }];
    
    [dataTask resume];
}


# pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TODETAIL"]) {
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.hero = self.heroList[self.tableView.indexPathForSelectedRow.row];
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
    
    cell.nameLabel.text = self.heroList[indexPath.row][@"localized_name"];
    cell.typeLabel.text = self.heroList[indexPath.row][@"type"];
    
    return cell;
}

@end
