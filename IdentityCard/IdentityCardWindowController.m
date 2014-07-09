//
//  IdentityCardWindowController.m
//  IdentityCard
//
//  Created by hxp on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IdentityCardWindowController.h"

@implementation NSWindow (FRBExtra)

- (NSImage *)windowImage {
	NSImage *image = [[NSImage alloc] initWithCGImage:[self windowImageShot] size:[self frame].size];
	[image setDataRetained:YES];
	[image setCacheMode:NSImageCacheNever];
	return [image autorelease];
}

- (CGImageRef)windowImageShot {
	CGWindowID windowID = (CGWindowID)[self windowNumber];
	CGWindowImageOption imageOptions = kCGWindowImageDefault;
	CGWindowListOption singleWindowListOptions = kCGWindowListOptionIncludingWindow;
	CGRect imageBounds = self.frame;

	CGImageRef windowImage = CGWindowListCreateImage(imageBounds, singleWindowListOptions, windowID, imageOptions);

	return (CGImageRef)[NSMakeCollectable(windowImage) autorelease];
}

@end

@implementation NSView (image)

- (NSImage *)imageWithSubviews {
	NSRect realBounds = self.bounds;
	NSSize realSize = realBounds.size;
	NSRect fakeBounds = realBounds;

	NSScrollView *hackScrollView = self.enclosingScrollView;

	NSPoint offset = NSZeroPoint;
	if (hackScrollView) {
		NSPoint botLeft;
		botLeft.x = NSMinX(hackScrollView.bounds);
		botLeft.y = hackScrollView.isFlipped ? NSMaxY(hackScrollView.bounds) : NSMinY(hackScrollView.bounds);
		offset = [hackScrollView convertPoint:botLeft toView:hackScrollView.window.contentView];
	}

	fakeBounds.origin.x -= offset.x;
	fakeBounds.origin.y -= offset.y;
	fakeBounds.size.width += offset.x;
	fakeBounds.size.height += offset.x;
	NSSize fakeSize = fakeBounds.size;

	NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:fakeBounds];
	[bir setSize:fakeSize];
	[self cacheDisplayInRect:fakeBounds toBitmapImageRep:bir];

	NSImage *image = [[[NSImage alloc] initWithSize:realSize] autorelease];
	[image lockFocus];
	verify([bir drawAtPoint:fakeBounds.origin]);
	[image unlockFocus];
	return image;
}

@end

@interface IdentityCardWindowController ()

@end

@implementation IdentityCardWindowController
@synthesize numberLabel;
@synthesize addr2Label;
@synthesize addr1Label;
@synthesize dayLabel;
@synthesize monthLabel;
@synthesize yearLabel;
@synthesize nameLabel;
@synthesize name, addr1, addr2, year, month, day, number;

- (id)initWithWindow:(NSWindow *)window {
	self = [super initWithWindow:window];
	if (self) {
	}

	return self;
}

- (void)dealloc {
	[name release];
	[addr1 release];
	[addr2 release];
	[year release];
	[month release];
	[day release];
	[number release];
	[super dealloc];
}

- (void)saveJPEGImage:(CGImageRef)imageRef path:(NSString *)path {
	CFMutableDictionaryRef mSaveMetaAndOpts = CFDictionaryCreateMutable(nil, 0,
	                                                                    &kCFTypeDictionaryKeyCallBacks,  &kCFTypeDictionaryValueCallBacks);
	CFDictionarySetValue(mSaveMetaAndOpts, kCGImageDestinationLossyCompressionQuality,
	                     [NSNumber numberWithFloat:1.0]);   // set the compression quality here
	NSURL *outURL = [[NSURL alloc] initFileURLWithPath:path];
	CGImageDestinationRef dr = CGImageDestinationCreateWithURL((CFURLRef)outURL, (CFStringRef)kUTTypeJPEG, 1, NULL);
	CGImageDestinationAddImage(dr, imageRef, mSaveMetaAndOpts);
	CGImageDestinationFinalize(dr);
}

- (void)savePNGImage:(CGImageRef)imageRef path:(NSString *)path {
	NSURL *outURL = [[NSURL alloc] initFileURLWithPath:path];
	CGImageDestinationRef dr = CGImageDestinationCreateWithURL((CFURLRef)outURL, (CFStringRef)kUTTypePNG, 1, NULL);
	CGImageDestinationAddImage(dr, imageRef, NULL);
	CGImageDestinationFinalize(dr);
}

- (void)saveTIFFImage:(CGImageRef)imageRef path:(NSString *)path {
	int compression = NSTIFFCompressionLZW;  // non-lossy LZW compression
	CFMutableDictionaryRef mSaveMetaAndOpts = CFDictionaryCreateMutable(nil, 0,
	                                                                    &kCFTypeDictionaryKeyCallBacks,  &kCFTypeDictionaryValueCallBacks);
	CFMutableDictionaryRef tiffProfsMut = CFDictionaryCreateMutable(nil, 0,
	                                                                &kCFTypeDictionaryKeyCallBacks,  &kCFTypeDictionaryValueCallBacks);
	CFDictionarySetValue(tiffProfsMut, kCGImagePropertyTIFFCompression, CFNumberCreate(NULL, kCFNumberIntType, &compression));
	CFDictionarySetValue(mSaveMetaAndOpts, kCGImagePropertyTIFFDictionary, tiffProfsMut);

	NSURL *outURL = [[NSURL alloc] initFileURLWithPath:path];
	CGImageDestinationRef dr = CGImageDestinationCreateWithURL((CFURLRef)outURL, (CFStringRef)kUTTypeTIFF, 1, NULL);
	CGImageDestinationAddImage(dr, imageRef, mSaveMetaAndOpts);
	CGImageDestinationFinalize(dr);
}

- (void)windowDidLoad {
	[super windowDidLoad];

	nameLabel.stringValue = self.name;
	yearLabel.stringValue = self.year;
	monthLabel.stringValue = self.month;
	dayLabel.stringValue = self.day;
	numberLabel.stringValue = self.number;
	addr1Label.stringValue = self.addr1;
	addr2Label.stringValue = self.addr2;

	NSImage *image = [self.window.contentView imageWithSubviews];
	NSData *viewData = [image TIFFRepresentation];
	NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:viewData];
//    [self saveJPEGImage:bitmap.CGImage path:[NSString stringWithFormat:@"%@/Downloads/ICBox/%@.jpg",NSHomeDirectory(),self.numberLabel.stringValue]];
	[self savePNGImage:bitmap.CGImage path:[NSString stringWithFormat:@"%@/Downloads/ICBox/%@.png", NSHomeDirectory(), self.numberLabel.stringValue]];
	[self close];
}

@end
