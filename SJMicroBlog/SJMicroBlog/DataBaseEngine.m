//
//  DataBaseEngine.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "DataBaseEngine.h"
#import "FMDB.h"
#import "NSString+FilePath.h"

#define kDBFileName     @"status.db"    //数据库文件名
#define kStatusTable    @"status"       //微博表的名字

static NSArray *statusTableColumn;     //保存status表中的所有字段
@implementation DataBaseEngine

+ (void)initialize {
    if (self == [DataBaseEngine self]) {
        //将数据库文件copy到Documents路径下
        [DataBaseEngine copyDataBaseFileToDocumentsWithDBName:kDBFileName];
        //取出初始化表存放的所有字段的数据
        statusTableColumn = [DataBaseEngine tableColumnWithTableName:kStatusTable];
    }
}

+ (void)copyDataBaseFileToDocumentsWithDBName:(NSString *)DBName
{
    NSString *source = [[NSBundle mainBundle] pathForResource:DBName ofType:nil];
    NSString *toPath = [NSString filePathInDocumentsWithFileName:DBName];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        //如果toPath路径下有数据表文件则无需Copy直接返回
        return;
    }
    [[NSFileManager defaultManager] copyItemAtPath:source toPath:toPath error:&error];
    if (error) {
        NSLog(@"!!!!!!%@",error);
    }
}

+ (NSArray *)tableColumnWithTableName:(NSString *)tableName
{
    //创建DB
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [db open];
    
    //执行查找表结构的命令，返回查询结果
    FMResultSet *result = [db getTableSchema:tableName];
    NSMutableArray *columns = [NSMutableArray array];
    while ([result next]) {
        //name字段对应了表的column的名字
        NSString *column = [result objectForColumnName:@"name"];
        [columns addObject:column];
    }
    [db close];
    return columns;
}

+ (void)saveStatus:(NSArray *)statuses
{
    //插入操作，首先创建db，写sql语句，执行操作
    //使用队列时不需要自己创建db,队列会创建
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [queue inDatabase:^(FMDatabase *db) {
        //进行数据库的增删改查
        
        [statuses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *status = obj;
            //首先，查找出所有的有效字段
            NSArray *allKeys = status.allKeys;
            NSArray *contentKeys = [DataBaseEngine commonKeyFromKeys1:statusTableColumn AndKeys2:allKeys];
            //删除字典中多余的键值
            //将微博字典转化为可变字典
            NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:status];
            [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //删除多余的Key
                if (![contentKeys containsObject:obj]) {
                    [resultDict removeObjectForKey:obj];
                }else {
                    //字典中的值转化为二进制数据类型（NSData）
                    id value = [resultDict objectForKey:obj];
                    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                        //如果类型为数组或字典，转化为二进制数据替换掉
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
                        [resultDict setObject:data forKey:obj];
                    }
                }
            }];
            
            //根据table和字典共有的Key创建SQL语句
            NSString *sqlString = [DataBaseEngine sqlStringWithKeys:contentKeys];
            BOOL result = [db executeUpdate:sqlString withParameterDictionary:resultDict];
            NSLog(@"%d>>>>%@",result, sqlString);
            
        }];
    }];
}

+ (NSArray *)commonKeyFromKeys1:(NSArray *)keys1 AndKeys2:(NSArray *)keys2
{
    NSMutableArray *result = [NSMutableArray array];
    [keys1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj;
        //比较一个对象是否包含在另一个数组中
        if ([keys2 containsObject:key]) {
            [result addObject:key];
        }
    }];
    return result;
}

+ (NSString *)sqlStringWithKeys:(NSArray *)keys
{
    //创建SQL语句的字段部分
    NSString *columns = [keys componentsJoinedByString:@", "];
    //创建SQL语句的占位部分
    NSString *values = [keys componentsJoinedByString:@", :"];
    values = [@":" stringByAppendingString:values];
    return [NSString stringWithFormat:@"insert into status(%@) values(%@)",columns, values];
}

+ (NSArray *)getStatusFromDB
{
    return nil;
}

@end
