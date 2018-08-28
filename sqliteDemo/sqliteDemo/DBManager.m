//
//  DBManager.m
//  sqliteDemo
//
//  Created by renwen on 2018/7/31.
//  Copyright © 2018年 renwen. All rights reserved.
//

#import "DBManager.h"
#import "DBOperation.h"
@implementation DBManager

// 这个类是用来作为媒介，可用可不用，只是为了让过程更加清晰

// 添加
-(NSMutableArray *)addTextdata:(DataModel *)model
{
    DBOperation * m = [DBOperation dataBaseManager];
    [m addData:model];
    return [m selectall];
}
// 删除
-(NSMutableArray *)deleteTextdata:(DataModel *)model
{
    DBOperation * m = [DBOperation dataBaseManager];
    [m deleteData:model];
    return [m selectall];
}

// 查询
-(NSMutableArray *)selectall
{
    DBOperation * m = [DBOperation dataBaseManager];
    return [m selectall];
}

@end
