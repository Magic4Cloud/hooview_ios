//
//  UISearchBar+Extension.m
//  wuyuexin
//
//  Created by 万显武 on 17/5/23.
//  Copyright © 2017年 even. All rights reserved.
//

#import "UISearchBar+Extension.h"
#import <objc/runtime.h>

@implementation UISearchBar (Extension)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}


+ (void)load {
    [self exchangeInstanceMethod1:@selector(lj_becomeFirstResponder) method2:@selector(becomeFirstResponder)];
}

- (void)lj_becomeFirstResponder {
    [self lj_becomeFirstResponder];
    [self targetResponder];
}



- (void)targetResponder {
    
}

@end
