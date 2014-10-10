//
//  PPBoxEngine.m
//  PPTVCore
//
//  Created by GuoQiang Qian on 14-3-11.
//  Copyright (c) 2014年 PPLive Corporation. All rights reserved.
//

#import "PPBoxEngine.h"
#import "IPpbox.h"
#import "DownloadManager.h"
#import "PPSdkVersionDataController.h"

@interface PPBoxEngine ()

@property (nonatomic) NSUInteger httpPort;

@end

@implementation PPBoxEngine

+ (instancetype)sharedPPBoxEngine
{
    static PPBoxEngine *ppboxEngine = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        ppboxEngine = [[self alloc] init];
    });
    
    return ppboxEngine;
}

- (void)startPPBox
{
#if !TARGET_IPHONE_SIMULATOR
    PPBOX_SetConfig(NULL,"HttpManager","addr","0.0.0.0:9006+");
    
    PPBOX_SetConfig("common","CommonConfigModule","config_path",[NEW_DOWNLOAD_FOLDER UTF8String]);
    
    int ret = PPBOX_StartP2PEngine([@"fsfowfj" UTF8String],[@"wifjlf" UTF8String],[@"fiwjo" UTF8String]);
    if(ret == 0){
        [(PPSdkVersionDataController *)[PPSdkVersionDataController sharedDataController] requestWithArgs:nil];
        
        self.httpPort = (NSUInteger)PPBOX_GetPort("http");
        
        DDLogInfo(@"the p2p box ret : %d", ret);
    } else {
        DDLogError(@"fail to start P2P SDK");
    }
#endif
}

- (void)stopPPBox
{
#if !TARGET_IPHONE_SIMULATOR
    PPBOX_StopP2PEngine();
#endif
    
    DDLogInfo(@"stopPPBox");
}

- (void)restartPPBox
{
#if !TARGET_IPHONE_SIMULATOR
    PPBOX_PauseP2PEngine();
    PPBOX_ResumeP2PEngine();
#endif
    
    DDLogInfo(@"restartPPBox");
}

- (void)requestClose
{
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:%u/close", self.httpPort];
    
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                  delegate:nil];
    
    
}

- (BOOL)testLocalServer
{
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:%u/alive", self.httpPort];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:2];
    
    //  Returns nil if a connection could not be created or if the download fails.
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    if (data != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)openP2PNetwork
{
#if !TARGET_IPHONE_SIMULATOR
    PPBOX_SetStatus("network","status","true");
#endif
    
    DDLogInfo(@"open P2P");
}

- (void)closeP2PNetowrk
{
#if !TARGET_IPHONE_SIMULATOR
    PPBOX_SetStatus("network","status","false");
#endif
    DDLogInfo(@"close P2P");
}


@end
