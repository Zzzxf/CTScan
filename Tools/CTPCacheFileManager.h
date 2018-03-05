//
//  CTPCacheFileManager.h
//  FindCar
//
//  Created by 范兴政 on 2017/9/8.
//  Copyright © 2017年 ‰∏•‰Ω≥Êñá. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTPCacheFileManager : NSObject

+ (instancetype)shareManager;

- (void)cacheObject:(id)obj forKey:(NSString *)key atDisk:(BOOL)atDisk;
- (id)cachedObjectForKey:(NSString *)key atDisk:(BOOL)atDisk;

@end

@interface NSDictionary (CTPCacheFileManager)

- (NSString *)constructCacheKey;

@end

@interface NSString (CTPCacheFileManager)

- (NSString *)md5Key;

@end
