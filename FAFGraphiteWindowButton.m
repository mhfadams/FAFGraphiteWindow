//
//  FAFGraphiteWindow
//		FAFGraphiteWindowButton.m
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

#import "FAFGraphiteWindowButton.h"


@implementation FAFGraphiteWindowButton

- (id)initWithFrame:(NSRect)frame
{
	frame.size.width = 14;
	frame.size.height = 14;
    self = [super initWithFrame:frame];
    if (self)
	{
		[self setButtonType:NSMomentaryChangeButton];
		[self setBordered:NO];
		mouseIn = NO;
		mouseDown = NO;
		shouldUseImage = NO;
		
		
		myTrackingRectTag = [self addTrackingRect:[self bounds]
											owner:self
										 userData:NULL
									 assumeInside:NO];
		
    }
    return self;
}

- (void) dealloc
{
	[self removeTrackingRect:myTrackingRectTag];

	[super dealloc];
}

	
- (BOOL)shouldUseImage {
    return shouldUseImage;
}

- (void)setShouldUseImage:(BOOL)value {
    if (shouldUseImage != value) {
        shouldUseImage = value;
    }
}



- (void)mouseEntered:(NSEvent *)theEvent
{
	//NSLog(@"%s", __PRETTY_FUNCTION__);
	mouseIn = YES;
	[self setNeedsDisplay];
    [super mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent
{
	//NSLog(@"%s", __PRETTY_FUNCTION__);
	mouseIn = NO;
	mouseDown = NO; // if user pulls away, cancels press
	[self setNeedsDisplay];
    [super mouseExited:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	//NSLog(@"%s", __PRETTY_FUNCTION__);
	mouseDown = YES;
	[self setNeedsDisplay];
    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	//NSLog(@"%s", __PRETTY_FUNCTION__);
	mouseDown = NO;
	[self setNeedsDisplay];
    [super mouseUp:theEvent];
}
@end
