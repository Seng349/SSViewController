//
//  KETAlertViewController.h
//  TestWindow
//
//  Created by Seng349 on 15/12/13.
//  Copyright © 2015年 Banana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSViewController : UIViewController

/**
 *  default duration to 0.3
 *  default timeFunctionName to kCAMediaTimingFunctionEaseInEaseOut
 *  default anmation type to 'fade'
 *  default anmation subType to kCATransitionFromRight
 *  default fillMode to kCAFillModeRemoved
 *  default removedOnCompletion to YES
 */
@property (copy) CAAnimation* showAnimation;

/**
 *  default duration to 0.3
 *  default timeFunctionName to kCAMediaTimingFunctionEaseInEaseOut
 *  default anmation type to 'fade'
 *  default anmation subType to kCATransitionFromRight
 *  default fillMode to kCAFillModeRemoved
 *  default removedOnCompletion to YES
 */
@property (copy) CAAnimation* hideAnimation;

@property(nonatomic) UIWindowLevel windowLevel;                   // default = 0.0

/**
 * This method will add self.view to a new UIWindow */
- (void)show:(BOOL)animted completion:(void(^)(BOOL finished))completion;

/**
 * This method will let self.view remove from superView  */
- (void)hide:(BOOL)animted completion:(void(^)(BOOL finished))completion;


@end
