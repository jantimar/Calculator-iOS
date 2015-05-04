//
//  JTCalculatorView.m
//  Calculator
//
//  Created by Jan Timar on 30.4.2015.
//  Copyright (c) 2015 Jan Timar. All rights reserved.
//

#import "JTCalculatorView.h"

#import "JTCalculatorBrain.h"

#define ANIMATION_DURATION 0.5f

@interface JTCalculatorView ()

@property(nonatomic,weak) IBOutlet UILabel *displayLabel;

@property(nonatomic,strong) JTCalculatorBrain *calculatorBrain;

@property(nonatomic) BOOL isFloatingNumber;

enum {
    kWritingOperand,
    kOperationAccepted,
    kShowingResult
} typedef CalculatorState;

@property(nonatomic) CalculatorState calculatorState;

@end

@implementation JTCalculatorView

#pragma mark setters and getters

-(JTCalculatorBrain *)calculatorBrain {
    if(!_calculatorBrain) _calculatorBrain = [[JTCalculatorBrain alloc] init];
    return _calculatorBrain;
}

#pragma mark buttons method

- (IBAction)numberButtonPress:(UIButton *)sender {
    if(self.calculatorState != kWritingOperand)
        self.displayLabel.text = @"";
    
    // dont start number with 0
    if([self.displayLabel.text isEqual:@"0"]) self.displayLabel.text = @"";
    // dont start number with -0
    else if([self.displayLabel.text isEqual:@"-0"]) self.displayLabel.text = @"-";
    
    // append digit
    [self showOnDisplayText:[self.displayLabel.text stringByAppendingString:[sender titleForState:UIControlStateNormal]]];
    
    self.calculatorState = kWritingOperand;
}

- (IBAction)clearButtonPress:(UIButton *)sender {
    [self showOnDisplayText:@"0"];
    self.calculatorBrain = nil;
    self.isFloatingNumber = NO;
}

- (IBAction)commaButtonPress:(UIButton *)sender {
    if(!self.isFloatingNumber) {
        [self showOnDisplayText:[self.displayLabel.text stringByAppendingString:@"."]];
    }
}

- (IBAction)signChangeButtonPress:(UIButton *)sender {
    if([self.displayLabel.text hasPrefix:@"-"])
        [self showOnDisplayText:[self.displayLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    else
        [self showOnDisplayText:[NSString stringWithFormat:@"-%@",self.displayLabel.text]];
}

- (IBAction)operationButtonPress:(UIButton *)sender {
    if(self.calculatorState != kOperationAccepted)    // override actual operation, dont push operand
        [self.calculatorBrain pushOperand:[self.displayLabel.text floatValue]];
    
    // execute on background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self showOnDisplay:[self.calculatorBrain pushBinaryOperation:[sender titleForState:UIControlStateNormal]]];
    });
    
    self.calculatorState = kOperationAccepted;
}

- (IBAction)operationBinaryButtonPress:(UIButton *)sender {
    if(self.calculatorState != kOperationAccepted)    // override actual operation, dont push operand
        [self.calculatorBrain pushOperand:[self.displayLabel.text floatValue]];
    
    // execute on background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self showOnDisplay:[self.calculatorBrain pushUnaryOperation:[sender titleForState:UIControlStateNormal]]];
    });
    
    self.calculatorState = kOperationAccepted;
}

// press =
- (IBAction)executeCalculation:(UIButton *)sender {
    [self.calculatorBrain pushOperand:[self.displayLabel.text floatValue]];
    
    // execute on background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self showOnDisplay:[self.calculatorBrain executeCalculation]];
    });
    
    self.calculatorState = kShowingResult;
}

#pragma mark update display text

-(void)showOnDisplay:(float)number {
    [self showOnDisplayText:[NSString stringWithFormat:@"%g",number]];
}

-(void)showOnDisplayText:(NSString *)text {
    // update display in main  quee
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.displayLabel duration:ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            self.displayLabel.text = text;
        } completion:^(BOOL finished) {
            self.isFloatingNumber = [self.displayLabel.text containsString:@"."];   // check if result is float, better way as check if absolute value is equal float value
        }];
    });
}

@end
