//
//  IdentityCardFactory.m
//  IdentityCard
//
//  Created by hxp on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IdentityCardFactory.h"
#import "IdentityCardWindowController.h"

@implementation IdentityCardFactory
@synthesize number,year,month,day,name,addr;

- (id)init
{
    if ((self = [super init]))
    {
        number = nil;
        year = nil;
        month = nil;
        day = nil;
        name = nil;
        addr = nil;
    }
    return self;
}

- (void)dealloc
{
    [number release];
    [year release];
    [month release];
    [day release];
    [name release];
    [addr release];
    [super dealloc];
}

- (void)createIdentityCard
{
    IdentityCardWindowController *vc = [[IdentityCardWindowController alloc] initWithWindowNibName:@"IdentityCardWindowController"];
    if ([self.addr length] > 11) // 两行地址
    {
        // 前11个放addr1，其余放addr2
        vc.addr1 = [self.addr substringToIndex:11];
        vc.addr2 = [self.addr substringFromIndex:11];
    }
    else
    {
        vc.addr1 = self.addr;
        vc.addr2 = @"";
    } 
    vc.year = self.year;
    vc.month = self.month;
    vc.day = self.day;
    vc.number = self.number;
    vc.name = self.name;
    [vc.window makeKeyWindow]; 
}

@end
