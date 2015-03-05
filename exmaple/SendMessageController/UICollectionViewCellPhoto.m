//
//  UICollectionViewCellPhoto.m
//  SendMessageController
//
//  Created by Remi Robert on 17/11/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import "UICollectionViewCellPhoto.h"

@implementation UICollectionViewCellPhoto

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.photo = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.photo];
    return (self);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.photo.image = nil;
    self.photo.frame = self.contentView.bounds;
}

@end
