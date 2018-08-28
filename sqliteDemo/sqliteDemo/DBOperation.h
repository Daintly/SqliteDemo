//
//  DBOperation.h
//  sqliteDemo
//
//  Created by renwen on 2018/7/31.
//  Copyright © 2018年 renwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import <sqlite3.h>
@interface DBOperation : NSObject{
    sqlite3 *dataBase;
}
+ (DBOperation *)dataBaseManager;
- (NSString *)Documentsfillpath;
//创建数据库
- (BOOL)createDataBaseTable;
//删除数据库
-(BOOL)dropBaseTable;
//添加
- (int)addData:(DataModel *)model;

// 删除 根据useid删除数据
- (int)deleteData:(DataModel *)model;
// 更新 根据userid更新数据
- (int)editData:(DataModel *)model;
//查询所有
- (NSMutableArray *)selectall;
//根据userid查询数据
- (DataModel *)getdbdataByuserid:(NSString *)userid;

@end
