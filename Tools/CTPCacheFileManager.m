//
//  CTPCacheFileManager.m
//  FindCar
//
//  Created by 范兴政 on 2017/9/8.
//  Copyright © 2017年 ‰∏•‰Ω≥Êñá. All rights reserved.
//

#import "CTPCacheFileManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface CTPCacheFileManager () {
    
    NSCache *_cache;
}

@end

@implementation CTPCacheFileManager

+ (instancetype)shareManager {
    
    static CTPCacheFileManager * _manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CTPCacheFileManager alloc] init];
    });
    
    return _manager;
}

- (NSCache *)cache {
    
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

- (NSString *)cacheDiskPath {
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CacheFile"];
    return path;
}

- (id)cachedObjectForKey:(NSString *)key atDisk:(BOOL)atDisk {
    
    if (!key) {
        return nil;
    }
    if (!atDisk) {
        return [[self cache] objectForKey:key];
    }
    NSString *filePath = [self cacheDiskPath];
    NSString *path = [filePath stringByAppendingPathComponent:[key md5Key]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (!data || ![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
}

- (void)cacheObject:(id)obj forKey:(NSString *)key atDisk:(BOOL)atDisk {
    
    if (!obj || !key) {
        return;
    }
    if (!atDisk) {
        [[self cache] setObject:obj forKey:key];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSString *filePath = [self cacheDiskPath];
    NSString *path = [filePath stringByAppendingPathComponent:[key md5Key]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager isExecutableFileAtPath:path]) {
        NSError *error = nil;
        if ([fileManager removeItemAtPath:path error:&error]) {
            NSLog(@">>>remove file failed: %@", error.debugDescription);
        }
        return;
    }
    if (![fileManager fileExistsAtPath:filePath]) {
        if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@">>>create directory failed at path: %@", filePath);
        }
    }
    if (![fileManager createFileAtPath:path contents:data attributes:nil]) {
        NSLog(@">>>create file failed at path: %@", path);
    }
}
@end

@implementation NSDictionary (CTPCacheFileManager)

- (NSString *)constructCacheKey {
    
    NSMutableString *resultKey = [NSMutableString string];
    
    for (id obj in self.allValues) {
        
        [resultKey appendString:[NSString stringWithFormat:@"/%@", obj]];
    }
    
    return resultKey;
}

@end

@implementation NSString (CTPCacheFileManager)

- (NSString *)md5Key {
    
    const char* cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    static const char HexEncodeChars[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    char *resultData = malloc(CC_MD5_DIGEST_LENGTH * 2 + 1);
    
    for (uint index = 0; index < CC_MD5_DIGEST_LENGTH; index++) {
        resultData[index * 2] = HexEncodeChars[(result[index] >> 4)];
        resultData[index * 2 + 1] = HexEncodeChars[(result[index] % 0x10)];
    }
    resultData[CC_MD5_DIGEST_LENGTH * 2] = 0;
    
    NSString *resultString = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    free(resultData);
    
    return [resultString uppercaseString];
}

@end
