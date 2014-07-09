//
//  IdentityCardWindowController.h
//  IdentityCard
//
//  Created by hxp on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow(FRBExtra)
- (NSImage*)windowImage;
- (CGImageRef)windowImageShot;
@end

@interface NSView(image)
- (NSImage*)imageWithSubviews;
@end

@interface IdentityCardWindowController : NSWindowController
{
}
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *addr2;
@property (nonatomic,copy)NSString *addr1;
@property (nonatomic,copy)NSString *day;
@property (nonatomic,copy)NSString *month;
@property (nonatomic,copy)NSString *year;
@property (nonatomic,copy)NSString *number;

@property (assign) IBOutlet NSTextField *numberLabel;
@property (assign) IBOutlet NSTextField *addr2Label;
@property (assign) IBOutlet NSTextField *addr1Label;
@property (assign) IBOutlet NSTextField *dayLabel;
@property (assign) IBOutlet NSTextField *monthLabel;
@property (assign) IBOutlet NSTextField *yearLabel;
@property (assign) IBOutlet NSTextField *nameLabel;
@end
