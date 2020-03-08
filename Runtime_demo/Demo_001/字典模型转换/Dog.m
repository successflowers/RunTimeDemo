//
//  Dog.m
//  Demo_001
//
//  Created by 张敬 on 2020/3/7.
//  Copyright © 2020 张敬. All rights reserved.
//

#import "Dog.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Dog

void myMethod(id self, SEL _cmb, NSString *text){
    
    /// >1. 这个是子类，调用父类的方法
    /// >2. 调用父类的方法
    /// >3. 通知观察者
    /// >4. 直接有一个父类的结构体
    /**
     struct objc_super {
         /// Specifies an instance of a class.
         __unsafe_unretained _Nonnull id receiver;

         /// Specifies the particular superclass of the instance to message.
     #if !defined(__cplusplus)  &&  !__OBJC2__
         /* For compatibility with old objc-runtime.h header */
//         __unsafe_unretained _Nonnull Class class;
//     #else
//         __unsafe_unretained _Nonnull Class super_class;
//     #endif
         /* super_class is the first class to search */
   //     };

    struct objc_super superClass = {
        self,
        class_getSuperclass([self class])
    };
    /// >5. 给结构体发送消息
    objc_msgSendSuper(&superClass, _cmb, text);
    /// >6. 获取监听者
    id observer = objc_getAssociatedObject(self, (__bridge const void *)@"objc");
    /// >7. 通知改变
    NSString *methodName = NSStringFromSelector(_cmb);
    NSString *key = getValueKey(methodName);
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:),
                 key, self, @{key: text} ,nil);
}

NSString * getValueKey(NSString *setter){
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    NSString *letter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:letter];
    return key;
}

- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
   
    /// >1. 获取当前类的名字
    NSString *oldName = NSStringFromClass([self class]);
    NSString *newName = [NSString stringWithFormat:@"CustomKVO_%@", oldName];
    /// >2. 创建一个类
    Class customClass = objc_allocateClassPair([self class], newName.UTF8String, 0);
    /// >3. 注册类
    objc_registerClassPair(customClass);
    /// >4. 修改指针的指向
   // object_isClass(customClass);
    object_setClass(self, customClass);
    /// >5. 重写set 方法
    NSString *setterName = [NSString stringWithFormat:@"set%@:", keyPath.capitalizedString];
    SEL sel = NSSelectorFromString(setterName);
    /// >6. 添加方法实现
    class_addMethod(customClass, sel, (IMP)myMethod, "v@:@");
    /// >7. 关联一个属性
    objc_setAssociatedObject(self, (__bridge const void *)@"objc", observer, OBJC_ASSOCIATION_ASSIGN);
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        for (NSString *key in dic.allKeys) {
            id value = dic[key];
            NSString *methodName = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
            SEL sel = NSSelectorFromString(methodName);
            objc_msgSend(self, sel, value);
        }
    }
    return self;
}

- (NSDictionary *)dicWithModel{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (NSInteger i = 0; i < count; i ++) {
        const char * property = property_getName(propertyList[i]);
        NSString *methodName = [[NSString alloc] initWithCString:property encoding:NSUTF8StringEncoding];
        SEL sel = NSSelectorFromString(methodName);
        id value = objc_msgSend(self, sel);
        [dic setValue:value forKey:methodName];
    }
    free(propertyList);
    return dic.copy;
}

@end
