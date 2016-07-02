//
//  AbilityCell.h
//  NewDota2
//
//  Created by Danny Ho on 7/2/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbilityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *abilityImageView;
@property (weak, nonatomic) IBOutlet UILabel *abilityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *abilityDetailLabel;
@end
