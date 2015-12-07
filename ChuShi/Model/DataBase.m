//
//  DataBase.m
//  WordRecognition
//
//  Created by 李超 on 15/12/3.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "DataBase.h"
#import <FMDB.h>
#import "Card.h"

#define CHINESE   @"chinese"
#define ENGLISH   @"english"
#define IMAGE     @"image"
#define IDENTIFIER @"identifier"

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DABASE_NAME @"/database.sqlite"

@interface DataBase()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation DataBase

static NSString *const CREATE_TABLE_SQL = @"CREATE TABLE IF NOT EXISTS mine (chinese TEXT,english TEXT,image BLOB,identifier INTEGER)";

static NSString *const UPDATE_SQL = @"REPLACE INTO %@ (chinese, english, image, identifier) values (?, ?, ?, %d)";

static NSString *const SELECT_ALL_SQL = @"SELECT * from %@";

static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";

static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where identifier = %d";

- (BOOL)checkTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        NSLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}


+ (instancetype)sharedInstance{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self loadDataBase];
        self.identifier = 100;
    }
    return self;
}

- (void)loadDataBase{
    NSString *path = [PATH_OF_DOCUMENT stringByAppendingString:DABASE_NAME];
    NSLog(@"%@",path);
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:CREATE_TABLE_SQL];
    }];
    if (!result) {
        NSLog(@"create table fail");
    }
}


- (NSMutableArray *)selectAllDataFromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat: SELECT_ALL_SQL, tableName];
    __block NSMutableArray *result = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Card *card = [[Card alloc] init];
            card.chinese = [rs stringForColumn:CHINESE];
            card.english = [rs stringForColumn:ENGLISH];
            card.images = @[[UIImage imageWithData:[rs dataForColumn:IMAGE]]];
            card.imageCounts = 1;
            card.identifier = [rs intForColumn:IDENTIFIER];
            [result addObject:card];
        }
    }];
    return result;
}

- (void)clearAllDataFromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSString *sql = [NSString stringWithFormat: CLEAR_ALL_SQL, tableName];
    __block BOOL result;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    NSAssert(result == YES, @"delete all failed");
    return;
}

- (void)deleteDataFromTable:(NSString *)tableName card:(Card *)card {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSLog(@"%@",card.description);
    NSString *sql = [NSString stringWithFormat:DELETE_ITEM_SQL, tableName, card.identifier];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql, card.identifier];
    }];
    return;
}

- (void)insertDataIntoTable:(NSString *)tableName card:(Card *)card{
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:UPDATE_SQL, tableName, self.identifier];
    self.identifier += 1;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql, card.chinese, card.english, [self dataFromImage:card.images[0]]];
    }];
    return;
}

- (NSData *)dataFromImage:(UIImage *)image {
    return UIImagePNGRepresentation(image);
}


@end
