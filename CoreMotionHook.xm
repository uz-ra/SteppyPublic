#import "Tweak.h"

%hook CMPedometerData
-(NSNumber *)numberOfSteps{
    return @114514810; // 適当な大きい数値に書き換え
}
%end

%ctor {
    [UzLog log:@"[Steppy] Tweak(CoreMotionHook) initialized and classes hooked"];
}