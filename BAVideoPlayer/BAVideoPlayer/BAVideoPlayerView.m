
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

#import "BAVideoPlayerView.h"
#import "BAPlayer.h"

@interface BAVideoPlayerView ()
<
    UIGestureRecognizerDelegate
>
{
    CGRect BA_selfFrame;
    NSDateFormatter *_dateFormatter;
    BOOL _played;//播放状态
    BOOL _isLockScreen;//是否锁屏
    //长按手势起点
    CGPoint longPressBeginPoint;
    //长按手势移动是的位置  包括运动中和结束点
    CGPoint longPressMovePoint;
    NSArray *_screenType;
    NSInteger _index ;
    float _btnHeight;
    CGFloat _cachDuration;
    CGFloat _playerVolume;//播放的声音
    CGFloat _lastPanLocation;
}

/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                 *playOrPauseBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                  *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                  *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView           *progressView;
/** 滑杆 */
@property (nonatomic, strong) UISlider                 *progressSlider;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                 *fullScreenBtn;
/** 快进快退label */
@property (nonatomic, strong) UILabel                  *horizontalLabel;
/** 系统菊花 */
@property (nonatomic, strong) UIActivityIndicatorView  *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                 *backBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                 *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView              *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView              *topImageView;


@property (nonatomic,strong ) NSTimer                  *playViewTimer;

@property (nonatomic,strong ) UITapGestureRecognizer   *playViewSingleTap;
@property (nonatomic,strong ) UITapGestureRecognizer   *playviewDoubleTap;
@property (nonatomic,strong ) MPVolumeView             *volumeView;


@end

@implementation BAVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame WithUrlString:(NSString *)urlString
{
    if (self = [super initWithFrame:frame])
    {
        BA_selfFrame = frame;
        self.videoURL = [NSURL URLWithString:urlString];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:self.playerLayer];

        [self play];

    
        /*! 设置上下View */
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.topImageView];
    [self addSubview:self.bottomImageView];
    [self.bottomImageView addSubview:self.playOrPauseBtn];
    [self.bottomImageView addSubview:self.currentTimeLabel];
    [self.bottomImageView addSubview:self.progressView];
    [self.bottomImageView addSubview:self.progressSlider];
    [self.bottomImageView addSubview:self.fullScreenBtn];
    [self.bottomImageView addSubview:self.totalTimeLabel];
    
    [self addSubview:self.backBtn];
    [self addSubview:self.activity];
    [self addSubview:self.repeatBtn];
    [self addSubview:self.horizontalLabel];
    
    /*! 添加手势 */
    [self addGestures];
    
    // 添加子控件的约束
    [self makeSubViewsConstraints];
    [self.activity stopAnimating];
    // 初始化时重置controlView
    [self resetControlView];
    
    [self addNotifications];
}

#pragma mark - ***** 懒加载控制栏View
#pragma mark 懒加载控制栏View
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.showsTouchWhenHighlighted = YES;
        [_backBtn setImage:[UIImage imageNamed:BA_VideoSrcName(@"返回")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"返回")] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = [UIImage imageNamed:BA_VideoSrcName(@"top_shadow")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"top_shadow")];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = [UIImage imageNamed:BA_VideoSrcName(@"bottom_shadow")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"bottom_shadow")];
    }
    return _bottomImageView;
}

- (UIButton *)playOrPauseBtn
{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseBtn.showsTouchWhenHighlighted = YES;
        [self.playOrPauseBtn setImage:[UIImage imageNamed:BA_VideoSrcName(@"play")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"play")] forState:UIControlStateNormal];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:BA_VideoSrcName(@"pause")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"pause")] forState:UIControlStateSelected];
        self.playOrPauseBtn.selected = YES;
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider                       = [[UISlider alloc] init];
        // 设置slider
        [_progressSlider setThumbImage:[UIImage imageNamed:BA_VideoSrcName(@"dot")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"dot")] forState:UIControlStateNormal];
        
        _progressSlider.minimumTrackTintColor = [UIColor whiteColor];
        _progressSlider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
    }
    return _progressSlider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenBtn.showsTouchWhenHighlighted = YES;
        [_fullScreenBtn setImage:[UIImage imageNamed:BA_VideoSrcName(@"fullscreen")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"fullscreen")] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:BA_VideoSrcName(@"nonfullscreen")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"nonfullscreen")] forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

- (UILabel *)horizontalLabel
{
    if (!_horizontalLabel) {
        _horizontalLabel                 = [[UILabel alloc] init];
        _horizontalLabel.textColor       = [UIColor whiteColor];
        _horizontalLabel.textAlignment   = NSTextAlignmentCenter;
        // 设置快进快退label
        _horizontalLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BA_VideoSrcName(@"Management_Mask")] ?: [UIImage imageNamed:BA_VideoFrameworkSrcName(@"Management_Mask")]];
    }
    return _horizontalLabel;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activity;
}

- (void)makeSubViewsConstraints
{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(80);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playOrPauseBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-0.25);
    }];
    
    [self.horizontalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
        make.center.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}


#pragma mark 懒加载player
- (AVPlayerItem *)playerItem
{
    if (!_playerItem)
    {
        _playerItem =[AVPlayerItem playerItemWithURL:self.videoURL];
    }
    return _playerItem;
}

- (AVPlayer *)player{
    if (!_player) {
        _player =[AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}

- (NSTimer *)playViewTimer
{
    if (!_playViewTimer)
    {
        _playViewTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hiddenConsolen) userInfo:nil repeats:NO];
    }
    return _playViewTimer;
}

- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer)
    {
        _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
    }
    return _playerLayer;
}

- (UITapGestureRecognizer *)playViewSingleTap
{
    if (!_playViewSingleTap)
    {
        _playViewSingleTap = [[UITapGestureRecognizer alloc] init];
        _playViewSingleTap.delegate = self;
    }
    return _playViewSingleTap;
}

- (UITapGestureRecognizer *)playviewDoubleTap
{
    if (!_playviewDoubleTap)
    {
        _playviewDoubleTap = [[UITapGestureRecognizer alloc] init];
        _playviewDoubleTap.numberOfTapsRequired = 2;
        _playviewDoubleTap.delegate = self;
    }
    return _playviewDoubleTap;
}

#pragma mark - ***** 通知以及点击事件
- (void)addNotifications
{
    /*! 播放按钮点击事件 */
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    /*! 返回按钮点击事件 */
    [self.backBtn addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    /*! 全屏按钮点击事件 */
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    
    /*! app退到后台 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    /*! app进入前台 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    


}

#pragma mark - ***** 添加手势
- (void)addGestures
{
    //添加声音控制器
    self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-2000,-1000, BA_SCREEN_WIDTH, 100)];
    self.volumeView.hidden = YES;
    [self addSubview:self.volumeView];
    
    [self addGestureRecognizer:self.playViewSingleTap];
    [self addGestureRecognizer:self.playviewDoubleTap];
    /*! 单击手势 */
    [self.playViewSingleTap addTarget:self action:@selector(playerSingleTap:)];
    /*! 双击手势 */
    [self.playviewDoubleTap addTarget:self action:@selector(playerDoubleTap)];
    
    
    //滑动手势 拖动手势
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureChangeProgress:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureChangeProgress:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    UIPanGestureRecognizer *movePanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movePanGestureRecognizer:)];
    [movePanGesture requireGestureRecognizerToFail:leftSwipeGesture];
    [movePanGesture requireGestureRecognizerToFail:rightSwipeGesture];
    [self.playViewSingleTap requireGestureRecognizerToFail:self.playviewDoubleTap]; //防止：双击被单击拦截
    [self addGestureRecognizer:leftSwipeGesture];
    [self addGestureRecognizer:rightSwipeGesture];
    [self addGestureRecognizer:movePanGesture];
}

#pragma mark - ***** 响应手势
#pragma mark 拖动手势控制音量和亮度
- (void)swipeGestureChangeProgress:(UISwipeGestureRecognizer *)swipeGesture{
    
    __weak typeof(self) weakSelf = self;
    switch (swipeGesture.direction) {
            //right 1
        case UISwipeGestureRecognizerDirectionRight:
        {
            
            [self.player pause];
            CMTime currenTime = self.playerItem.currentTime;
            CGFloat currenSecond = (CGFloat)currenTime.value/currenTime.timescale;
            CGFloat reachSecond = MIN(_cachDuration, currenSecond+7.0);
            [weakSelf.player pause];
            [self.playerItem seekToTime:CMTimeMake(reachSecond, 1)  completionHandler:^(BOOL finished) {
                [weakSelf.player play];
                //                CMTime currenTime = self.playerItem.currentTime;
                //                CGFloat currenSecond = (CGFloat)currenTime.value/currenTime.timescale;
                
            }];
        }
            break;
            //left 2
        case UISwipeGestureRecognizerDirectionLeft:
        {
            CMTime currenTime = self.playerItem.currentTime;
            CGFloat currenSecond = (CGFloat)currenTime.value/currenTime.timescale;
            
            NSLog(@"  left1 currenSecond :%f cach :%f",currenSecond,_cachDuration);
            if (currenSecond>7.0) {
                [weakSelf.player pause];
                [self.playerItem seekToTime:CMTimeMake((currenSecond-7.0), 1)  completionHandler:^(BOOL finished)
                 {
                     [weakSelf.player play];
                     NSLog(@"  left2 currenSecond :%f cach :%f",currenSecond,_cachDuration);
                 }];
            }
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 拖动手势控制音量和亮度
- (void)movePanGestureRecognizer:(UIPanGestureRecognizer*)panGesture
{
    CGFloat bright = [UIScreen mainScreen].brightness;
    _playerVolume = 0;
    if (panGesture.state==UIGestureRecognizerStateBegan)
    {
        longPressBeginPoint = [panGesture locationInView:self];
    }
    else
    {
        longPressMovePoint = [panGesture locationInView:self];
    }
    
    if ([panGesture locationInView:self].x > BA_SCREEN_WIDTH/2)
    {
        //调节声音
        UISlider* volumeViewSlider = nil;
        for (UIView *view in [self.volumeView subviews])
        {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"])
            {
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        _playerVolume += (longPressBeginPoint.y-longPressMovePoint.y)/(BA_selfFrame.size.height * 3);
        volumeViewSlider.value += _playerVolume;
        NSLog(@"声音调节 %ld--volume:%f",panGesture.state,volumeViewSlider.value);
    }
    else
    {
        bright+= (longPressBeginPoint.y-longPressMovePoint.y)/(self.frame.size.height * 3);
        [[UIScreen mainScreen] setBrightness: bright];
    }
}
/**
 *  双击
 */
- (void)playerDoubleTap
{
    if (self.isPlaying)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

/**
 *  单击事件 ->显示控制条 启动定时器隐藏控制条
 */

- (void)playerSingleTap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"playerSingleTap");
}

#pragma mark - ***** 点击事件
#pragma mark 返回按钮点击事件
- (void)backButtonAction
{
    [self pause];
    if (self.goBackBlock)
    {
        self.goBackBlock();
    }
    /*! 设置竖屏 */
    [UIDevice setOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark 全屏按钮点击事件
- (void)fullScreenAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [self play];
    }
    else
    {
        [self pause];
    };

}

#pragma mark 播放暂停按钮
- (void)playPauseBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [self play];
    }
    else
    {
        [self pause];
    };
}

#pragma mark 应用退到后台

- (void)appDidEnterBackground
{
    [self pause];
}

#pragma mark 应用进入前台
- (void)appDidEnterPlayGround
{
    if (self.player)
    {
        [self play];
    }
}






#pragma mark - ***** 播放功能
/*! 播放并判断是否重新加载当前url资源 */
- (void)play
{
    [self.player play];
    self.playOrPauseBtn.selected = YES;
    self.isPlaying = YES;
}

/*! 播放并判断是否重新加载当前url资源 */
-(void)pause
{
    [self.player pause];
    self.playOrPauseBtn.selected = NO;
    self.isPlaying = NO;
}

/*! 关闭播放器并销毁当前播放view, 一定要在退出时使用,否则内存可能释放不了 */
-(void)close
{
    
    
}

#pragma mark - ***** 时间设置



#pragma mark - ***** KVO监测



/** 重置ControlView */
- (void)resetControlView
{
    self.progressSlider.value      = 0;
    self.progressView.progress  = 0;
    self.currentTimeLabel.text  = @"00:00";
    self.totalTimeLabel.text    = @"00:00";
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden       = YES;
    self.backgroundColor        = [UIColor clearColor];
}

- (void)resetControlViewForResolution
{
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden       = YES;
    self.backgroundColor        = [UIColor clearColor];
}

- (void)showControlView
{
    self.topImageView.alpha    = 1;
    self.bottomImageView.alpha = 1;
}

- (void)hideControlView
{
    self.topImageView.alpha    = 0;
    self.bottomImageView.alpha = 0;
}


#pragma mark - ***** dealloc
- (void)dealloc
{
    [BA_Noti removeObserver:self];
    NSLog(@"BAVideoPlayer 销毁了！");
}















































@end
