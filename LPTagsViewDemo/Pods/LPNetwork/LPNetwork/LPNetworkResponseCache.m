//
//  LPNetworkResponseCache.m
//  LoopeerNetworkDemo
//
//  Created by dengjiebin on 5/20/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPNetworkResponseCache.h"

static NSString * const kNetworkRequestManagerCacheDirectory = @"kNetworkRequestManagerCacheDirectory";
static NSString * const kNetworkFileProcessingQueue = @"kNetworkFileProcessingQueue";

@implementation LPNetworkResponseCache {
    NSCache *_memoryCache;
    NSFileManager *_fileManager;
    NSString *_cachePath;
    dispatch_queue_t _queue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _memoryCache = [[NSCache alloc] init];
        _queue = dispatch_queue_create([kNetworkFileProcessingQueue UTF8String], DISPATCH_QUEUE_CONCURRENT);
        [self createCachesDirectory];
    }
    return self;
}

- (void)createCachesDirectory {
    _fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _cachePath = [cachePath stringByAppendingPathComponent:kNetworkRequestManagerCacheDirectory];
    BOOL isDirectory;
    if (![_fileManager fileExistsAtPath:_cachePath isDirectory:&isDirectory]) {
        __autoreleasing NSError *error = nil;
        BOOL created = [_fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSLog(@"<LPNetworkRequest> - create cache directory failed with error:%@", error);
        }
    }
}

- (NSString *)encodedString:(NSString *)string {
    if (![string length])
        return @"";
    
    CFStringRef static const charsToEscape = CFSTR(".:/");
    CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef)string,
                                                                        NULL,
                                                                        charsToEscape,
                                                                        kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)escapedString;
}

- (NSString *)decodedString:(NSString *)string {
    if (![string length])
        return @"";
    
    CFStringRef unescapedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef)string,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)unescapedString;
}


- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    NSString *encodedKey = [self encodedString:key];
    [_memoryCache setObject:object forKey:key];
    dispatch_async(_queue, ^{
        NSString *filePath = [_cachePath stringByAppendingPathComponent:encodedKey];
        BOOL written = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
        if (!written) {
            NSLog(@"<LPNetworkRequest> - set object to file failed");
        }
    });
}

- (id <NSCoding>)objectForKey:(NSString *)key {
    NSString *encodedKey = [self encodedString:key];
    id<NSCoding> object = [_memoryCache objectForKey:encodedKey];
    if (!object) {
        NSString *filePath = [_cachePath stringByAppendingPathComponent:encodedKey];
        if ([_fileManager fileExistsAtPath:filePath]) {
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        }
    }
    return object;
}

- (void)removeAllObjects {
    [_memoryCache removeAllObjects];
    __autoreleasing NSError *error;
    BOOL removed = [_fileManager removeItemAtPath:_cachePath error:&error];
    if (!removed) {
        NSLog(@"<LPNetworkRequest> - remove cache directory failed with error:%@", error);
    }
}

- (void)trimToDate:(NSDate *)date {
    __autoreleasing NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:_cachePath]
                                                   includingPropertiesForKeys:@[NSURLContentModificationDateKey]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        error:&error];
    if (error) {
        NSLog(@"<LPNetworkRequest> - get files error:%@", error);
    }
    
    dispatch_async(_queue, ^{
        for (NSURL *fileURL in files) {
            NSDictionary *dictionary = [fileURL resourceValuesForKeys:@[NSURLContentModificationDateKey] error:nil];
            NSDate *modificationDate = [dictionary objectForKey:NSURLContentModificationDateKey];
            if (modificationDate.timeIntervalSince1970 - date.timeIntervalSince1970 < 0) {
                [_fileManager removeItemAtPath:fileURL.absoluteString error:nil];
            }
        }
    });
}

- (void)removeObjectForKey:(NSString *)key {
    NSString *encodedKey = [self encodedString:key];
    [_memoryCache removeObjectForKey:encodedKey];
    NSString *filePath = [_cachePath stringByAppendingPathComponent:encodedKey];
    if ([_fileManager fileExistsAtPath:filePath]) {
        __autoreleasing NSError *error = nil;
        BOOL removed = [_fileManager removeItemAtPath:filePath error:&error];
        if (!removed) {
            NSLog(@"<LPNetworkRequest> - remove item failed with error:%@", error);
        }
    }
}

@end
