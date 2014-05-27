//
//  ViewController.m
//  05-MiniNav
//
//  Created by Arnaud Leclaire on 27/05/2014.
//  Copyright (c) 2014 GromiNet. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    vue = [[myView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[self setView:vue];
    [[self view] addSubview:vue];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [vue setFromOrientation:toInterfaceOrientation];
}
@end
