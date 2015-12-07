//
//  VoiceHelper.m
//  WordRecognition
//
//  Created by 李超 on 15/12/2.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "VoiceHelper.h"

@implementation VoiceHelper

+ (id)sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpspeechSynthesizer];
    }
    return self;
}

- (void)setUpspeechSynthesizer{
    self.speechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置在线工作方式
    [self.speechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //音量,取值范围 0~100
    [self.speechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
    [self.speechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
    [self.speechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
}


#pragma mark port
- (void)startSpeaking:(NSString *)word withParamaters:(NSDictionary *)paramaters{
    if (paramaters != nil) {
        for (id key in paramaters) {
            [self.speechSynthesizer setParameter:paramaters[key] forKey:key];
        }
    }
    [self.speechSynthesizer startSpeaking:word];
}

- (void)setSpeechSynthesizerDelegate:(id)delegate {
    self.speechSynthesizer.delegate = delegate;
}

- (void)stopSpeak {
    [self.speechSynthesizer pauseSpeaking];
}


@end
