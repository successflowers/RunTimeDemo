//
//  ViewController.m
//  Demo_001
//
//  Created by 张敬 on 2020/3/6.
//  Copyright © 2020 张敬. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+SFDefaultView.h"
#import "Person.h"
#import "Dog.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSArray * mArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Dog *d1 = [Dog new];
    Dog *d2 = [Dog new];
    d2.name = @"123";
    
    NSLog(@"监听之前 p1: %p  p2 : %p",
          [d1 methodForSelector:@selector(setName:)],
          [d2 methodForSelector:@selector(setName:)]);
    
//    [d1 sf_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [d1 sf_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    
    NSLog(@"监听之后 p1: %p  p2 : %p",
          [d1 methodForSelector:@selector(setName:)],
          [d2 methodForSelector:@selector(setName:)]);
    d1.name = @"aaa";
    d1.name = @"bbb"; 
    
//    Dog *d = [Dog new];
//    d.name = @"wangwei";
//    d.age = @"12";
//    d.sex = @"woman";
//    NSDictionary *dic = [d dicWithModel];
//    NSLog(@"_______   %@", dic);
    
    //[self.view addSubview:self.mTableView];
    
   //objc_msgSend([Person new], @selector(sendMessage:), @"hello world");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"change = %@", change);
}

//MARK : - 代理 & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.mArray[indexPath.row];
    return cell;
}

//MARK : - Setter & Getter

- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mTableView.dataSource = self;
        [_mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _mTableView;
}

- (NSArray *)mArray{
    if (!_mArray) {
        //_mArray = @[@"success", @"flower"];
        _mArray = @[];

    }
    return _mArray;
}
@end
