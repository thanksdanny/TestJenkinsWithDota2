//
//  MasterViewController.m
//  NewDota2
//
//  Created by Danny Ho on 5/16/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *heroList;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heroList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Heros" ofType:@"plist"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.heroList[indexPath.row][@"name"];
    
    return cell;
}

@end
