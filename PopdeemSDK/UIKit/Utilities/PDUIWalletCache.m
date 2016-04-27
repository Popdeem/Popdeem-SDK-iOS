//
//  WalletCache.m
//  Popdeem
//
//  Created by Niall Quinn on 23/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUIWalletCache.h"
#import "PDReward.h"

@implementation PDUIWalletCache

+ (void) add:(PDReward*)r {
    if (r.coverImage) {
        NSMutableDictionary *cache = [PDUIWalletCache fetchCache];
        [cache setObject:r.coverImage forKey:@(r.identifier)];
        [PDUIWalletCache writeCache:cache];
    }
}

+ (void) remove:(PDReward*)r {
    NSMutableDictionary *imagesDict = [PDUIWalletCache fetchCache];
    if (imagesDict[@(r.identifier)]) {
        [imagesDict removeObjectForKey:@(r.identifier)];
    }
    [PDUIWalletCache writeCache:imagesDict];
}

+ (NSMutableDictionary*) fetchCache {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[PDUIWalletCache cacheUrl]];
    NSMutableDictionary *imagesDict;
    if (fileExists) {
        imagesDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[PDUIWalletCache cacheUrl]];
    } else {
        imagesDict = [NSMutableDictionary dictionary];
        [PDUIWalletCache writeCache:imagesDict];
    }
    return imagesDict;
}

+ (void) writeCache:(NSMutableDictionary*)dict {
    [NSKeyedArchiver archiveRootObject:dict toFile:[PDUIWalletCache cacheUrl]];
}

+ (NSString*) cacheUrl {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"walletcache.data"];
    return appFile;
}

+ (UIImage*) imageForReward:(PDReward*)r {
    if ([[PDUIWalletCache fetchCache] objectForKey:@(r.identifier)]) {
        return [[PDUIWalletCache fetchCache] objectForKey:@(r.identifier)];
    }
    return nil;
}

+ (void) clearCache {
    [PDUIWalletCache writeCache:[NSMutableDictionary dictionary]];
}

@end
