//
//  DetailViewController.h
//  NewDota2
//
//  Created by Danny Ho on 5/17/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property NSDictionary *hero;
@property NSURL *fullImageURL; // 暴露出url，然后再拼接成地址下载大图

@end
