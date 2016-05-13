
/*!
 *  @header BAKit.h
 *          BABaseProject
 *
 *  @brief  BAKit
 *
 *  @author 博爱
 *  @copyright    Copyright © 2016年 博爱. All rights reserved.
 *  @version    V1.0
 */

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

/*
 
 *********************************************************************************
 *
 * 在使用BAKit的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ     : 可以添加SDAutoLayout群 497140713 在这里找到我(博爱1616【137361770】)
 * 微博    : 博爱1616
 * Email  : 137361770@qq.com
 * GitHub : https://github.com/boai
 * 博客园  : http://www.cnblogs.com/boai/
 * 博客    : http://boai.github.io
 
 *********************************************************************************
 
 */


#import "ViewController.h"
#import "BAPlayer.h"

NSString * const url = @"http://yycloudvod1932283664.26702.bs2.yy.com/djk3NTI2MTI0M2RkNDAzMjJkMWJlNmIzNDI4OWU2NTEwMTI1Njc3Mjcy";
NSString * const url2 = @"http://153.37.232.150/music.qqvideo.tc.qq.com/g0015yn6fuz.mp4?vkey=4782D5E68F7200A9D043C1E839B40D702DB42816A97DAE5C1BCB69DC04F8A0510D1D17818EA31B09F911BF61BC3382064644D21678F3404B06ECA94A5C925A9AE8B5390DFAA3EE9DE3C6940EDE02F84012B234CF77000C2F&amp;br=62618&amp;platform=1&amp;fmt=mp4&amp;level=0&amp;type=mp4";
NSString * const url3 = @"http://7s1sjv.com2.z0.glb.qiniucdn.com/9F76A25D-9509-DEE9-3D8A-E93F360BB0E5.mp4";
NSString * const url4 = @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";


@interface ViewController ()
{
    BAVideoPlayerView *_playerView;
    CGRect playerFrame;
}


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:BAPlayerFullScreenButtonClickedNotification object:nil];
    // 旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatPlayer];
}

- (void)creatPlayer
{
    CGRect frame = CGRectMake(0, 20, BA_SCREEN_WIDTH, 300);
    _playerView = [[BAVideoPlayerView alloc] initWithFrame:frame WithUrlString:url3];
    
    [self.view addSubview:_playerView];
    
    __weak typeof(self) weakSelf = self;
    _playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}

#pragma mark - ***** 通知
- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [_playerView removeFromSuperview];
    _playerView.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        _playerView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        _playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    _playerView.frame = CGRectMake(0, 0, BA_SCREEN_WIDTH, BA_SCREEN_HEIGHT);
    _playerView.playerLayer.frame =  CGRectMake(0,0, BA_SCREEN_HEIGHT,BA_SCREEN_WIDTH);
    
    [_playerView.bottomImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(BA_SCREEN_WIDTH-40);
        make.width.mas_equalTo(BA_SCREEN_HEIGHT);
    }];
    
    [_playerView.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_playerView).with.offset((- BA_SCREEN_HEIGHT/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_playerView).with.offset(20);
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:_playerView];
    _playerView.fullScreenBtn.selected = YES;
    [_playerView bringSubviewToFront:_playerView.bottomImageView];
    
}

- (void)toNormal
{
    [_playerView removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        _playerView.transform = CGAffineTransformIdentity;
        _playerView.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        _playerView.playerLayer.frame =  _playerView.bounds;
        [self.view addSubview:_playerView];
        [_playerView.bottomImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_playerView).with.offset(0);
            make.right.equalTo(_playerView).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(_playerView).with.offset(0);
        }];
        [_playerView.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_playerView).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(_playerView).with.offset(20);
        }];
        
    }completion:^(BOOL finished) {
        _playerView.isFullScreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        _playerView.fullScreenBtn.selected = NO;
        
    }];
}

- (void)fullScreenBtnClick:(NSNotification *)notice
{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        _playerView.isFullScreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}


#pragma mark 旋转屏幕通知
- (void)onDeviceOrientationChange
{
    if (_playerView==nil || _playerView.superview==nil)
    {
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (_playerView.isFullScreen) {
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (_playerView.isFullScreen == NO) {
                _playerView.isFullScreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (_playerView.isFullScreen == NO) {
                _playerView.isFullScreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}


@end
