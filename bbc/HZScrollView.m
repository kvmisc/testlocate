//
//  HZScrollView.m
//  hzmob
//
//  Created by Kevin Wu on 11/14/14.
//  Copyright (c) 2014 HuiZhuang. All rights reserved.
//

#import "HZScrollView.h"

@implementation HZScrollView

- (id)init
{
    self = [super init];
    if (self) {
        [self initiate];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initiate];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initiate
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)willShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];

    NSValue *keyboardFrame = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [keyboardFrame CGRectValue].size.height;

    NSNumber *keyboardAnimationDuration = [info valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = [keyboardAnimationDuration floatValue];

    NSNumber *keyboardAnimationCurve = [info valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [keyboardAnimationCurve unsignedIntegerValue];


    CGRect containerFrame = [self.window convertRect:self.bounds fromView:self];

    UIView *field = TKFindFirstResponderInView(self);
    CGRect fieldFrame = [self.window convertRect:field.bounds fromView:field];

    CGRect newContainerFrame = containerFrame;
    newContainerFrame.size.height = containerFrame.size.height - keyboardHeight;

    DDLogDebug(@"containerFrame: %@", NSStringFromCGRect(containerFrame));
    DDLogDebug(@"newContainerFrame: %@", NSStringFromCGRect(newContainerFrame));
    DDLogDebug(@"fieldFrame: %@", NSStringFromCGRect(fieldFrame));

    if ( !CGRectContainsRect(newContainerFrame, fieldFrame) ) {
        self.contentInset = TKInsets(0.0, 0.0, keyboardHeight, 0.0);

//        [UIView animateWithDuration:animationDuration
//                              delay:0.0
//                            options:(UIViewAnimationOptions)animationCurve
//                         animations:^{
//                             CGRect frame = [self convertRect:field.bounds fromView:field];
//                             CGPoint offset = CGPointMake(0.0, frame.origin.y + frame.size.height + 10.0 - newContainerFrame.size.height);
//                             self.contentOffset = offset;
////                             CGPoint offset = self.contentOffset;
////                             CGFloat tmp = fieldFrame.origin.y - (newContainerFrame.origin.y + newContainerFrame.size.height - (fieldFrame.size.height+10.0));
////                             offset.y += tmp;
////                             self.contentOffset = offset;
//                         }
//                         completion:^(BOOL finished) {
//                             CGRect frame = [self convertRect:field.bounds fromView:field];
//                             CGPoint offset = CGPointMake(0.0, frame.origin.y + frame.size.height + 10.0 - newContainerFrame.size.height);
//                             self.contentOffset = offset;
//                         }];
    }
}

- (void)willHide:(NSNotification *)notification
{
    NSLog(@"WillHide");

    self.contentInset = UIEdgeInsetsZero;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [TKFindFirstResponderInView(self) resignFirstResponder];
}

@end
