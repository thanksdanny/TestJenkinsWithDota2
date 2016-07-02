//
//  HeroTableViewCell.m
//  NewDota2
//
//  Created by Danny Ho on 6/24/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "HeroTableViewCell.h"

@implementation HeroTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self p_drawSubviews];
    }
    
    return self;
}

- (void)p_drawSubviews {
    self.iconImageView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.typeLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    
    
}


@end
