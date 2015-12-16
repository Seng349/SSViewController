//
//  SSViewController.m
//  TestWindow
//
//  Created by Seng349 on 15/12/13.
//  Copyright © 2015年 Banana. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()
{
    UIWindow *mWindow;
}

@property (copy) void(^showCompletion)(BOOL finished);
@property (copy) void(^hideCompletion)(BOOL finished);

@end

@implementation SSViewController

#pragma mark -
#pragma mark 构造

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self ket_init];
    }
    
    return self;
}

- (void)ket_init
{
    @autoreleasepool
    {
        CATransition *transition       = [CATransition animation];
        transition.delegate            = self;
        transition.duration            = 0.3F;
        transition.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type                = kCATransitionFade;
        transition.subtype             = kCATransitionFromRight;
        transition.fillMode            = kCAFillModeRemoved;
        transition.removedOnCompletion = YES;
        
        self.showAnimation = transition;
        self.hideAnimation = transition;
    }
    
    mWindow                 = [[UIWindow alloc] init];
    mWindow.backgroundColor = [UIColor clearColor];
    [mWindow setHidden:NO];
}

- (void)dealloc
{
    self.showAnimation  = nil;
    self.hideAnimation  = nil;
    self.showCompletion = nil;
    self.hideCompletion = nil;

    [super dealloc];
    
    if (mWindow)
    {
        [mWindow release];
        mWindow = nil;
    }
}

#pragma mark -
#pragma mark Public

- (void)show:(BOOL)animted completion:(void (^)(BOOL))completion
{
    @autoreleasepool
    {
        self.showCompletion = completion;
        
        if (animted)
        {
            [CATransaction flush];
            
            [mWindow.layer removeAllAnimations];
            [mWindow.layer addAnimation:self.showAnimation forKey:@"Animation"];
        }
        else
        {
            [mWindow.layer removeAllAnimations];
        }
        
        if (mWindow.rootViewController)
        {
            [mWindow.rootViewController.view removeFromSuperview];
        }
        
        mWindow.rootViewController = self;
        
        if (!animted && self.showCompletion)
        {
            self.showCompletion(YES);
            self.showCompletion = nil;
        }
    }
}

- (void)hide:(BOOL)animted completion:(void (^)(BOOL))completion
{
    @autoreleasepool
    {
        if (animted)
        {
            [CATransaction flush];
            
            [mWindow.layer removeAllAnimations];
            [mWindow.layer addAnimation:self.hideAnimation forKey:@"Animation"];
        }
        else
        {
            [mWindow.layer removeAllAnimations];
        }
        
        [self.view removeFromSuperview];
        
        __block UIWindow *weakWindow = mWindow;
        self.hideCompletion = ^(BOOL finished) {
            completion(finished);
            weakWindow.rootViewController = nil;
            [weakWindow setHidden:YES];
            self.showAnimation            = nil;
            self.hideAnimation            = nil;
        };
        
        if (!animted && self.hideCompletion)
        {
            self.hideCompletion(YES);
            self.hideCompletion = nil;
        }
    }
}


#pragma mark -
#pragma mark Property

- (void)setWindowLevel:(UIWindowLevel)windowLevel
{
    _windowLevel = windowLevel;
    
    mWindow.windowLevel = windowLevel;
}


#pragma mark -
#pragma mark Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.showCompletion)
    {
        self.showCompletion(flag);
        self.showCompletion = nil;
    }
    
    if (self.hideCompletion)
    {
        self.hideCompletion(flag);
        self.hideCompletion = nil;
    }
}

- (CGRect)keyBoardFrame
{
    // 使用宏定义，当前代码段在作为插件使用时无效
    
    #if !defined(SV_APP_EXTENSIONS)
    
    UIWindow *keyboardWindow = nil;
    
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
    {
        if ([testWindow isKindOfClass: NSClassFromString(@"UITextEffectsWindow")])
        {
            keyboardWindow = testWindow;
            
            break;
        }
    }
    
    if (keyboardWindow)
    {
        for (UIView *possibleKeyboard in [keyboardWindow subviews])
        {
            if ([possibleKeyboard isKindOfClass: NSClassFromString(@"UIPeripheralHostView")] ||
                [possibleKeyboard isKindOfClass: NSClassFromString(@"UIKeyboard")])
            {
                return possibleKeyboard.frame;
            }
            else if ([possibleKeyboard isKindOfClass: NSClassFromString(@"UIInputSetContainerView")])
            {
                for (UIView *possibleKeyboardSubview in [possibleKeyboard subviews])
                {
                    if ([possibleKeyboardSubview isKindOfClass: NSClassFromString(@"UIInputSetHostView")])
                    {
                        return possibleKeyboardSubview.frame;;
                    }
                }
            }
        }
    }
    
    #endif
    
    return CGRectZero;
}

@end
