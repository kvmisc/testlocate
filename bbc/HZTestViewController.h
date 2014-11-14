//
//  HZTestViewController.h
//  hzmob
//
//  Created by Kevin Wu on 11/14/14.
//  Copyright (c) 2014 HuiZhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZScrollView.h"

@interface HZTestViewController : HZViewController<
    UITextFieldDelegate
> {
    HZScrollView *_scrollView;

    UITextField *_textField1;

    UIView *_box2;
    UITextField *_textField2;

    UIView *_box3;
    UITextField *_textField3;
}

@end
