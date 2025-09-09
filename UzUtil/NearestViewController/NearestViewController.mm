//NearestViewController.mm
//Made by uz.ra in 2025/02/16
//

#import "NearestViewController.h"

@implementation UIView (NearestViewController)

- (UIViewController *)nearestViewController {
    // nextResponderをたどってUIViewControllerを探す
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil; //UIViewControllerが見つからない場合nilを返す
}

@end