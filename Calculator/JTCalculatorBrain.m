//
//  JTCalculatorBrain.m
//  Calculator
//
//  Created by Jan Timar on 30.4.2015.
//  Copyright (c) 2015 Jan Timar. All rights reserved.
//

#import "JTCalculatorBrain.h"

@interface JTCalculatorBrain ()

@property(nonatomic,strong) NSMutableArray *opsMutableArray; // operands and operations

@property(nonatomic) BOOL waitingForOperand;

@end

@implementation JTCalculatorBrain

#pragma mark setters and getters

-(NSMutableArray *)opsMutableArray {
    if(!_opsMutableArray) _opsMutableArray = [[NSMutableArray alloc] init];
    return _opsMutableArray;
}

#pragma mark calculator methods

-(void)pushOperand:(float)operand {
    self.waitingForOperand = YES;
    [self.opsMutableArray addObject:[NSNumber numberWithFloat:operand]];
    
    
}

-(float)pushBinaryOperation:(NSString *)operation {
    if(self.waitingForOperand) {
        self.waitingForOperand = NO;
        [self.opsMutableArray addObject:operation];
    } else
        [self.opsMutableArray setObject:operation atIndexedSubscript:[self.opsMutableArray count]-1];   // replace last operand
    
    
    NSLog(@"OPS ARRAY %@",self.opsMutableArray);
    NSMutableArray *opsCopy = [[NSMutableArray alloc] initWithArray:self.opsMutableArray];
    [self executeCalculationWithOps:opsCopy];
    return [[opsCopy firstObject] floatValue];
}

-(float)pushUnaryOperation:(NSString *)operation {
    // execute unary operation immadiatly
    id operand1 = [self.opsMutableArray lastObject];
    if([operand1 isKindOfClass:[NSNumber class]]) {
        NSNumber *result;
        
        if([operation isEqualToString:@"√"])
            result = [NSNumber numberWithFloat:sqrtf([operand1 floatValue])];
        
        // check if result is seted
        if(result)
            [self.opsMutableArray setObject:result atIndexedSubscript:self.opsMutableArray.count-1];
    }
    
    NSLog(@"OPS ARRAY %@",self.opsMutableArray);
    NSMutableArray *opsCopy = [[NSMutableArray alloc] initWithArray:self.opsMutableArray];
    [self executeCalculationWithOps:opsCopy];
    return [[opsCopy firstObject] floatValue];
}

-(void)executeCalculationWithOps:(NSMutableArray *)ops {
    for(id op in ops){
        if([op isKindOfClass:[NSString class]]) {
            if(([ops containsObject:@"✕"] || [ops containsObject:@"÷"]) && !([op isEqualToString:@"✕"] || [op isEqualToString:@"÷"]))
                continue; // first execute multiple and divide operation
            
            NSUInteger opIndex = [ops indexOfObject:op];
            if(opIndex == 0 || opIndex == ops.count-1) continue;    //
            
            id operand1 = [ops objectAtIndex:opIndex-1];
            id operand2 = [ops objectAtIndex:opIndex+1];
            NSLog(@"OPERATION %@",op);
            NSLog(@"OPERAND1 %@",operand1);
            NSLog(@"OPERAND2 %@",operand2);
            if([operand1 isKindOfClass:[NSNumber class]] && [operand2 isKindOfClass:[NSNumber class]]) {
                [ops removeObjectsInArray:@[op,operand2]];  // remove executed operand2 and operation, operand1 is replaced
                [ops setObject:[self executeOperation:op withOperand:operand1 and:operand2] atIndexedSubscript:opIndex-1];
                [self executeCalculationWithOps:ops];
                break;
            }
        }
    }
}

-(NSNumber *)executeOperation:(NSString *)operation withOperand:(NSNumber *)operand1 and:(NSNumber *)operand2 {
    if([operation isEqualToString:@"✕"]) return [NSNumber numberWithFloat:[operand1 floatValue] * [operand2 floatValue]];
    else if([operation isEqualToString:@"-"]) return [NSNumber numberWithFloat:[operand1 floatValue] - [operand2 floatValue]];
    else if([operation isEqualToString:@"÷"]) return [NSNumber numberWithFloat:[operand1 floatValue] / [operand2 floatValue]];
    else if([operation isEqualToString:@"+"]) return [NSNumber numberWithFloat:[operand1 floatValue] + [operand2 floatValue]];
    else return [NSNumber numberWithFloat:0.0f];
}

-(float)executeCalculation {
    NSLog(@"1OPS COUNT %@",self.opsMutableArray);
    [self executeCalculationWithOps:self.opsMutableArray];
    NSLog(@"2OPS COUNT %@",self.opsMutableArray);
    float result = [[self.opsMutableArray firstObject] floatValue];
    [self.opsMutableArray removeAllObjects];
    return result;
}

@end
