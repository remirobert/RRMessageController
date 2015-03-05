//
//  ViewController.m
//  SendMessageController
//
//  Created by Remi Robert on 17/11/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import "ViewController.h"
#import "RRSendMessageViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UITextView *message;
@end

@implementation ViewController

- (void) newMessage {
    RRSendMessageViewController *controller = [[RRSendMessageViewController alloc] init];
    
    [controller presentController:self blockCompletion:^(RRMessageModel *model, BOOL isCancel) {
        if (isCancel == true) {
            self.message.text = @"";
        }
        else {
            self.message.text = model.text;
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.message = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width,
                                                                self.view.frame.size.width / 2)];
    self.message.editable = false;
    self.message.backgroundColor = [UIColor colorWithWhite:0.500 alpha:1.000];
    
    [self.view addSubview:self.message];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 50,
                                                                      self.view.frame.size.width, 50)];
    
    [sendButton setTitle:@"new message" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(newMessage) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
