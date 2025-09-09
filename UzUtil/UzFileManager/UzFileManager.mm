//UzFileManager.mm
//Made by uz.ra in 2025/04/21
//
#import "UzFileManager.h"

@implementation UzFileManager

+ (NSString *)dataDirForBundleID:(NSString *)bundleID {
    NSString *appsRoot = @"/var/mobile/Containers/Data/Application";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *contents = [fm contentsOfDirectoryAtPath:appsRoot error:nil];

    for (NSString *uuid in contents) {
        NSString *metaPath = [appsRoot stringByAppendingPathComponent:
            [NSString stringWithFormat:@"%@/.com.apple.mobile_container_manager.metadata.plist", uuid]
        ];

        NSDictionary *metadata = [NSDictionary dictionaryWithContentsOfFile:metaPath];
        NSString *identifier = metadata[@"MCMMetadataIdentifier"];

        if ([identifier isEqualToString:bundleID]) {
            return [appsRoot stringByAppendingPathComponent:uuid];
        }
    }

    return nil;
}

+ (NSString *)bundleDirForBundleID:(NSString *)bundleID {
    NSString *appsRoot = @"/var/containers/Bundle/Application";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *contents = [fm contentsOfDirectoryAtPath:appsRoot error:nil];

    for (NSString *uuid in contents) {
        NSString *metaPath = [appsRoot stringByAppendingPathComponent:
            [NSString stringWithFormat:@"%@/.com.apple.mobile_container_manager.metadata.plist", uuid]
        ];

        NSDictionary *metadata = [NSDictionary dictionaryWithContentsOfFile:metaPath];
        NSString *identifier = metadata[@"MCMMetadataIdentifier"];

        if ([identifier isEqualToString:bundleID]) {
            return [appsRoot stringByAppendingPathComponent:uuid];
        }
    }

    return nil;
}

+ (void)overwriteXML:(NSString *)inPath : (NSString *)keyPath : (id)withData {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:inPath]) {
        NSLog(@"[overwriteXML] File not found at path: %@", inPath);
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:inPath];
    if (!dict) {
        NSLog(@"[overwriteXML] Failed to read plist at path: %@", inPath);
        return;
    }

    // 型チェック：Plistで有効な型だけを許容（NSString, NSNumber, NSArray, NSDictionary, NSData, NSDate, NSNull）
    if (![withData isKindOfClass:[NSString class]] &&
        ![withData isKindOfClass:[NSNumber class]] &&
        ![withData isKindOfClass:[NSArray class]] &&
        ![withData isKindOfClass:[NSDictionary class]] &&
        ![withData isKindOfClass:[NSData class]] &&
        ![withData isKindOfClass:[NSDate class]] &&
        ![withData isKindOfClass:[NSNull class]]) {
        NSLog(@"[overwriteXML] Unsupported data type: %@", NSStringFromClass([withData class]));
        return;
    }

    // ネスト対応
    NSArray<NSString *> *components = [keyPath componentsSeparatedByString:@"."];
    NSMutableDictionary *currentDict = dict;

    for (NSInteger i = 0; i < components.count; i++) {
        NSString *key = components[i];

        if (i == components.count - 1) {
            currentDict[key] = withData;
        } else {
            id next = currentDict[key];
            if (![next isKindOfClass:[NSMutableDictionary class]]) {
                next = [NSMutableDictionary dictionary];
                currentDict[key] = next;
            }
            currentDict = (NSMutableDictionary *)next;
        }
    }

    BOOL success = [dict writeToFile:inPath atomically:YES];
    if (success) {
        NSLog(@"[overwriteXML] Successfully set %@ = %@ in %@", keyPath, withData, inPath);
    } else {
        NSLog(@"[overwriteXML] Failed to write plist to %@", inPath);
    }
}

+ (void)overwriteJSON:(NSString *)inPath : (NSString *)keyPath : (id)withData {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:inPath]) {
        NSLog(@"[overwriteJSON] File not found at path: %@", inPath);
        return;
    }

    NSData *jsonData = [NSData dataWithContentsOfFile:inPath];
    if (!jsonData) {
        NSLog(@"[overwriteJSON] Failed to read JSON file at path: %@", inPath);
        return;
    }

    NSError *error = nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
    if (!dict || ![dict isKindOfClass:[NSMutableDictionary class]]) {
        NSLog(@"[overwriteJSON] Failed to parse JSON or root is not a dictionary: %@", error);
        return;
    }

    // 型チェック（JSONで有効な型のみ許可）
    if (![withData isKindOfClass:[NSString class]] &&
        ![withData isKindOfClass:[NSNumber class]] &&
        ![withData isKindOfClass:[NSArray class]] &&
        ![withData isKindOfClass:[NSDictionary class]] &&
        ![withData isKindOfClass:[NSNull class]]) {
        NSLog(@"[overwriteJSON] Unsupported data type: %@", NSStringFromClass([withData class]));
        return;
    }

    // ネストされたキーに対応
    NSArray<NSString *> *components = [keyPath componentsSeparatedByString:@"."];
    NSMutableDictionary *currentDict = dict;

    for (NSInteger i = 0; i < components.count; i++) {
        NSString *key = components[i];

        if (i == components.count - 1) {
            // 最後のキーなら値を上書き
            currentDict[key] = withData;
        } else {
            // 中間辞書がなければ作る
            id next = currentDict[key];
            if (![next isKindOfClass:[NSMutableDictionary class]]) {
                next = [NSMutableDictionary dictionary];
                currentDict[key] = next;
            }
            currentDict = (NSMutableDictionary *)next;
        }
    }

    NSData *newJSON = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!newJSON) {
        NSLog(@"[overwriteJSON] Failed to serialize JSON: %@", error);
        return;
    }

    BOOL success = [newJSON writeToFile:inPath atomically:YES];
    if (success) {
        NSLog(@"[overwriteJSON] Successfully set %@ = %@ in %@", keyPath, withData, inPath);
    } else {
        NSLog(@"[overwriteJSON] Failed to write JSON to %@", inPath);
    }
}

@end
