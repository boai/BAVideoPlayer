//
//  BAVideoPlayerView.h
//  BAVideoPlayer
//
//  Created by 博爱之家 on 16/5/13.
//  Copyright © 2016年 博爱之家. All rights reserved.
//


#import <UIKit/UIKit.h>


/*! 播放器的几种状态 */
typedef NS_ENUM(NSInteger, BAPlayerState) {
    BAPlayerStateFailed,     // 播放失败
    BAPlayerStateBuffering,  // 缓冲中
    BAPlayerStatePlaying,    // 播放中
    BAPlayerStateStopped,    // 停止播放
    BAPlayerStatePause       // 暂停播放
};

/*! 返回按钮的block */
typedef void(^BAPlayerGoBackBlock)(void);

@import MediaPlayer;
@import AVFoundation;
@interface BAVideoPlayerView : UIView

@property (nonatomic ,strong) AVPlayer             *player;
@property (nonatomic ,strong) AVPlayerItem         *playerItem;
@property (nonatomic,strong ) AVPlayerLayer        *playerLayer;
/** 视频URL */
@property (nonatomic, strong) NSURL                *videoURL;
@property (nonatomic, assign) BOOL                  isFullScreen;
/*! 返回按钮Block */
@property (nonatomic, copy  ) BAPlayerGoBackBlock   goBackBlock;



/*! 播放并判断是否重新加载当前url资源 */
- (void)play;

/*! 播放并判断是否重新加载当前url资源 */
-(void)pause;

/*! 关闭播放器并销毁当前播放view, 一定要在退出时使用,否则内存可能释放不了 */
-(void)close;

- (instancetype)initWithFrame:(CGRect)frame WithUrlString:(NSString *)urlString;

@end
