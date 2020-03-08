//
//  Dog.h
//  Demo_001
//
//  Created by 张敬 on 2020/3/7.
//  Copyright © 2020 张敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *sex;


/// 字典转模型
/// @param dic 字典
- (instancetype)initWithDic:(NSDictionary *)dic;

/// 模型转字典
/// @param model 模型
- (NSDictionary *)dicWithModel;

- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

NS_ASSUME_NONNULL_END
