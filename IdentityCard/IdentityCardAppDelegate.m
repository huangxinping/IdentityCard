//
//  IdentityCardAppDelegate.m
//  IdentityCard
//
//  Created by hxp on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IdentityCardAppDelegate.h"
#import "BaseCodeMgr.h"

@implementation IdentityCardAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
   
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Downloads/ICBox",NSHomeDirectory()] isDirectory:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Downloads/ICBox",NSHomeDirectory()] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [[BaseCodeMgr sharedBaseCodeMgr] loadBaseCode];
}

@end
