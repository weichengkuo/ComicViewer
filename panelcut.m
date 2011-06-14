//
//  panelcut.m
//  ComicViewer
//
//  Created by VincentLee on 2011/6/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "panelcut.h"


@implementation panelcut

@synthesize corners;

- (void) panel:(UIImage*) img{
    NSLog(@"panel starts cutting");
    CGImageRef cgImage = [img CGImage];
    int height=CGImageGetHeight(cgImage);
    int width=CGImageGetWidth(cgImage);
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    CFDataRef bitmapData = CGDataProviderCopyData(provider);
    NSData *myData = (NSData *)bitmapData;
    
    int dataSize=[myData length]/4;
    
    unsigned int v[dataSize];
    [myData getBytes:v length:[myData length]];
	//    
	//    NSMutableArray* array= [[NSMutableArray alloc ] init];
	//    
	//    for (int i=0; i<dataSize; i++) {
	//        [array addObject:(id) v[i]];
	//    }
    
    //int l_w = 20;
    //int l_h = 20;
	
	// cut straight line
    
	bool found = YES;
	int horizontaCount = 0;
	NSMutableArray* horr = [[NSMutableArray alloc] init];
	
    for (int h=0; h<height; h++){
        bool empty = YES;
        for (int s=0; s<width; s++){
            unsigned int pixel = v[(width*h+s)];
            if(pixel < 4286578688){
                empty = NO;
            }
        }
        if(!empty){
            found = NO;
			//NSLog(@"black @ h = %d",h);
        }
        if(empty&&!found){
            //NSLog(@"found %d",h);
			horizontaCount++;
			cord* newcord = [[cord alloc] init];
			[newcord setXY:0 :h];
			[horr addObject:newcord];
			[newcord release];
			found = YES;
        }
    }
	
	
	//NSMutableArray* 
	corners = [[NSMutableArray alloc] init];
	
	// these are corners & size
	int vertiCount = 0;
	int leftbond;
	
	for (int strp=0; strp<horizontaCount; strp++) {
		int upbond,lowbond;
		leftbond = 0;
		if(strp==0){
			upbond = 0;
			lowbond = [[horr objectAtIndex:0] getY];
		}else {
			upbond = [[horr objectAtIndex:(strp-1)] getY];
			lowbond = [[horr objectAtIndex:strp] getY];
		}
		
		found = YES;
		for (int w=0; w<width; w++){
			bool empty = YES;
			for (int s=upbond; s<lowbond; s++){
				unsigned int pixel = v[(w+s*height)];
				if(pixel < 4286578688){
					empty = NO;
				}
			}
			if(!empty){
				found = NO;
				//NSLog(@"black @ h = %d",h);
			}
			if(empty&&!found){
				//NSLog(@"found %d",h);
				vertiCount++;
				cord* newcord = [[cord alloc] init];
				[newcord setXY:leftbond :upbond];
				[newcord setHW:lowbond-upbond :w-leftbond];
				//CGRect newcord = CGRectMake(leftbond, upbond, w-leftbond, lowbond-upbond);
				[corners addObject:newcord];
				[newcord release];
				leftbond = w-leftbond;
				found = YES;
			}
			
		}
	}
	
	 //Use [[corners objectAtIndex:~] makeRect] to create rect
	
	NSLog(@"h = %d",horizontaCount);
	NSLog(@"w = %d",vertiCount);
	NSLog(@"%d",[corners count]);
}
@end


@implementation cord

@synthesize x;
@synthesize y;
@synthesize h;
@synthesize w;

-(void) setXY :(int) n_x : (int) n_y {
	x = n_x;
	y = n_y;
}

-(void) setHW :(int) n_h : (int) n_w {
	h = n_h;
	w = n_w;
}

-(CGRect) makeRect {
	CGRect rec = CGRectMake(x, y, w, h);
	NSLog(@"x = %d y = %d h = %d w = %d",x,y,h,w);
	return rec;
}

-(int)  getY{
	return y;
}
-(int)  getX{
	return x;
}
@end


