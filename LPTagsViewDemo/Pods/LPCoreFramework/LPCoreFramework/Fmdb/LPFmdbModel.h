//
//  LPFmdbModel.h
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 4/21/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "MTLModel.h"
#import "FMdatabase.h"
#import "LPBaseModel.h"
#import <MTLFMDBAdapter.h>


@interface LPFmdbModel : LPBaseModel <MTLFMDBSerializing>


#pragma mark - SQL

+ (NSString *)dropTableSQL;
+ (NSString *)createTableSQL;
+ (NSString *)createTableSQLWithDropIfExist;
+ (NSString *)orStatement:(NSArray *)filters columnName:(NSString *)columnName;


#pragma mark - Database

+ (NSString *)databaseName;
+ (FMDatabase *)openDatabase;


#pragma mark - Exist

+ (BOOL)hasItem;
+ (BOOL)hasItem:(LPFmdbModel *)model;


#pragma mark - Insert

+ (void)insertList:(NSArray *)list;
+ (void)insertItem:(LPFmdbModel *)model;

+ (void)insertOrReplaceList:(NSArray *)list;
+ (void)insertOrIgnoreList:(NSArray *)list;

#pragma mark - Delete

+ (BOOL)deleteList;
+ (BOOL)deleteList:(NSArray *)list;

+ (BOOL)deleteItem:(NSInteger)itemId;
+ (BOOL)deleteItemWithModel:(LPFmdbModel *)model;

+ (BOOL)executeDeleteSQL:(NSString *)deleteSQL;
+ (BOOL)executeDeleteSQL:(NSString *)deleteSQL withArgumentsInArray:(NSArray *)arguments;


#pragma mark - Update

+ (void)updateItem:(LPFmdbModel *)model;


#pragma mark - Query

+ (NSArray *)executeQueryFetchList:(NSString *)querySQL;
+ (NSArray *)fetchList;

+ (LPFmdbModel *)executeQueryFetchItem:(NSString *)querySQL;
+ (LPFmdbModel *)fetchItem:(NSInteger)itemId;
+ (LPFmdbModel *)fetchItemWithModel:(LPFmdbModel *)model;


#pragma mark - Tool

+ (NSString *)mappingColumnName:(NSString *)propertyName;


@end
