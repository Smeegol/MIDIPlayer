//
//  ViewController.m
//  MIDIPlayer
//
//  Created by 谢小进 on 15/4/27.
//  Copyright (c) 2015年 Seedfield. All rights reserved.
//

#import "ViewController.h"
#import "MIDIPlayer.h"

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSArray *midiFilesArray;
	MIDIPlayer *midiPlayer;
}

@property (weak, nonatomic) IBOutlet UIPickerView *filesPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	midiFilesArray = @[@"100",
					   @"100去踏板",
					   @"100去鼓",
					   @"100去鼓去踏板",
					   @"120",
					   @"120去鼓去贝司",
					   @"AguadoOp4No1",
					   @"Bass_sample",
					   @"Campeone",
					   @"Digamese",
					   @"Drum_sample",
					   @"GM_DEMO",
					   @"Le Sacre Du Printemps - Stravinsky (Piano)",
					   @"MIDI文件demo1（120）",
					   @"MIDI文件demo2（100）",
					   @"PRESO",
					   @"Rondeau",
					   @"Rondo in C (Op.51. No.1.)",
					   @"Sonata No 14 in C#min-1",
					   @"Sonata No 14 in C#min-3",
					   @"Sonata No.9 in E-1",
					   @"Winter Wonderland (solo piano)",
					   @"ants",
					   @"demo1_with_lyrics",
					   @"demo2_with_lyrics",
					   @"致爱丽丝",
					   @"绮想轮旋曲",
					   @"埃克赛斯舞曲",
					   @"命运交响曲第一章"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)playAction:(id)sender {
	if (midiPlayer) {
		[midiPlayer stop];
		midiPlayer = nil;
	}
	
	NSURL *midiURL = [[NSBundle mainBundle] URLForResource:midiFilesArray[[_filesPicker selectedRowInComponent:0]] withExtension:@"mid"];
	NSURL *soundBankURL = [[NSBundle mainBundle] URLForResource:@"gs_instruments" withExtension:@"dls"];
	NSError *error;
	midiPlayer = [[MIDIPlayer alloc] initWithContentsOfURL:midiURL
											  soundBankURL:soundBankURL
													 error:&error];
	[midiPlayer play];
}

- (IBAction)pauseAction:(id)sender {
	
}

- (IBAction)stopAction:(id)sender {
	if (midiPlayer) {
		[midiPlayer stop];
		midiPlayer = nil;
	}
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return midiFilesArray.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return midiFilesArray[row];
}

@end
