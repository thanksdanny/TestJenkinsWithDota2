//
//  DetailViewController.m
//  NewDota2
//
//  Created by Danny Ho on 5/17/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.clipsToBounds = YES;
    self.imageView.image = [UIImage imageNamed:[[self.hero[@"name"]lowercaseString]stringByAppendingString:@"_full.png"]];
    self.textView.text = self.hero[@"bio"];
    self.title = self.hero[@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
