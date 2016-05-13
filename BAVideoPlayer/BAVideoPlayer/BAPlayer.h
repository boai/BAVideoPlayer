//
//  BAPlayer.h
//  BAVideoPlayer
//
//  Created by 博爱之家 on 16/5/13.
//  Copyright © 2016年 博爱之家. All rights reserved.
//


#ifndef BAPlayer_h
#define BAPlayer_h

#pragma mark - ***** 头文件
#import "Masonry.h"
#import "BAVideoPlayerView.h"




#pragma mark - ***** 宏定义

// 当前设备的屏幕宽度
#define BA_SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
// 当前设备的屏幕高度
#define BA_SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

// 上下导航栏高(全屏时上导航栏高+20)
#define BATOPHEIGHT(FullScreen) ((FullScreen==YES)?60:40)
#define BAFOOTHEIGHT 40

// 导航栏上button的宽高
#define BAButtonWidth 30
#define BAButtonHeight 30

// 导航栏隐藏前所需等待时间
#define BAHideBarIntervalTime 3

#define BA_VideoSrcName(file) [@"BAVideoPlayer.bundle" stringByAppendingPathComponent:file]
#define BA_VideoFrameworkSrcName(file) [@"Frameworks/BAVideoPlayer.framework/BAVideoPlayer.bundle" stringByAppendingPathComponent:file]

#define BA_HalfWidth self.frame.size.width * 0.5
#define BA_HalfHeight self.frame.size.height * 0.5





#endif /* BAPlayer_h */
