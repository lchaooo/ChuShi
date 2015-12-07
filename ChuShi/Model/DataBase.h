//
//  DataBase.h
//  WordRecognition
//
//  Created by 李超 on 15/12/3.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface DataBase : NSObject

@property (nonatomic, assign) int identifier;

/**
 *  返回单例
 *
 *  @return 
 */
+ (instancetype)sharedInstance;

/**
 *  select all data from table
 *
 *  @param tableName
 *
 *  @return cards array
 */
- (NSMutableArray *)selectAllDataFromTable:(NSString *)tableName;

/**
 *  clear all data from table(especially mine table)
 *
 *  @param tableName
 */
- (void)clearAllDataFromTable:(NSString *)tableName;

/**
 *  delete card from table
 *
 *  @param tableName
 *  @param cards
 */
- (void)deleteDataFromTable:(NSString *)tableName card:(Card *)cards;

/**
 *  insert data
 *
 *  @param tableName
 *  @param card      
 */
- (void)insertDataIntoTable:(NSString *)tableName card:(Card *)card;

@end
