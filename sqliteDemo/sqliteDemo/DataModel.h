//
//  DataModel.h
//  sqliteDemo
//
//  Created by renwen on 2018/7/31.
//  Copyright © 2018年 renwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) int minindex;

@property (nonatomic, assign) int isNumber;

@end
