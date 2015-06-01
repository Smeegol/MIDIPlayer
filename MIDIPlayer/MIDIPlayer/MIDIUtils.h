//
//  MIDIUtils.h
//  MIDIPlayer
//
//  Created by 谢小进 on 15/4/27.
//  Copyright (c) 2015年 Seedfield. All rights reserved.
//

#ifndef MIDIUtils_h
#define MIDIUtils_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

void CheckError(OSStatus error, const char *operation);

void LogObject(void *obj, const char *filePath);

CFTimeInterval GetSecondsForBeats(MusicSequence musicSequence, MusicTimeStamp beats);
MusicTimeStamp GetBeatsForSeconds(MusicSequence musicSequence, CFTimeInterval seconds);

UInt32 NoteForString(NSString *s);

#endif
