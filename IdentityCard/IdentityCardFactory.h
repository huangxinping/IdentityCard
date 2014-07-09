//
//  IdentityCardFactory.h
//  IdentityCard
//
//  Created by hxp on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//将NSImage转换为CIImage
//
//
//
//
//
//#import <QuartzCore/CIFilter.h>
//
//
//
//// convert NSImage to bitmap
//
//NSImage * myImage  = [self currentImage];
//
//NSData  * tiffData = [myImage TIFFRepresentation];
//
//NSBitmapImageRep * bitmap;
//
//bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
//
//
//
//// create CIImage from bitmap
//
//CIImage * ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
//
//
//
//// create affine transform to flip CIImage
//
//NSAffineTransform *affineTransform = [NSAffineTransform transform];
//
//[affineTransform translateXBy:0 yBy:128];
//
//[affineTransform scaleXBy:1 yBy:-1];
//
//
//
//// create CIFilter with embedded affine transform
//
//CIFilter *transform = [CIFilter filterWithName:@"CIAffineTransform"];
//
//[transform setValue:ciImage forKey:@"inputImage"];
//
//[transform setValue:affineTransform forKey:@"inputTransform"];
//
//
//
//// get the new CIImage, flipped and ready to serve
//
//CIImage * result = [transform valueForKey:@"outputImage"];
//
//
//
//// draw to view
//
//[result drawAtPoint: NSMakePoint ( 0,0 )
// 
//           fromRect: NSMakeRect  ( 0,0,128,128 )
// 
//          operation: NSCompositeSourceOver
// 
//           fraction: 1.0];
//
//
//
//// cleanup
//
//[ciImage release];
//
//
//
//将CGImageRef转换为NSImage *
//
//
//
//
//
//- (NSImage*) imageFromCGImageRef:(CGImageRef)image
//
//
//
//{
//    
//    
//    
//    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
//    
//    
//    
//    CGContextRef imageContext = nil;
//    
//    
//    
//    NSImage* newImage = nil;
//    
//    
//    
//    
//    
//    
//    
//    // Get the image dimensions.
//    
//    
//    
//    imageRect.size.height = CGImageGetHeight(image);
//    
//    
//    
//    imageRect.size.width = CGImageGetWidth(image);
//    
//    
//    
//    
//    
//    
//    
//    // Create a new image to receive the Quartz image data.
//    
//    
//    
//    newImage = [[[NSImage alloc] initWithSize:imageRect.size] autorelease];
//    
//    
//    
//    [newImage lockFocus];
//    
//    
//    
//    
//    
//    
//    
//    // Get the Quartz context and draw.
//    
//    
//    
//    imageContext = (CGContextRef)[[NSGraphicsContext currentContext]
//                                  
//                                  
//                                  
//                                  graphicsPort];
//    
//    
//    
//    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
//    
//    
//    
//    [newImage unlockFocus];
//    
//    
//    
//    
//    
//    
//    
//    return newImage;
//    
//    
//    
//}
//
//
//
//将NSImage *转换为CGImageRef 
//
//
//
//
//
//- (CGImageRef)nsImageToCGImageRef:(NSImage*)image;
//
//{
//    
//    NSData * imageData = [image TIFFRepresentation];
//    
//    CGImageRef imageRef;
//    
//    if(imageData)
//        
//    {
//        
//        CGImageSourceRef imageSource = 
//        
//        CGImageSourceCreateWithData(
//                                    
//                                    (CFDataRef)imageData,  NULL);
//        
//        
//        
//        imageRef = CGImageSourceCreateImageAtIndex(
//                                                   
//                                                   imageSource, 0, NULL);
//        
//    }
//    
//    return imageRef;
//    
//} 

@interface IdentityCardFactory : NSObject
{
}
@property(nonatomic,copy)NSString *number;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *year;
@property(nonatomic,copy)NSString *month;
@property(nonatomic,copy)NSString *day;

- (void)createIdentityCard;
@end
