//
//  ViewController.m
//  MemoryManagement
//
//  Created by Vishwan Aranha on 5/26/13.
//  Copyright © 2013 Vishwan Aranha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *lbl = [[UILabel alloc] init];
    
    [self.view addSubview:lbl];
    
        
    NSArray *arr = [[NSArray alloc] init];
    //300 line of code
    
    
    NSLog(@"%@",lbl);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
