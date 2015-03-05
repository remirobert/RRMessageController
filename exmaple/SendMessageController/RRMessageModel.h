//
//  MessageModel.h
//  SendMessageController
//
//  Created by Remi Robert on 18/11/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRMessageModel : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *photos;

@end
