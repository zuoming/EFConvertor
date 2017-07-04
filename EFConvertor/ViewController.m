//
//  ViewController.m
//  EFConvertor
//
//  Created by zuoming on 2017/6/12.
//  Copyright © 2017年 zuoming. All rights reserved.
//

#import "ViewController.h"
#import "EFColorMapUtil.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet NSTextField *versionLabel; /**<  */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"转换器";
    [self refreshVersion];
}

- (void)refreshVersion
{
    NSString *ver = [EFColorMapUtil version];
    [self.versionLabel setStringValue:[EFColorMapUtil version]];
}


- (IBAction)clickOpenButton:(id)sender
{
    [self openFile];
}

- (void)openFile
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"打开"];
    
    openPanel.allowedFileTypes = [NSArray arrayWithObjects: @"plist", nil];
    openPanel.directoryURL = nil;
    
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
        if (returnCode == 1) {
            NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:fileUrl];
            
            [EFColorMapUtil updateConfig:dict];
            [self refreshVersion];
        }
    }];
}

@end
