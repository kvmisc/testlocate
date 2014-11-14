//
//  HZTestViewController.m
//  hzmob
//
//  Created by Kevin Wu on 11/14/14.
//  Copyright (c) 2014 HuiZhuang. All rights reserved.
//

#import "HZTestViewController.h"

@implementation HZTestViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_navigationView showBackButton];
    [_navigationView showRightButton];
    _navigationView.rightButton.normalTitle = @"Doit";

    _scrollView = [[HZScrollView alloc] init];
    [_contentView addSubview:_scrollView];

    _textField1 = [[UITextField alloc] init];
    _textField1.backgroundColor = [UIColor lightGrayColor];
    _textField1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField1.returnKeyType = UIReturnKeyNext;
    _textField1.delegate = self;
    [_scrollView addSubview:_textField1];


    _box2 = [[UIView alloc] init];
    _box2.backgroundColor = [UIColor darkGrayColor];
    [_scrollView addSubview:_box2];

    _textField2 = [[UITextField alloc] init];
    _textField2.backgroundColor = [UIColor lightGrayColor];
    _textField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField2.returnKeyType = UIReturnKeyNext;
    _textField2.delegate = self;
    [_box2 addSubview:_textField2];


    _box3 = [[UIView alloc] init];
    _box3.backgroundColor = [UIColor darkGrayColor];
    [_scrollView addSubview:_box3];

    _textField3 = [[UITextField alloc] init];
    _textField3.backgroundColor = [UIColor lightGrayColor];
    _textField3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField3.returnKeyType = UIReturnKeyDone;
    _textField3.delegate = self;
    [_box3 addSubview:_textField3];
}

- (void)layoutViews
{
    [super layoutViews];

    _scrollView.frame = _contentView.bounds;
    [_scrollView makeVerticalScrollable];

    _box3.frame = CGRectMake(10.0, _contentView.height-70.0, _contentView.width-20.0, 60.0);
    _textField3.frame = CGRectMake(10.0, 10.0, 280.0, 40.0);

    _box2.frame = CGRectMake(10.0, _box3.topY-70.0, _contentView.width-20.0, 60.0);
    _textField2.frame = CGRectMake(10.0, 10.0, 280.0, 40.0);

    _textField1.frame = CGRectMake(10.0, 10.0, _contentView.width-20.0, 40.0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField==_textField1 ) {
        //[_textField1 resignFirstResponder];
        [_textField2 becomeFirstResponder];
    } else if ( textField==_textField2 ) {
        //[_textField2 resignFirstResponder];
        [_textField3 becomeFirstResponder];
    }if ( textField==_textField3 ) {
        [_textField3 resignFirstResponder];
    }
    return YES;
}

- (void)rightButtonClicked:(id)sender
{
//    NSLog(@"%@", NSStringFromCGSize(_tableView.contentSize));
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithClass:[UITableViewCell class]];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
//    return cell;
//}

@end
