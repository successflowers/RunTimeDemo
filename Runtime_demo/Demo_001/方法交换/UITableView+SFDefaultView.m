//
//  UITableView+SFDefaultView.m
//  Demo_001
//
//  Created by 张敬 on 2020/3/6.
//  Copyright © 2020 张敬. All rights reserved.
//

#import "UITableView+SFDefaultView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITableView (SFDefaultView)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(reloadData));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(sf_reloadData));
        method_exchangeImplementations(originMethod, swizzledMethod);
    });
}

- (void)sf_reloadData{
    [self sf_reloadData];
    [self fillDefaultView];
}

- (void)fillDefaultView{
    id<UITableViewDataSource> dataSource = self.dataSource;
    BOOL isSections = [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)];
    NSInteger sections = isSections ?[dataSource numberOfSectionsInTableView:self] : 1;
    NSInteger rows = 0;
    
    for (NSInteger i = 0; i < sections; i ++) {
        rows = [dataSource tableView:self numberOfRowsInSection:i];
        if (rows >0) {
            self.sfDefaultView.hidden = YES;
        }else{
            if (!self.sfDefaultView) {
                self.sfDefaultView = [SFDefaultView new];
                self.sfDefaultView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                [self addSubview:self.sfDefaultView];
            }else{
                self.sfDefaultView.hidden = NO;
            }
        }
    }
}

//MARK : - Setter & Getter

- (void)setSfDefaultView:(SFDefaultView *)sfDefaultView {
    objc_setAssociatedObject(self, @selector(sfDefaultView), sfDefaultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SFDefaultView *)sfDefaultView {
    return objc_getAssociatedObject(self, @selector(sfDefaultView));
}

@end
