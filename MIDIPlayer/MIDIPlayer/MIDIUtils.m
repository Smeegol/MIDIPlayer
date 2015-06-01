//
//  MIDIUtils.m
//  MIDIPlayer
//
//  Created by 谢小进 on 15/4/27.
//  Copyright (c) 2015年 Seedfield. All rights reserved.
//

#include "MIDIUtils.h"

void CheckError(OSStatus error, const char *operation) {
	if (error == noErr) {
		return;
	}
	
	char str[20];
	*(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
	if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
		str[0] = str[5] = '\'';
		str[6] = '\0';
	} else {
		sprintf(str, "%d", (int)error);
	}
	fprintf(stderr, "Error: %s (%s)\n", operation, str);
	
    switch(error) {
        case kAUGraphErr_NodeNotFound:
            fprintf(stderr, "kAUGraphErr_NodeNotFound\n");
            break;
        case kAUGraphErr_OutputNodeErr:
            fprintf(stderr, "kAUGraphErr_OutputNodeErr\n");
            break;
        case kAUGraphErr_InvalidConnection:
            fprintf(stderr, "kAUGraphErr_InvalidConnection\n");
            break;
        case kAUGraphErr_CannotDoInCurrentContext:
            fprintf(stderr, "kAUGraphErr_CannotDoInCurrentContext\n");
            break;
        case kAUGraphErr_InvalidAudioUnit:
            fprintf(stderr, "kAUGraphErr_InvalidAudioUnit\n");
            break;
        case kMIDIInvalidClient:
            fprintf(stderr, "kMIDIInvalidClient\n");
            break;
        case kMIDIInvalidPort:
            fprintf(stderr, "kMIDIInvalidPort\n");
            break;
        case kMIDIWrongEndpointType:
            fprintf(stderr, "kMIDIWrongEndpointType\n"); 
            break;
        case kMIDINoConnection:
            fprintf(stderr, "kMIDINoConnection\n");
            break;
        case kMIDIUnknownEndpoint:
            fprintf(stderr, "kMIDIUnknownEndpoint\n");
            break;
        case kMIDIUnknownProperty:
            fprintf(stderr, "kMIDIUnknownProperty\n");
            break;
        case kMIDIWrongPropertyType:
            fprintf(stderr, "kMIDIWrongPropertyType\n");
            break;
        case kMIDINoCurrentSetup:
            fprintf(stderr, "kMIDINoCurrentSetup\n");
            break;
        case kMIDIMessageSendErr:
            fprintf(stderr, "kMIDIMessageSendErr\n");
            break;
        case kMIDIServerStartErr:
            fprintf(stderr, "kMIDIServerStartErr\n");
            break;
        case kMIDISetupFormatErr:
            fprintf(stderr, "kMIDISetupFormatErr\n");
            break;
        case kMIDIWrongThread:
            fprintf(stderr, "kMIDIWrongThread\n");
            break;
        case kMIDIObjectNotFound:
            fprintf(stderr, "kMIDIObjectNotFound\n");
            break;
        case kMIDIIDNotUnique:
            fprintf(stderr, "kMIDIIDNotUnique\n");
            break;
        case kAudioToolboxErr_InvalidSequenceType:
            fprintf(stderr, "kAudioToolboxErr_InvalidSequenceType\n");
            break;
        case kAudioToolboxErr_TrackIndexError:
            fprintf(stderr, "kAudioToolboxErr_TrackIndexError\n");
            break;
        case kAudioToolboxErr_TrackNotFound:
            fprintf(stderr, "kAudioToolboxErr_TrackNotFound\n");
            break;
        case kAudioToolboxErr_EndOfTrack:
            fprintf(stderr, "kAudioToolboxErr_EndOfTrack\n");
            break;
        case kAudioToolboxErr_StartOfTrack:
            fprintf(stderr, "kAudioToolboxErr_StartOfTrack\n");
            break;
        case kAudioToolboxErr_IllegalTrackDestination:
            fprintf(stderr, "kAudioToolboxErr_IllegalTrackDestination\n");
            break;
        case kAudioToolboxErr_NoSequence:
            fprintf(stderr, "kAudioToolboxErr_NoSequence\n");
            break;
        case kAudioToolboxErr_InvalidEventType:
            fprintf(stderr, "kAudioToolboxErr_InvalidEventType\n");
            break;
        case kAudioToolboxErr_InvalidPlayerState:
            fprintf(stderr, "kAudioToolboxErr_InvalidPlayerState\n");
            break;
        case kAudioUnitErr_InvalidProperty:
            fprintf(stderr, "kAudioUnitErr_InvalidProperty\n");
            break;
        case kAudioUnitErr_InvalidParameter:
            fprintf(stderr, "kAudioUnitErr_InvalidParameter\n");
            break;
        case kAudioUnitErr_InvalidElement:
            fprintf(stderr, "kAudioUnitErr_InvalidElement\n");
            break;
        case kAudioUnitErr_NoConnection:
            fprintf(stderr, "kAudioUnitErr_NoConnection\n");
            break;
        case kAudioUnitErr_FailedInitialization:
            fprintf(stderr, "kAudioUnitErr_FailedInitialization\n");
            break;
        case kAudioUnitErr_TooManyFramesToProcess:
            fprintf(stderr, "kAudioUnitErr_TooManyFramesToProcess\n");
            break;
        case kAudioUnitErr_InvalidFile:
            fprintf(stderr, "kAudioUnitErr_InvalidFile\n");
            break;
        case kAudioUnitErr_FormatNotSupported:
            fprintf(stderr, "kAudioUnitErr_FormatNotSupported\n");
            break;
        case kAudioUnitErr_Uninitialized:
            fprintf(stderr, "kAudioUnitErr_Uninitialized\n");
            break;
        case kAudioUnitErr_InvalidScope:
            fprintf(stderr, "kAudioUnitErr_InvalidScope\n");
            break;
        case kAudioUnitErr_PropertyNotWritable:
            fprintf(stderr, "kAudioUnitErr_PropertyNotWritable\n");
            break;
        case kAudioUnitErr_InvalidPropertyValue:
            fprintf(stderr, "kAudioUnitErr_InvalidPropertyValue\n");
            break;
        case kAudioUnitErr_PropertyNotInUse:
            fprintf(stderr, "kAudioUnitErr_PropertyNotInUse\n");
            break;
        case kAudioUnitErr_Initialized:
            fprintf(stderr, "kAudioUnitErr_Initialized\n");
            break;
        case kAudioUnitErr_InvalidOfflineRender:
            fprintf(stderr, "kAudioUnitErr_InvalidOfflineRender\n");
            break;
        case kAudioUnitErr_Unauthorized:
            fprintf(stderr, "kAudioUnitErr_Unauthorized\n");
            break;
	}
	exit(1);
}

void LogObject(void *obj, const char *filePath) {
	FILE *fp = NULL;
	if ((fp = fopen(filePath, "w"))) {
		CAShowFile(obj, fp);
		fflush(fp);
		fclose(fp);
		fp = NULL;
	}
}

CFTimeInterval GetSecondsForBeats(MusicSequence musicSequence, MusicTimeStamp beats) {
	CFTimeInterval seconds;
	CheckError(MusicSequenceGetSecondsForBeats(musicSequence, beats, &seconds), "MusicSequenceGetSecondsForBeats");
	return seconds;
}

MusicTimeStamp GetBeatsForSeconds(MusicSequence musicSequence, CFTimeInterval seconds) {
	MusicTimeStamp beats;
	CheckError(MusicSequenceGetBeatsForSeconds(musicSequence, seconds, &beats), "MusicSequenceGetBeatsForSeconds");
	return beats;
}

UInt32 NoteForString(NSString *s) {
	NSArray *notes = @[@"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B"];
	
	int noteIndex = 0;
	int noteLevel = 0;
	BOOL hasSharp = [s containsString:@"#"];
	if (hasSharp) {
		for (int i = 0; i < notes.count; i++) {
			NSString *note = notes[i];
			if ([note isEqualToString:[s substringToIndex:2]]) {
				noteIndex = i;
				break;
			}
		}
		
		noteLevel = [[s substringFromIndex:2] intValue];
	} else {
		for (int i = 0; i < notes.count; i++) {
			NSString *note = notes[i];
			if ([note isEqualToString:[s substringToIndex:1]]) {
				noteIndex = i;
				break;
			}
		}
		
		noteLevel = [[s substringFromIndex:1] intValue];
	}
	
	UInt32 note = (noteLevel + 2) * (UInt32)notes.count + noteIndex;
	return note;
}
