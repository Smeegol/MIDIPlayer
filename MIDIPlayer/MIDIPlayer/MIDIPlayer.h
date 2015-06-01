//
//  MIDIPlayer.h
//  MIDIPlayer
//
//  Created by 谢小进 on 15/4/27.
//  Copyright (c) 2015年 Seedfield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIDIPlayer : NSObject

@property (nonatomic) double progress;

- (instancetype)initWithContentsOfURL:(NSURL *)fileURL soundBankURL:(NSURL *)bankURL error:(NSError **)error;
- (void)play;
- (void)stop;

@end
