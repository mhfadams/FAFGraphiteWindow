//
//  FAFGraphiteWindow
//		FAFGraphiteWindowCloseButton.m
//
//  Created by Manoah Adams on 2014-09-07.
/*
 FAFGraphiteWindow
 Copyright (c) 2014, Manoah F. Adams, All rights reserved.
 federaladamsfamily.com/developer
 developer@federaladamsfamily.com
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation and/or 
 other materials provided with the distribution.
 
 3. Neither the name of the copyright holder nor the names of its contributors may 
 be used to endorse or promote products derived from this software without specific 
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

#import "FAFGraphiteWindowCloseButton.h"


@implementation FAFGraphiteWindowCloseButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		[self setAutoresizingMask:NSViewMaxXMargin | NSViewMinYMargin];
		
		/* If an image is available for the button, use that */
		buttonImagePressed = [[[NSImage alloc] initWithContentsOfFile:
							   [[NSBundle bundleForClass:[self class]] pathForImageResource:@"CarbonCloseButtonPressed"]] autorelease];
		buttonImageUnpressed = [[[NSImage alloc] initWithContentsOfFile:
							   [[NSBundle bundleForClass:[self class]] pathForImageResource:@"CarbonCloseButtonUnpressed"]] autorelease];
		if (buttonImagePressed && buttonImageUnpressed)
		{
			shouldUseImage = YES;
			[self setImage:buttonImageUnpressed];
			[self setAlternateImage:buttonImagePressed];
			
			/*
			 the image, although technically same size as drawn button, looks smaller,
			 so we self adjust back to the left a little. Dont use 'frame' var as that may not be valid.
			 */
			NSRect newFrame = [self frame];
			newFrame.origin.x = newFrame.origin.x - 3;
			[self setFrame:newFrame];
		}
		
		[self setToolTip:@"Close Window"];
		
    }
    return self;
}

- (void) dealloc
{

	[super dealloc];
}

- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
	
	if ( ! shouldUseImage )
	{
		// inner field
		NSBezierPath* path = [NSBezierPath bezierPathWithRect:NSMakeRect(1.5, 1.5, 11.5, 11.5)];
		[[NSColor redColor] set];
		[path stroke];
		[path fill];
		
		if (mouseDown && mouseIn)
		{
			// right and bottom black border
			path = [NSBezierPath bezierPath];
			[path moveToPoint:NSMakePoint(0.5, 13.5)];
			[path lineToPoint:NSMakePoint(0.5, 0.5)];
			[path lineToPoint:NSMakePoint(13.5, 0.5)];
			[[NSColor blackColor] set];
			[path stroke];
			
			// left and top white border
			path = [NSBezierPath bezierPath];
			[path moveToPoint:NSMakePoint(13.5, 0.5)];
			[path lineToPoint:NSMakePoint(13.5, 13.5)];
			[path lineToPoint:NSMakePoint(0.5, 13.5)];
			[[NSColor whiteColor] set];
			[path stroke];
			//}
			
			//if (NO) //mouseIn)
			//{
			/* draw X in button
			[[NSColor blackColor] set];
			path = [NSBezierPath bezierPath];
			[path moveToPoint:NSMakePoint(3, 3)];
			[path lineToPoint:NSMakePoint(10, 10)];
			[path stroke];
			[path moveToPoint:NSMakePoint(3.5, 3.5)];
			[path lineToPoint:NSMakePoint(10.5, 10.5)];
			[path stroke];
			path = [NSBezierPath bezierPath];
			[path moveToPoint:NSMakePoint(3, 10)];
			[path lineToPoint:NSMakePoint(10, 3)];
			[path stroke];
			[path moveToPoint:NSMakePoint(3.5, 10.5)];
			[path lineToPoint:NSMakePoint(10.5, 3.5)];
			[path stroke]; */
		}
	}
	
}


@end
