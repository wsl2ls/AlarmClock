//
//  AppDelegate.h
//  闹钟
//
//  Created by 王双龙 on 16/6/3.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@end

