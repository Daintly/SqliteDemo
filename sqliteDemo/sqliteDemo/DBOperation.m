//
//  DBOperation.m
//  sqliteDemo
//
//  Created by renwen on 2018/7/31.
//  Copyright © 2018年 renwen. All rights reserved.
//
/*
 *(1) BLOB是数据库中存储大数据的一种数据类型，它是以二进制的形式来存储数据的。
 
 SQLITE_API int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));
 
 
 　　　　(2) 顾名思义，下面的方法是绑定double类型的数据的
 
   SQLITE_API int sqlite3_bind_double(sqlite3_stmt*, int, double);
 
 
 　　　　(3) 绑定一个32位的整型值
 
          SQLITE_API int sqlite3_bind_int(sqlite3_stmt*, int, int);
 
 
 　　　　(4) 绑定一个64位的整型值
 
          SQLITE_API int sqlite3_bind_int64(sqlite3_stmt*, int, sqlite3_int64);
 
 
 　　　　(5)绑定一个NULL的值(在数据库中可以为NULL)
 
         SQLITE_API int sqlite3_bind_null(sqlite3_stmt*, int);

 　　　　(6)绑定一个UTF-8编码的字符串，第四个参数上面也提到了，是绑定字符串的长度，如果为负值的话，就是传多少就绑定多少。
 
         SQLITE_API int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int n, void(*)(void*));
 　(7)绑定一个UTF-16编码的字符串，第四个参数上面也提到了，是绑定字符串的长度，如果为负值的话，就是传多少就绑定多少。
 
  SQLITE_API int sqlite3_bind_text16(sqlite3_stmt*, int, const void*, int, void(*)(void*));
 
 
 　　　　(8) 绑定sqlite3_value结构体类型的值，sqlite3_value结构体可以保存任意格式的数据。
 
 SQLITE_API int sqlite3_bind_value(sqlite3_stmt*, int, const sqlite3_value*);
 　　　(9)绑定一个任意长度的BLOB类型的二进制数据，它的每一个字节被置0。第3个参数是字节长度。这个函数的特殊用处是，创建一个大的BLOB对象，之后可以通过BLOB接口函数进行更新。
   SQLITE_API int sqlite3_bind_zeroblob(sqlite3_stmt*, int, int n);
 *
 *
 */



#import "DBOperation.h"

static NSString *DB_NAME = @"DAINTY";

@implementation DBOperation
+ (DBOperation *)dataBaseManager{
    static DBOperation *dataBaseManager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseManager = [[DBOperation alloc] init];
        [dataBaseManager createDataBaseTable];
    });
    return dataBaseManager;
}
//创建一个数据库，创建名为dainty的表设定为content属性
- (BOOL)createDataBaseTable{
    NSString *writableDBPath = [self Documentsfillpath];
    const char *charpath = [writableDBPath UTF8String];
    if (sqlite3_open(charpath, &dataBase) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSAssert(NO, @"数据库打开失败");
        return NO;
    }else{
        char *err;
        //创建一个名为Dainty的表，userid 为主键
        
        //drop Table Dainty
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Dainty (userid TEXT PRIMARY KEY,content TEXT,date TEXT, minindex int ,isNumber int);"];
        const char *charSQL = [sql UTF8String];
        if (sqlite3_exec(dataBase, charSQL, NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(dataBase);
             NSAssert(NO, @"数据库建表失败");
            return NO;
        }
        sqlite3_close(dataBase);
    }
    return YES;
}

- (int)addData:(DataModel *)model{
    NSString *path = [self Documentsfillpath];
    const char *charpath = [path UTF8String];
    
    if (sqlite3_open(charpath, &dataBase) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSAssert(NO, @"数据库打开失败");
    }else{
        NSString  *sql = @"INSERT OR REPLACE INTO Dainty (userid,content,date,minindex ,isNumber) VALUES (?,?,?,?,?)";
        const char *charSQL = [sql UTF8String];
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(dataBase, charSQL, -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char *charDate = [strDate UTF8String];
            const char *charContent = [model.content UTF8String];
            const char *charUserid = [model.userid UTF8String];
            
            // 绑定数据
            sqlite3_bind_text(statement, 1, charUserid, -1, NULL);
            sqlite3_bind_text(statement, 2,charContent , -1, NULL);
            sqlite3_bind_text(statement, 3,charDate , -1, NULL);
            sqlite3_bind_int(statement, 4, model.minindex);
            sqlite3_bind_int(statement, 5, model.isNumber);
           
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO,@"插入数据失败" );
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        
    }
    return 0;
}



//删除方法
-(int)deleteData:(DataModel *)model
{
    NSString *path = [self Documentsfillpath];
    const char *sqlname = [path UTF8String];
    if (sqlite3_open(sqlname, &dataBase) != SQLITE_OK) {
        NSAssert(NO,@"打开表失败" );
    }else{
        NSString *delete = @"DELETE FROM Dainty where userid =?";
        const char *charsql = [delete UTF8String];
        
          sqlite3_stmt *statement;
        // 预处理
        if ( sqlite3_prepare_v2(dataBase, charsql, -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *strDate = [dateFormatter stringFromDate:model.date];
//            const char * charDate  = [strDate UTF8String];
            const char *charContent = [model.userid UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, charContent, -1, NULL);
            //执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
              //  NSAssert(NO, @"删除数据失败。");
                return 0;
            }

        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
       
    }
    
    return 1;
}

//查询数据方法
-(NSMutableArray*)selectall
{
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    NSString *path = [self Documentsfillpath];
    const char* charpath = [path UTF8String];
    
    if (sqlite3_open(charpath, &dataBase) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSAssert(NO,@"数据库打开失败。");
       
    } else {

        NSString *sql =@"SELECT * FROM Dainty";
        const char* charSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(dataBase, charSql, -1, &statement, NULL) == SQLITE_OK) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            //执行
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *userid = (char *) sqlite3_column_text(statement, 0);
                NSString *user = [[NSString alloc] initWithUTF8String:userid];
 
                char *bufContent = (char *) sqlite3_column_text(statement, 1);
                NSString * strContent = [[NSString alloc] initWithUTF8String: bufContent];
                char *bufDate = (char *) sqlite3_column_text(statement, 2);
                NSString *strDate = [[NSString alloc] initWithUTF8String: bufDate];
                NSDate *date = [dateFormatter dateFromString:strDate];
                
      
                
                DataModel * model = [DataModel new];
                model.userid = user;
                model.content = strContent;
                model.date = date;
                model.minindex = sqlite3_column_int(statement, 3);
                model.isNumber = sqlite3_column_int(statement, 4);
                

                [listData addObject:model];
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        
    }
    return listData;
}
- (BOOL)dropBaseTable{
    NSString *path = [self Documentsfillpath];
    
    const char *charpath = [path UTF8String];
    if (sqlite3_open(charpath, &dataBase) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSAssert(NO, @"数据库打开失败");
        return NO;
    }else{
        char *err;
        //创建一个名为Dainty的表，userid 为主键
        
        //drop Table Dainty
        NSString *sql = [NSString stringWithFormat:@"drop Table Dainty;"];
        const char *charSQL = [sql UTF8String];
        if (sqlite3_exec(dataBase, charSQL, NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO, @"数据库建表失败");
            return NO;
        }
        sqlite3_close(dataBase);
        
    }
    return YES;
    
}

- (DataModel *)getdbdataByuserid:(NSString *)userid{
   
    if (userid == nil) {
         NSAssert(NO,@"userid 不能为空");
        return nil;
    }
        DataModel * model = [DataModel new];
    NSString *path = [self Documentsfillpath];
    const char* charpath = [path UTF8String];
    
    if (sqlite3_open(charpath, &dataBase) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSAssert(NO,@"数据库打开失败。");
        
    } else {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Dainty where userid = '%@';",userid];
        const char* charSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(dataBase, charSql, -1, &statement, NULL) == SQLITE_OK) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            //执行
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *userid = (char *) sqlite3_column_text(statement, 0);
                NSString *user = [[NSString alloc] initWithUTF8String:userid];

                char *bufContent = (char *) sqlite3_column_text(statement, 1);
                NSString * strContent = [[NSString alloc] initWithUTF8String: bufContent];
                char *bufDate = (char *) sqlite3_column_text(statement, 2);
                NSString *strDate = [[NSString alloc] initWithUTF8String: bufDate];
                NSDate *date = [dateFormatter dateFromString:strDate];
                model.userid = user;
                model.content = strContent;
                model.date = date;
                model.minindex = sqlite3_column_int(statement, 3);
                model.isNumber = sqlite3_column_int(statement, 4);

            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        
    }
    return model;
}

- (NSString *)Documentsfillpath{
    NSString *documentDiretory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDiretory stringByAppendingPathComponent:DB_NAME];
    
    NSLog(@"PATH = %@",path);
    return path;
}
@end
