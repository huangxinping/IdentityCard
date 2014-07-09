//
//  BaseCodeMgr.m
//  IdentityCard
//
//  Created by hxp on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseCodeMgr.h"

@implementation BaseCodeP
@synthesize name,cityArray,code;

- (id)init
{
    if ((self = [super init]))
    {
        self.name = nil;
        self.code = nil;
        cityArray = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [cityArray release];
    self.name = nil;
    self.code = nil;
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"name:%@ code:%@ city:%@",self.name,self.code,self.cityArray];
}

@end

@implementation BaseCodeC
@synthesize name,countyArray,code;

- (id)init
{
    if ((self = [super init]))
    {
        self.name = nil;
        self.code = nil;
        countyArray = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [countyArray release];
    self.name = nil;
    self.code = nil;
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"name:%@ code:%@ county:%@",self.name,self.code,self.countyArray];
}

@end

@implementation BaseCodeCY
@synthesize name,code;

- (id)init
{
    if ((self = [super init]))
    {
        self.name = nil;
        self.code = nil;
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.code = nil;
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"name:%@ code:%@",self.name,self.code];
}

@end

static BaseCodeMgr *instance = nil;
@implementation BaseCodeMgr
@synthesize baseCodeArray;

+ (BaseCodeMgr*)sharedBaseCodeMgr
{
    if (instance == nil)
    {
        instance = [[BaseCodeMgr alloc] init];
    }
    return instance;
}

- (NSArray*)removeWhite:(NSArray*)input
{
    NSMutableArray *bufferArray = [NSMutableArray array];
    for (NSString *obj in input)
    {
        obj = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [bufferArray addObject:obj];
    }
    return bufferArray;
}

- (id)init
{
    if ((self = [super init]))
    {
        baseCodeArray = [NSMutableArray new];
        
        NSString *baseCodeString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/basecode.txt",[[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray *allBaseCode = [[NSMutableArray alloc] initWithArray:[baseCodeString componentsSeparatedByString:@"\n"]];
        NSArray *array = [self removeWhite:allBaseCode];
        [allBaseCode removeAllObjects];
        [allBaseCode addObjectsFromArray:array];
        
        // 分割数据
        for (NSString *separated in allBaseCode)
        { 
            // 3:省
            // 5:市
            // 7:县
            NSArray *array = [separated componentsSeparatedByString:@" "];
            NSInteger size = [array count];
            switch (size)
            {
                case 3:
                {
                    BaseCodeP *bcp = [[BaseCodeP alloc] init];
                    bcp.name = [array objectAtIndex:2];
                    bcp.code = [array objectAtIndex:0];
                    [baseCodeArray addObject:bcp];
                    [bcp release];
                    break;
                }
                case 5:
                {
                    BaseCodeC *bcc = [[BaseCodeC alloc] init];
                    bcc.name = [array objectAtIndex:4];
                    bcc.code = [array objectAtIndex:0];
                    
                    BaseCodeP *bcp = [baseCodeArray lastObject];
                    [bcp.cityArray addObject:bcc]; 
                    
                    [bcc release];
                    break;
                }
                case 7:
                {
                    BaseCodeCY *bccy = [[BaseCodeCY alloc] init];
                    bccy.name = [array objectAtIndex:6];
                    bccy.code = [array objectAtIndex:0];
                    
                    BaseCodeP *bcp = [baseCodeArray lastObject];
                    BaseCodeC *bcc = [bcp.cityArray lastObject];
                    [bcc.countyArray addObject:bccy]; 
                    
                    [bccy release];
                    break;
                }
                default:
                    break;
            }
        }
        [allBaseCode release];
        //NSLog(@"%@",baseCodeArray);
    }
    return self;
}

- (void)dealloc
{
    [baseCodeArray release];
    [super dealloc];
}

@end
