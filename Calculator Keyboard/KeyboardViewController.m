//
//  KeyboardViewController.m
//  Calculator Keyboard
//
//  Created by Jan Timar on 3.5.2015.
//  Copyright (c) 2015 Jan Timar. All rights reserved.
//

#import "KeyboardViewController.h"
#import "JTCalculatorKeyboardView.h"

@interface KeyboardViewController () <CSCalculatorKeyboardDelegate>

@property (nonatomic, strong) UIButton *nextKeyboardButton;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // set Calculator Keyboard View as default View
    UINib *keyboardNib = [UINib nibWithNibName:@"JTCalculatorKeyboardView" bundle:nil];
    
    JTCalculatorKeyboardView *calculatorKeyboardView = [[keyboardNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    [calculatorKeyboardView setFrame:self.view.frame];
    calculatorKeyboardView.delegate = self;
    
    [self.view addSubview:calculatorKeyboardView];
}

-(void)advenceNextKeyboard {
    // show next keyboard
    [self advanceToNextInputMode];
}

@end
