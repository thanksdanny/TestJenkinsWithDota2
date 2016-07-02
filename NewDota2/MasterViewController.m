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
    self.heroList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Heros" ofType:@"plist"]];
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
    
//    cell.iconImageView.image = [UIImage imageNamed:[self.heroList[indexPath.row][@"name"]stringByAppendingString:@"_hphover.png"]];
    cell.nameLabel.text = self.heroList[indexPath.row][@"name"];
    cell.typeLabel.text = self.heroList[indexPath.row][@"type"];
    
    return cell;
}

@end
