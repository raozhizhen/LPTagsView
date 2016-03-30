//
//  LPFmdbModel.m
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 4/21/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPFmdbModel.h"
#import "NSObject+Properties.h"

static NSString *const kLPSQLiteDatabaseDefaultFileName = @"loopeer.sqlite";

@implementation LPFmdbModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return @{};
}


+ (NSDictionary *)FMDBColumnsByPropertyKey {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return @{};
}

+ (NSString *)FMDBTableName {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return @"";
}

+ (NSArray *)FMDBPrimaryKeys {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return @[];
}


#pragma mark - Database

+ (FMDatabase *)openDatabase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sqliteFilePath = [documentsDirectory stringByAppendingPathComponent:[self databaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:sqliteFilePath];
    [db open];
    return db;
}

+ (NSString *)databaseName {
    return kLPSQLiteDatabaseDefaultFileName;
}

#pragma mark - SQL

+ (NSString *)dropTableSQL {
    return [NSString stringWithFormat:@"drop table if exists %@", [self FMDBTableName]];
}

+ (NSString *)createTableSQL {
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"create table if not exists "];
    [sql appendString:[self FMDBTableName]];
    
    [sql appendFormat:@" ("];
    NSDictionary *properties = [self classProperties];
    [[properties allKeys] enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        NSString *columnName = [self mappingColumnName:propertyName];
        if (!columnName || [columnName length] == 0) {
            return;
        }
        
        if (idx > 0)
            [sql appendFormat:@", "];
        
        [sql appendString:columnName];
        [sql appendString:@" "];
        [sql appendString:[self sqlFieldTypeWithPropertyType:[properties objectForKey:propertyName]]];
    }];
    
    [sql appendFormat:@", PRIMARY KEY (%@)", [self buildPrimaryKeyString]];
    [sql appendFormat:@")"];
    
    return [sql copy];
}

+ (NSString *)createTableSQLWithDropIfExist {
    return [NSString stringWithFormat:@"%@; \r\n %@", [self dropTableSQL], [self createTableSQL]];
}

+ (NSString *)orStatement:(NSArray *)filters columnName:(NSString *)columnName {
    NSMutableArray *list = [NSMutableArray new];
    [filters enumerateObjectsUsingBlock:^(NSString *filter, NSUInteger idx, BOOL * stop) {
        [list addObject:[NSString stringWithFormat:@"%@ = '%@'", columnName, filter]];
    }];
    
    return [list componentsJoinedByString:@" OR "];
}

+ (NSString *)insertOrReplaceStatementForModel:(MTLModel<MTLFMDBSerializing> *)model {
    NSDictionary *columns = [model.class FMDBColumnsByPropertyKey];
    NSSet *propertyKeys = [model.class propertyKeys];
    NSArray *Keys = [[propertyKeys allObjects] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *stats = [NSMutableArray array];
    NSMutableArray *qmarks = [NSMutableArray array];
    for (NSString *propertyKey in Keys)
    {
        NSString *keyPath = columns[propertyKey];
        keyPath = keyPath ? : propertyKey;
        
        if (keyPath != nil && ![keyPath isEqual:[NSNull null]])
        {
            [stats addObject:keyPath];
            [qmarks addObject:@"?"];
        }
    }
    
    NSString *statement = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", [model.class FMDBTableName], [stats componentsJoinedByString:@", "], [qmarks componentsJoinedByString:@", "]];
    
    return statement;
}

+ (NSString *)insertOrIgnoreStatementForModel:(MTLModel<MTLFMDBSerializing> *)model {
    NSDictionary *columns = [model.class FMDBColumnsByPropertyKey];
    NSSet *propertyKeys = [model.class propertyKeys];
    NSArray *Keys = [[propertyKeys allObjects] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *stats = [NSMutableArray array];
    NSMutableArray *qmarks = [NSMutableArray array];
    for (NSString *propertyKey in Keys)
    {
        NSString *keyPath = columns[propertyKey];
        keyPath = keyPath ? : propertyKey;
        
        if (keyPath != nil && ![keyPath isEqual:[NSNull null]])
        {
            [stats addObject:keyPath];
            [qmarks addObject:@"?"];
        }
    }
    
    NSString *statement = [NSString stringWithFormat:@"insert or ignore into %@ (%@) values (%@)", [model.class FMDBTableName], [stats componentsJoinedByString:@", "], [qmarks componentsJoinedByString:@", "]];
    
    return statement;
}

#pragma mark - Exist

+ (BOOL)hasItem {
    NSArray *list = [self fetchList];
    if (list.count > 0)
        return YES;
    
    return NO;
}


+ (BOOL)hasItem:(LPFmdbModel *)model {
    LPFmdbModel *object = [self fetchItemWithModel:model];
    if (object)
        return YES;
    
    return NO;
}


#pragma mark - Insert

+ (void)insertList:(NSArray *)list {
    if (!list || list.count <= 0)
        return;
    
    FMDatabase *db = [self openDatabase];
    [db open];
    [list enumerateObjectsUsingBlock:^(LPFmdbModel *model, NSUInteger idx, BOOL *stop) {
        NSString *stmt = [MTLFMDBAdapter insertStatementForModel:model];
        NSArray *params = [MTLFMDBAdapter columnValues:model];
        [db executeUpdate:stmt withArgumentsInArray:params];
    }];
    [db close];
}

+ (void)insertItem:(LPFmdbModel *)model {
    FMDatabase *db = [self openDatabase];
    [db open];
    
    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:model];
    NSArray *params = [MTLFMDBAdapter columnValues:model];
    [db executeUpdate:stmt withArgumentsInArray:params];
    
    [db close];
}

+ (void)insertOrReplaceList:(NSArray *)list {
    if (!list || list.count <= 0)
        return;
    
    FMDatabase *db = [self openDatabase];
    [db open];
    [list enumerateObjectsUsingBlock:^(LPFmdbModel *model, NSUInteger idx, BOOL *stop) {
        NSString *stmt = [self insertOrReplaceStatementForModel:model];
        NSArray *params = [MTLFMDBAdapter columnValues:model];
        [db executeUpdate:stmt withArgumentsInArray:params];
    }];
    [db close];
}

+ (void)insertOrIgnoreList:(NSArray *)list {
    if (!list || list.count <= 0)
        return;
    
    FMDatabase *db = [self openDatabase];
    [db open];
    [list enumerateObjectsUsingBlock:^(LPFmdbModel *model, NSUInteger idx, BOOL *stop) {
        NSString *stmt = [self insertOrIgnoreStatementForModel:model];
        NSArray *params = [MTLFMDBAdapter columnValues:model];
        [db executeUpdate:stmt withArgumentsInArray:params];
    }];
    [db close];
}

#pragma mark - Delete

+ (BOOL)executeDeleteSQL:(NSString *)deleteSQL {
    return [self executeDeleteSQL:deleteSQL withArgumentsInArray:nil];
}

+ (BOOL)executeDeleteSQL:(NSString *)deleteSQL withArgumentsInArray:(NSArray *)arguments {
    FMDatabase *db = [self openDatabase];
    [db open];
    
    BOOL result = YES;
    if (arguments) {
        result = [db executeUpdate:deleteSQL withArgumentsInArray:arguments];
    } else {
        result = [db executeUpdate:deleteSQL];
    }
    [db close];
    
    return result;
}

+ (BOOL)deleteList {
    NSString *sql = [NSString stringWithFormat:@"delete from %@", [self FMDBTableName]];
    return [self executeDeleteSQL:sql];
}


+ (BOOL)deleteList:(NSArray *)list {
    FMDatabase *db = [self openDatabase];
    [db open];
    [db beginTransaction];
    
    [list enumerateObjectsUsingBlock:^(LPFmdbModel *model, NSUInteger idx, BOOL *stop) {
        NSString *deleteSQL = [MTLFMDBAdapter deleteStatementForModel:model];
        [db executeUpdate:deleteSQL withArgumentsInArray:[MTLFMDBAdapter primaryKeysValues:model]];
    }];
    
    BOOL result = [db commit];
    [db close];
    
    return result;
}

+ (BOOL)deleteItem:(NSInteger)itemId {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = %d", [self FMDBTableName], itemId];
    return [self executeDeleteSQL:sql];
}

+ (BOOL)deleteItemWithModel:(LPFmdbModel *)model {
    NSString *sql = [MTLFMDBAdapter deleteStatementForModel:model];
    return [self executeDeleteSQL:sql withArgumentsInArray:[MTLFMDBAdapter primaryKeysValues:model]];
}


#pragma mark - Update

+ (void)updateItem:(LPFmdbModel *)model {
    FMDatabase *db = [self openDatabase];
    [db open];
    
    NSString *stmt = [MTLFMDBAdapter updateStatementForModel:model];
    NSArray *params = [MTLFMDBAdapter columnValues:model];
    
    NSMutableArray *sParams = [NSMutableArray new];
    [sParams addObjectsFromArray:params];
    [sParams addObjectsFromArray:[MTLFMDBAdapter primaryKeysValues:model]];
    [db executeUpdate:stmt withArgumentsInArray:[sParams copy]];
    [db close];
}


#pragma mark - Query

+ (LPFmdbModel *)executeQueryFetchItem:(NSString *)querySQL withArgumentsInArray:(NSArray *)arguments {
    NSArray *list = [self executeQueryFetchList:querySQL withArgumentsInArray:arguments];
    if (list.count <= 0)
        return nil;
    
    return [list objectAtIndex:0];
}


+ (NSArray *)fetchList {
    NSMutableString *querySQL = [NSMutableString stringWithFormat:@"select * from %@", [self FMDBTableName]];
    return [self executeQueryFetchList:querySQL];
}


+ (LPFmdbModel *)fetchItem:(NSInteger)itemId {
    NSString *querySQL = [NSString stringWithFormat:@"select * from %@ where id=%d", [self FMDBTableName], itemId];
    return [self executeQueryFetchItem:querySQL];
}

+ (LPFmdbModel *)fetchItemWithModel:(LPFmdbModel *)model {
    NSString *querySQL = [NSString stringWithFormat:@"select * from %@ where %@", [self FMDBTableName], [MTLFMDBAdapter whereStatementForModel:model]];
    return [self executeQueryFetchItem:querySQL withArgumentsInArray:[MTLFMDBAdapter primaryKeysValues:model]];
}


+ (NSArray *)executeQueryFetchList:(NSString *)querySQL withArgumentsInArray:(NSArray *)arguments {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [self openDatabase];
    FMResultSet *rs = nil;
    if (arguments) {
        rs = [db executeQuery:querySQL withArgumentsInArray:arguments];
    } else {
        rs = [db executeQuery:querySQL];
    }
    
    while ([rs next]) {
        id obj = [MTLFMDBAdapter modelOfClass:[self class] fromFMResultSet:rs error:nil];
        [list addObject:obj];
    }
    [db close];
    return [list copy];
}

+ (NSArray *)executeQueryFetchList:(NSString *)querySQL {
    return [self executeQueryFetchList:querySQL withArgumentsInArray:nil];
}

+ (LPFmdbModel *)executeQueryFetchItem:(NSString *)querySQL {
    NSArray *list = [self executeQueryFetchList:querySQL];
    if (list.count <= 0)
        return nil;
    
    return [list objectAtIndex:0];
}




#pragma mark - Private

+ (NSString *)findPrimaryKeyPropertyName {
    __block NSString *primaryKey;
    [[self FMDBPrimaryKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([[self mappingColumnName:key] isEqualToString:@"id"]) {
            primaryKey = key;
            *stop = YES;
        }
    }];
    
    return primaryKey;
}

+ (NSString *)mappingColumnName:(NSString *)propertyName {
    __block NSString *mappingKey = propertyName;
    [[[self FMDBColumnsByPropertyKey] allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([key isEqualToString:propertyName]) {
            *stop = YES;
            mappingKey = [[self FMDBColumnsByPropertyKey] objectForKey:propertyName];
        }
    }];
    return mappingKey;
}

+ (NSString *)sqlFieldTypeWithPropertyType:(NSString *)propertyType {
    if ([propertyType isEqualToString:@"NSNumber"]) {
        // NSNumber
        return @"integer";
    } else if ([propertyType isEqualToString:@"NSString"]) {
        // NSString
        return @"text";
    } else if ([propertyType isEqualToString:@"q"]) {
        // NSInteger
        // see: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
        return @"integer";
    } else if ([propertyType isEqualToString:@"i"]) {
        // int
        // see: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
        return @"integer";
    } else if ([propertyType isEqualToString:@"c"]) {
        // BOOL
        return @"integer";
    } else {
        // Others
        return @"text";
    }
}

+ (NSString *)buildPrimaryKeyString {
    NSMutableString *primaryKey = [[NSMutableString alloc] init];
    [[self FMDBPrimaryKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (idx > 0) {
            [primaryKey appendString:@","];
        }
        [primaryKey appendString:[self mappingColumnName:key]];
    }];
    return [primaryKey copy];
}


@end
