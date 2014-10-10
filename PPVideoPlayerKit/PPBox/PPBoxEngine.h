//
//  PPBoxEngine.h
//  PPTVCore
//
//  Created by GuoQiang Qian on 14-3-11.
//  Copyright (c) 2014年 PPLive Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define P2P_PORT    [NSString stringWithFormat:@"%u", [[PPBoxEngine sharedPPBoxEngine] httpPort]]

@interface PPBoxEngine : NSObject

@property (nonatomic, readonly) NSUInteger httpPort;

+ (instancetype)sharedPPBoxEngine;

- (void)startPPBox;

- (void)stopPPBox;

- (void)restartPPBox;

- (void)requestClose;

- (BOOL)testLocalServer;

- (void)openP2PNetwork;

- (void)closeP2PNetowrk;

@end
