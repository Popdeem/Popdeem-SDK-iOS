//
//  WalletCache.m
//  Popdeem
//
//  Created by Niall Quinn on 23/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "WalletCache.h"
#import "PDReward.h"

@implementation WalletCache

+ (void) add:(PDReward*)r {
    if (r.coverImage) {
        NSMutableDictionary *cache = [WalletCache fetchCache];
        [cache setObject:r.coverImage forKey:@(r.identifier)];
        [WalletCache writeCache:cache];
    }
}

+ (void) remove:(PDReward*)r {
    NSMutableDictionary *imagesDict = [WalletCache fetchCache];
    if (imagesDict[@(r.identifier)]) {
        [imagesDict removeObjectForKey:@(r.identifier)];
    }
    [WalletCache writeCache:imagesDict];
}

+ (NSMutableDictionary*) fetchCache {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[WalletCache cacheUrl]];
    NSMutableDictionary *imagesDict;
    if (fileExists) {
        imagesDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[WalletCache cacheUrl]];
    } else {
        imagesDict = [NSMutableDictionary dictionary];
        [WalletCache writeCache:imagesDict];
    }
    return imagesDict;
}

+ (void) writeCache:(NSMutableDictionary*)dict {
    [NSKeyedArchiver archiveRootObject:dict toFile:[WalletCache cacheUrl]];
}

+ (NSString*) cacheUrl {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"walletcache.data"];
    return appFile;
}

+ (UIImage*) imageForReward:(PDReward*)r {
    if ([[WalletCache fetchCache] objectForKey:@(r.identifier)]) {
        return [[WalletCache fetchCache] objectForKey:@(r.identifier)];
    }
    return nil;
}

+ (void) clearCache {
    [WalletCache writeCache:[NSMutableDictionary dictionary]];
}

@end
