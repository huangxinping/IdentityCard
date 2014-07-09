//
//  BaseCodeMgr.h
//  IdentityCard
//
//  Created by hxp on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCodeCY : NSObject
{
}
@property(nonatomic,copy)NSString *name;// 县级名称
@property(nonatomic,copy)NSString *code;// 县级代码
@end

@interface BaseCodeC : NSObject
{
}
@property(nonatomic,copy)NSString *name;// 市级名称
@property(nonatomic,copy)NSString *code;// 市级代码
@property(nonatomic,readonly)NSMutableArray *countyArray;// object of BaseCodeCY
@end

@interface BaseCodeP : NSObject
{
}
@property(nonatomic,copy)NSString *name;// 省份名称
@property(nonatomic,copy)NSString *code;// 省份代码
@property(nonatomic,readonly)NSMutableArray *cityArray;// object of BaseCodeC
@end


@interface BaseCodeMgr : NSObject
{
    NSMutableArray *baseCodeArray; // object of BaseCodeP;
}
@property(nonatomic,readonly)NSMutableArray *baseCodeArray;
+ (BaseCodeMgr*)sharedBaseCodeMgr;
- (void)loadBaseCode;
@end
