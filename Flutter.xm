#import "Tweak.h"

%hook SwiftHealthPlugin

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"getData"]) {
        NSLog(@"[Steppy] Intercepted getData!");

        FlutterResult newResult = ^(id _Nullable origValue) {
            if ([origValue isKindOfClass:[NSArray class]]) {
                NSMutableArray *modified = [NSMutableArray array];
                for (NSDictionary *entry in (NSArray *)origValue) {
                    NSMutableDictionary *newEntry = [entry mutableCopy];
                    
                    // value を書き換え
                    NSNumber *origValueNum = entry[@"value"];
                    if (origValueNum) {
                        NSInteger fakeSteps = origValueNum.integerValue + 5000;
                        newEntry[@"value"] = @(fakeSteps);
                        NSLog(@"[Steppy] Modified steps from %@ to %@", origValueNum, newEntry[@"value"]);
                    }

                    [modified addObject:newEntry];
                }
                result(modified);
                return;
            }
            result(origValue);
        };

        %orig(call, newResult);
        return;
    }
    %orig;
}

%end

%ctor {
    %init(SwiftHealthPlugin = objc_getClass("health.SwiftHealthPlugin")
        );
    [UzLog log:@"[Steppy] Tweak initialized and classes hooked"];
}
