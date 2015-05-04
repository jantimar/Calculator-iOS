//
//  JTCalculatorBrain.h
//  Calculator
//
//  Created by Jan Timar on 30.4.2015.
//  Copyright (c) 2015 Jan Timar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTCalculatorBrain : NSObject

-(void)pushOperand:(float)operand;

-(float)pushBinaryOperation:(NSString *)operation;

-(float)pushUnaryOperation:(NSString *)operation;

-(float)executeCalculation;

@end
