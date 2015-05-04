//
//  JTCalculatorKeyboardView.h
//  Calculator
//
//  Created by Jan Timar on 3.5.2015.
//  Copyright (c) 2015 Jan Timar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSCalculatorKeyboardDelegate

// for show next keyboard
-(void)advenceNextKeyboard;

@end

@interface JTCalculatorKeyboardView : UIView

@property(nonatomic,weak) id<CSCalculatorKeyboardDelegate> delegate;

@end
