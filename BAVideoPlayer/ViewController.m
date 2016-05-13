//
//  ViewController.m
//  BAVideoPlayer
//
//  Created by 博爱之家 on 16/5/13.
//  Copyright © 2016年 博爱之家. All rights reserved.
//


#import "ViewController.h"
#import "BAPlayer.h"

NSString * const url = @"http://yycloudvod1932283664.26702.bs2.yy.com/djk3NTI2MTI0M2RkNDAzMjJkMWJlNmIzNDI4OWU2NTEwMTI1Njc3Mjcy";
NSString * const url2 = @"http://153.37.232.150/music.qqvideo.tc.qq.com/g0015yn6fuz.mp4?vkey=4782D5E68F7200A9D043C1E839B40D702DB42816A97DAE5C1BCB69DC04F8A0510D1D17818EA31B09F911BF61BC3382064644D21678F3404B06ECA94A5C925A9AE8B5390DFAA3EE9DE3C6940EDE02F84012B234CF77000C2F&amp;br=62618&amp;platform=1&amp;fmt=mp4&amp;level=0&amp;type=mp4";
NSString * const url3 = @"http://7s1sjv.com2.z0.glb.qiniucdn.com/9F76A25D-9509-DEE9-3D8A-E93F360BB0E5.mp4";
NSString * const url4 = @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatPlayer];
}

- (void)creatPlayer
{
    CGRect frame = CGRectMake(0, 20, BA_SCREEN_WIDTH, 300);
    BAVideoPlayerView *playerView = [[BAVideoPlayerView alloc] initWithFrame:frame WithUrlString:url3];
    
    [self.view addSubview:playerView];
    
    __weak typeof(self) weakSelf = self;
    playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}

@end
