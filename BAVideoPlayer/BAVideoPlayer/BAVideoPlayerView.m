//
//  BAVideoPlayerView.m
//  BAVideoPlayer
//
//  Created by 博爱之家 on 16/5/13.
//  Copyright © 2016年 博爱之家. All rights reserved.
//


#import "BAVideoPlayerView.h"
#import "BAPlayer.h"

@interface BAVideoPlayerView ()

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



@end

@implementation BAVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame WithUrlString:(NSString *)urlString
{
    if (self = [super initWithFrame:frame])
    {
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

#pragma mark - ***** 点击事件
#pragma mark 返回按钮点击事件
- (void)backButtonAction
{
    [self pause];
    if (self.goBackBlock)
    {
        self.goBackBlock();
    }
}

#pragma mark 全屏按钮点击事件

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
}

/*! 播放并判断是否重新加载当前url资源 */
-(void)pause
{
    [self.player pause];
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

    NSLog(@"BAVideoPlayer 销毁了！");
}















































@end
