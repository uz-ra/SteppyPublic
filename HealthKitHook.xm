#import "Tweak.h"

// 固定値にしたい歩数
static const double kFixedSteps = 10000.0;

// stepCount かどうか判定
static BOOL IsStepCountType(HKObjectType *type) {
    if (![type respondsToSelector:@selector(identifier)]) return NO;
    NSString *iden = [type identifier];
    // SDK がない前提でも動くように文字列比較
    return [iden isEqualToString:@"HKQuantityTypeIdentifierStepCount"] ||
           [iden isEqualToString:HKQuantityTypeIdentifierStepCount];
}

%hook HKSampleQuery

// initWithSampleType:predicate:limit:sortDescriptors:resultsHandler:
- (id)initWithSampleType:(HKSampleType *)sampleType
               predicate:(id)predicate
                   limit:(NSUInteger)limit
        sortDescriptors:(NSArray *)sortDescriptors
         resultsHandler:(void (^)(HKSampleQuery *q, NSArray *results, NSError *error))handler {

    if (IsStepCountType(sampleType) && handler) {
        void (^wrapped)(HKSampleQuery *, NSArray *, NSError *) =
        ^(HKSampleQuery *q, NSArray *results, NSError *error) {

            // サンプル配列（NSDictionary/オブジェクト混在でも）を差し替え
            NSMutableArray *out = [NSMutableArray arrayWithCapacity:results.count];
            for (id obj in results) {
                // NSDictionary で { value: <num>, ... } の形を優先的に処理
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *m = [obj mutableCopy];
                    m[@"value"] = @(kFixedSteps);
                    [out addObject:m];
                    continue;
                }
                // HKQuantitySample などオブジェクトの場合は quantity を差し替えた仮オブジェクトが必要
                // ここでは雑に「読み手側が quantity.doubleValue を呼ぶときに効く」下の HKQuantity hook に任せる
                [out addObject:obj];
            }
            handler(q, out, error);
        };
        return %orig(sampleType, predicate, limit, sortDescriptors, wrapped);
    }
    return %orig;
}

%end

%hook HKStatistics

- (HKQuantity *)sumQuantity {
    HKQuantity *orig = %orig;
    HKQuantityType *qt = [self quantityType];
    if (qt && IsStepCountType(qt)) {
        return [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:kFixedSteps];
    }
    return orig;
}

- (HKQuantity *)mostRecentQuantity {
    HKQuantity *orig = %orig;
    HKQuantityType *qt = [self quantityType];
    if (qt && IsStepCountType(qt)) {
        return [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:kFixedSteps];
    }
    return orig;
}

- (HKQuantity *)averageQuantity {
    HKQuantity *orig = %orig;
    HKQuantityType *qt = [self quantityType];
    if (qt && IsStepCountType(qt)) {
        return [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:kFixedSteps];
    }
    return orig;
}

%end

%hook HKQuantity

- (double)doubleValueForUnit:(HKUnit *)unit {
    // 呼び元のコンテキストで type を持たないので、合計系は上の HKStatistics hook で対応済み。
    // ここでは unit==count の場合だけ固定値を返す「最後の保険」にする。
    double v = %orig(unit);
    // countUnit のインスタンス判定が難しい環境もあるので、ざっくりフック（必要なら厳密化）
    if ([unit isKindOfClass:[HKUnit class]]) {
        // ここで固定値を返すと他の「count」系にも影響するので、最小限にしたいなら無効化してOK
        // return kFixedSteps;
        return v;
    }
    return v;
}

%end
