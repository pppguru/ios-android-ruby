#import <objc/runtime.h>
#import "UIButton+BackgroundContentMode.h"


@implementation UIButton (BackgroundContentMode)

#pragma mark Swizzling Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzle:@selector(setBackgroundImage:forState:)];
    });
}

+ (void)swizzle:(SEL)selector {
    NSString *name = [NSString stringWithFormat:@"swizzled_%@", NSStringFromSelector(selector)];
    Method m1 = class_getInstanceMethod(self, selector);
    Method m2 = class_getInstanceMethod(self, NSSelectorFromString(name));
    method_exchangeImplementations(m1, m2);
}


#pragma mark Background Content Mode

- (UIViewContentMode)backgroundContentMode {
    NSNumber *rawValue = objc_getAssociatedObject(self, @selector(backgroundContentMode));
    if (rawValue) {
        return (UIViewContentMode)rawValue.integerValue;
    }
    return UIViewContentModeScaleToFill;
}

- (void)setBackgroundContentMode:(UIViewContentMode)contentMode {
    objc_setAssociatedObject(self, @selector(backgroundContentMode), @(contentMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.backgroundImageView.contentMode = contentMode;
}


#pragma mark Background Image View

- (nullable UIImageView *)backgroundImageView {
    return objc_getAssociatedObject(self, @selector(backgroundImageView));
}

- (void)setBackgroundImageView:(nullable UIImageView *)backgroundImageView {
    objc_setAssociatedObject(self, @selector(backgroundImageView), backgroundImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark Setting Background Image

- (void)swizzled_setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state {
    if (self.backgroundImageView) {
        self.backgroundImageView.contentMode = self.backgroundContentMode;
        [self swizzled_setBackgroundImage:image forState:state];
        return;
    }
    
    NSSet *oldSubviews = [NSSet setWithArray:self.subviews];
    [self swizzled_setBackgroundImage:image forState:state];
    [self layoutIfNeeded]; // let's create background image view right now
    
    NSMutableSet *newSubviews = [NSMutableSet setWithArray:self.subviews];
    [newSubviews minusSet:oldSubviews];
    
    for (UIView *newView in newSubviews.objectEnumerator) {
        if ([newView isKindOfClass:UIImageView.class]) {
            self.backgroundImageView = (UIImageView *)newView;
            self.backgroundImageView.contentMode = self.backgroundContentMode;
            break;
        }
    }
}


@end
