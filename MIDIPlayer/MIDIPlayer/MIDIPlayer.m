//
//  MIDIPlayer.m
//  MIDIPlayer
//
//  Created by 谢小进 on 15/4/27.
//  Copyright (c) 2015年 Seedfield. All rights reserved.
//

#import "MIDIPlayer.h"
#import "MIDIUtils.h"

@interface MIDIPlayer() {
	NSURL *fileURL;
	NSURL *bankURL;
	
	AUGraph graph;
	AUNode sampleNode;
	AUNode ioNode;
	AudioUnit sampleUnit;
	AudioUnit ioUnit;
	
	MusicPlayer player;
	MusicSequence sequence;
}

@end

@implementation MIDIPlayer

- (instancetype)initWithContentsOfURL:(NSURL *)theFileURL soundBankURL:(NSURL *)theBankURL error:(NSError **)error {
    if (self = [super init]) {
		fileURL = theFileURL;
		bankURL = theBankURL;
		
		[self createGraph];
		[self startGraph];
		[self loadPreset:0];
		[self loadFile];
    }
    return self;
}

- (void)createGraph {
    CheckError(NewAUGraph(&graph), "NewAUGraph");
	
	AudioComponentDescription sampleDesc = {};
	sampleDesc.componentType			= kAudioUnitType_MusicDevice;
	sampleDesc.componentSubType			= kAudioUnitSubType_Sampler;
	sampleDesc.componentManufacturer	= kAudioUnitManufacturer_Apple;
	sampleDesc.componentFlags			= 0;
	sampleDesc.componentFlagsMask		= 0;
	CheckError(AUGraphAddNode(graph, &sampleDesc, &sampleNode), "AUGraphAddNode");
	
    AudioComponentDescription ioUnitDesc;
    ioUnitDesc.componentType			= kAudioUnitType_Output;
    ioUnitDesc.componentSubType			= kAudioUnitSubType_RemoteIO;
    ioUnitDesc.componentManufacturer	= kAudioUnitManufacturer_Apple;
    ioUnitDesc.componentFlags			= 0;
    ioUnitDesc.componentFlagsMask		= 0;
    CheckError(AUGraphAddNode(graph, &ioUnitDesc, &ioNode), "AUGraphAddNode");
	
	CheckError(AUGraphOpen(graph), "AUGraphOpen");
    
	CheckError(AUGraphNodeInfo(graph, sampleNode, NULL, &sampleUnit), "AUGraphNodeInfo");
    CheckError(AUGraphNodeInfo(graph, ioNode, NULL, &ioUnit), "AUGraphNodeInfo");
	
	CheckError(AUGraphConnectNodeInput(graph, sampleNode, 0, ioNode, 0), "AUGraphConnectNodeInput");
	
	CheckError(AUGraphInitialize(graph), "AUGraphInitialize");
	CAShow(graph);
}

- (void)startGraph {
    if (graph) {
        Boolean isRunning;
        CheckError(AUGraphIsRunning(graph, &isRunning), "AUGraphIsRunning");
		if (!isRunning) {
            CheckError(AUGraphStart(graph), "AUGraphStart");
		}
    }
}

- (void)stopGraph {
	if (graph) {
		Boolean isRunning;
		CheckError(AUGraphIsRunning (graph, &isRunning), "AUGraphIsRunning");
		if (isRunning) {
			CheckError(AUGraphStop(graph), "AUGraphStop");
		}
	}
}

- (void)loadPreset:(UInt8)preset {
	AUSamplerInstrumentData data;
	data.fileURL		= (__bridge CFURLRef)bankURL;
	data.instrumentType	= kInstrumentType_SF2Preset;
	data.bankMSB		= kAUSampler_DefaultMelodicBankMSB;
	data.bankLSB		= kAUSampler_DefaultBankLSB;
	data.presetID		= preset;
    CheckError(AudioUnitSetProperty(sampleUnit, kAUSamplerProperty_LoadInstrument, kAudioUnitScope_Global, 0, &data, sizeof(data)),
			   "kAUSamplerProperty_LoadInstrument");
}

- (void)loadFile {
    CheckError(NewMusicSequence(&sequence), "NewMusicSequence");
	CheckError(MusicSequenceFileLoad(sequence, (__bridge CFURLRef)fileURL, kMusicSequenceFile_MIDIType, kMusicSequenceLoadSMF_ChannelsToTracks),
			   "MusicSequenceFileLoad");
    CheckError(MusicSequenceSetAUGraph(sequence, graph), "MusicSequenceSetAUGraph");
	
	CheckError(NewMusicPlayer(&player), "NewMusicPlayer");
	CheckError(MusicPlayerSetSequence(player, sequence), "MusicPlayerSetSequence");
    CheckError(MusicPlayerPreroll(player), "MusicPlayerPreroll");
}

- (void)play {
    CheckError(MusicPlayerStart(player), "MusicPlayerStart");
}

- (void)stop {
	CheckError(MusicPlayerStop(player), "MusicPlayerStop");
	CheckError(DisposeMusicPlayer(player), "DisposeMusicPlayer");
	
    CheckError(DisposeMusicSequence(sequence), "DisposeMusicSequence");
	
	[self stopGraph];
    CheckError(DisposeAUGraph(graph), "DisposeAUGraph");
}

@end
