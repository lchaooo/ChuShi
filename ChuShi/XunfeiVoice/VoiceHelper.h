//
//  VoiceHelper.h
//  WordRecognition
//
//  Created by 李超 on 15/12/2.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>

@interface VoiceHelper : NSObject

@property (nonatomic, strong) IFlySpeechSynthesizer *speechSynthesizer;

/**
 *  return sharedInstance.usage:setSpeechSynthesizerDelegate first;
 *
 *  @return 
 */
+ (id)sharedInstance;

/**
 *  start speeking
 *
 *  @param word       合成语音
 *  @param paramaters 合成参数.若无,则使用默认的
 */
- (void)startSpeaking:(NSString *)word withParamaters:(NSDictionary *)paramaters;

- (void)stopSpeak;

/**
 *  set delegate
 *
 *  @param delegate 
 */
- (void)setSpeechSynthesizerDelegate:(id)delegate;

@end
