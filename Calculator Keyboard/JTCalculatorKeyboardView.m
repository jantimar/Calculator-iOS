//
//  JTCalculatorKeyboardView.m
//  Calculator
//
//  Created by Jan Timar on 3.5.2015.
//  Copyright (c) 2015 Jan Timar. All rights reserved.
//

#import "JTCalculatorKeyboardView.h"

@implementation JTCalculatorKeyboardView

- (IBAction)globeButtonPress:(id)sender {
    [self.delegate advenceNextKeyboard];
}

@end
