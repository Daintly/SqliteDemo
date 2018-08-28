//
//  DBManager.h
//  sqliteDemo
//
//  Created by renwen on 2018/7/31.
//  Copyright © 2018年 renwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
@interface DBManager : NSObject

// 添加
-(NSMutableArray *)addTextdata:(DataModel*)model;
// 删除
-(NSMutableArray *)deleteTextdata:(DataModel*)model;
// 查询
-(NSMutableArray *)selectall;

@end
