//
//  ViewController.m
//  avplayerdemo
//
//  Created by lele on 16/7/20.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@property (strong, nonatomic) AVPlayer *songPlayer;
@property (strong, nonatomic) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"play" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.frame = CGRectMake(100, 100, 100, 100);
    [_button addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    NSURL* musicUrl=[NSURL URLWithString:@"http://7xlamk.com2.z0.glb.qiniucdn.com//upload/yoloboo/2016/07/20/d365d413-efbf-4330-8777-f285f1e1a7fd.mp3"];
    NSError *sessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [audioSession setActive:YES error:nil];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:musicUrl];
    
    //播放完时发通知，循环播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];

    //在控制中心显示歌名，歌手名
    MPNowPlayingInfoCenter* mpic = [MPNowPlayingInfoCenter defaultCenter];
    mpic.nowPlayingInfo = @{MPMediaItemPropertyArtist: @"Matt Neuburg",//歌手名
                            MPMediaItemPropertyTitle: @"About Tiagol"};//歌曲名
    
    _songPlayer=[AVPlayer playerWithPlayerItem:item];
    [_songPlayer play];
    _songPlayer.volume=10.0f;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [_songPlayer seekToTime:kCMTimeZero];
    [_songPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playButtonPressed {
    if(_songPlayer.rate==0){ //暂停
        [_button setBackgroundImage:[UIImage imageNamed:@"Homepage_button_play"] forState:UIControlStateNormal];
        [_songPlayer play];
    }else if(_songPlayer.rate==1){//正在播放
        [_songPlayer pause];
        [_button setBackgroundImage:[UIImage imageNamed:@"Homepage_button_pause"] forState:UIControlStateNormal];
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    //控制中心和锁屏时控制暂停和播放
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [_songPlayer play];
                NSLog(@"暂停播放");
                break;
            case UIEventSubtypeRemoteControlPause:
                [_songPlayer pause];
                NSLog(@"继续播放");
                break;
            default:
                break;
        }
    }
}

@end
