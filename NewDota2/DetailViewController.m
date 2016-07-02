//
//  DetailViewController.m
//  NewDota2
//
//  Created by Danny Ho on 5/17/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+WebCache.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
}

- (void)configureUI {
    self.textView.text = self.hero[@"bio"];
    [self.imageView sd_setImageWithURL:self.fullImageURL];
    self.title = self.hero[@"name"];
}



@end
