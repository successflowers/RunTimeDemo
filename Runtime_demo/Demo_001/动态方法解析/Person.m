//
//  Person.m
//  Demo_001
//
//  Created by 张敬 on 2020/3/6.
//  Copyright © 2020 张敬. All rights reserved.
//

#import "Person.h"
#import "Student.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Person

//- (void)sendMessage:(NSString *)text {
//    NSLog(@"原始方法 %@", text);
//}

//MARK : - 动态方法解析
void sendMyMessage(id self, SEL _cmb, NSString *text){
    NSLog(@"动态解析方法 %@", text);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
//    NSString *methodName = NSStringFromSelector(sel);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//        return class_addMethod(self, sel, (IMP)sendMyMessage, "v@:@");
//    }
    return [super resolveInstanceMethod:sel];
}

//MARK : - 快速转发
- (id)forwardingTargetForSelector:(SEL)aSelector{
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//        return [Student new];
//    }
    return [super forwardingTargetForSelector:aSelector];
}

//MARK : - 慢速转发
/// >1. 方法签名
/// >2. 动态解析
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([methodName isEqualToString:@"sendMessage:"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    SEL sel = anInvocation.selector;
//    Student *s = [Student new];
//    if ([s respondsToSelector:sel]) {
//        [anInvocation invokeWithTarget:s];
//    }else{
//        [super forwardInvocation:anInvocation];
//    }
    
    [super forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"没有此方法, %@", NSStringFromSelector(aSelector));
}

@end
