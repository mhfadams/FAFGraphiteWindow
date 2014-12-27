//
//	FAFGraphiteWindow
//		FAFGraphiteWindowFrameView.m
//

/*	*** original source license **** */
//	RoundWindow Example
//  Created by Matt Gallagher on 12/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
/*	*** end license **** */

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


//	*** Requires ObjC-2 compatible compiler ***

#import "FAFGraphiteWindowFrameView.h"
//#import <Compatibility.h>


@implementation FAFGraphiteWindowFrameView

//
// resizeRect
//
// Returns the bounds of the resize box.
//
- (NSRect)resizeRect
{
	NSRect selfBounds = [self bounds];
	NSRect resizeRect = NSMakeRect(selfBounds.size.width - 20.0,
								   selfBounds.origin.y,
								   20.0,
								   20.0);
	
	return resizeRect;
}

//
// mouseDown:
//
// Handles mouse clicks in our frame. Two actions:
//	- click in the resize box should resize the window
//	- click anywhere else will drag the window.
//
- (void)mouseDown:(NSEvent *)event
{
	
	NSPoint pointInView = [self convertPoint:[event locationInWindow] fromView:nil];
	NSWindow *window = [self window];
	NSPoint originalMouseLocation = [window convertBaseToScreen:[event locationInWindow]];
	NSRect originalFrame = [window frame];
	
	if ([event clickCount] == 2)
	{
		if (NSPointInRect(pointInView, NSMakeRect(0, originalFrame.size.height - 20, originalFrame.size.width, 20))
			||
			NSPointInRect(pointInView, [self resizeRect]))
		{
			[window performShade:self];
			return;
		}
	}
	
	
	BOOL resize = NO;
	if (NSPointInRect(pointInView, [self resizeRect]))
	{
		resize = YES;
	}
	
	
    while (YES)
	{
		//
		// Lock focus and take all the dragged and mouse up events until we
		// receive a mouse up.
		//
        NSEvent *newEvent = [window
			nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		
        if ([newEvent type] == NSLeftMouseUp)
		{
			break;
		}
		
		//
		// Work out how much the mouse has moved
		//
		NSPoint newMouseLocation = [window convertBaseToScreen:[newEvent locationInWindow]];
		NSPoint delta = NSMakePoint(
			newMouseLocation.x - originalMouseLocation.x,
			newMouseLocation.y - originalMouseLocation.y);
		
		NSRect newFrame = originalFrame;
		
		if (!resize)
		{
			//
			// Alter the frame for a drag
			//
			
			/*** prevent moving titlebar above Menu Bar, or below dock ***/
			NSRect visibleScreenRect = [[NSScreen mainScreen] visibleFrame];
			CGFloat yMin = visibleScreenRect.origin.y;
			CGFloat yMax = visibleScreenRect.size.height + yMin;
			
			CGFloat yProposed = newFrame.origin.y + newFrame.size.height + delta.y;
			// upper limit
			if ( (yProposed < yMax) && ((yProposed - 20.0) > yMin))
				newFrame.origin.y += delta.y;
			else
			{				
				if (yProposed >= yMax) // tried to go too high
					newFrame.origin.y = (yMax - newFrame.size.height);
				else // tried to go too low
					newFrame.origin.y = (yMin - newFrame.size.height + 20.0);				
			}
			
			/*** prevent moving titlebar too far to left or right ***/
			CGFloat xMin = visibleScreenRect.origin.x + 6.0 - newFrame.size.width;
			CGFloat xMax = visibleScreenRect.size.width - 6.0;
			
			CGFloat xProposed = newFrame.origin.x + delta.x;
			// upper limit
			if ( (xProposed < xMax) && (xProposed > xMin))
				newFrame.origin.x += delta.x;
			else
			{				
				if (xProposed >= xMax) // tried to go far right
					newFrame.origin.x = xMax;
				else // tried to go too far left
					newFrame.origin.x = xMin;				
			}
			
		}
		else
		{
			
			
			
			//
			// Alter the frame for a resize
			//
			newFrame.size.width += delta.x;
			newFrame.size.height -= delta.y;
			newFrame.origin.y += delta.y;
			
			//
			// Constrain to the window's min and max size
			//
			NSRect newContentRect = [window contentRectForFrameRect:newFrame];
			NSSize maxSize = [window maxSize];
			NSSize minSize = [window minSize];
			if (newContentRect.size.width > maxSize.width)
			{
				newFrame.size.width -= newContentRect.size.width - maxSize.width;
			}
			else if (newContentRect.size.width < minSize.width)
			{
				newFrame.size.width += minSize.width - newContentRect.size.width;
			}
			if (newContentRect.size.height > maxSize.height)
			{
				newFrame.size.height -= newContentRect.size.height - maxSize.height;
				newFrame.origin.y += newContentRect.size.height - maxSize.height;
			}
			else if (newContentRect.size.height < minSize.height)
			{
				newFrame.size.height += minSize.height - newContentRect.size.height;
				newFrame.origin.y -= minSize.height - newContentRect.size.height;
			}
		}
		
		[window setFrame:newFrame display:YES animate:NO];
	}
}

//
// drawRect:
//
// Draws the frame of the window.
//
- (void)drawRect:(NSRect)rect
{
	
	//[super drawRect:rect];
	//[NSGraphicsContext saveGraphicsState];
	//[self lockFocus];

	//NSLog(@"-[FAFGraphiteWindow drawRect:]");
	NSRect selfBounds = [self bounds];
	
	// content background
	[[NSColor colorWithCalibratedWhite:0.8 alpha:1.0] set];
	NSRectFill(rect);
	
	NSBezierPath *border = [NSBezierPath bezierPathWithRect:[self bounds]];
	[[NSColor blackColor] set];
	[border stroke];
	
	
	
#pragma mark Draw Resize Handle Stripes
	/*** Draw Resize Handle Stripes ***/
	// use fractional Y to get crisp lines
	CGFloat currentLineX = (selfBounds.size.width) - 15.0;
	CGFloat currentLineY = (selfBounds.origin.y) + 10.0;

	if ([[self window] isMainWindow] && ( ! [self inLiveResize] ))
	{
		int i;
		for (i = 1; i < 4; i++)
		{
			[[NSColor blackColor] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(currentLineX,			currentLineY) 
									  toPoint:NSMakePoint(currentLineX + 6.0,	currentLineY + 6.0)];
			currentLineX = currentLineX - 1.0;
			[[NSColor whiteColor] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(currentLineX,			currentLineY) 
									  toPoint:NSMakePoint(currentLineX + 7.0,	currentLineY + 7.0)];
			currentLineX = currentLineX + 2.0;
			[[NSColor colorWithCalibratedWhite:0.8 alpha:1.0] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(currentLineX,			currentLineY) 
									  toPoint:NSMakePoint(currentLineX + 7.0,	currentLineY + 7.0)];
			
			currentLineX = currentLineX + 1.0;
			currentLineY = currentLineY - 2.0;
		}
	}
	
#pragma mark Draw Top Border
	/*** Draw Top Border ***/
	// black line
	[[NSColor blackColor] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(selfBounds.origin.x,		selfBounds.size.height - 0.5) 
							  toPoint:NSMakePoint(selfBounds.size.width,	selfBounds.size.height - 0.5)];
	// white line
	[[NSColor whiteColor] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(selfBounds.origin.x,		selfBounds.size.height - 1.0) 
							  toPoint:NSMakePoint(selfBounds.size.width,	selfBounds.size.height - 1.0)];
	
#pragma mark Draw Left Border
	/*** Draw Left Border ***/
	// black line
	[[NSColor blackColor] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(selfBounds.origin.x,		selfBounds.origin.y) 
							  toPoint:NSMakePoint(selfBounds.origin.x,		selfBounds.size.height)];
	// white line
	[[NSColor whiteColor] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(selfBounds.origin.x + 1.0,		selfBounds.origin.y) 
							  toPoint:NSMakePoint(selfBounds.origin.x + 1.0,		selfBounds.size.height)];
	
#pragma mark Draw Right and Bottom Outer Border
	/*** Draw Right and Bottom Outer Border ***/
	[[NSColor blackColor] set];
	NSBezierPath* outerBorder = [NSBezierPath bezierPath];
	[outerBorder moveToPoint:NSMakePoint(selfBounds.origin.x,				selfBounds.origin.y)];
	[outerBorder lineToPoint:NSMakePoint(selfBounds.size.width,				selfBounds.origin.y)];
	[outerBorder lineToPoint:NSMakePoint(selfBounds.size.width,				selfBounds.size.height)];
	[outerBorder setLineWidth:1.0];
	[outerBorder stroke];

#pragma mark Draw Inside Border
	/*** Draw Inside Border ***/
	const CGFloat borderWidth = 6.0;
	// *** black line ***
	[[NSColor blackColor] set];
	NSBezierPath* innerBorder = [NSBezierPath bezierPath];
#if FAFGRAPHITEWINDOW_DRAWSTATUSBARZONE == 1
	// starting point (lower-left corder) ...
	[innerBorder moveToPoint:NSMakePoint(selfBounds.origin.x + borderWidth,
										 selfBounds.origin.y + borderWidth + 14.0)];
	// line on bottom to resize rect ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - 20.0,
										 selfBounds.origin.y + borderWidth + 14.0)];
#else
	// starting point (lower-left corder) ...
	[innerBorder moveToPoint:NSMakePoint(selfBounds.origin.x + borderWidth,
										 selfBounds.origin.y + borderWidth)];
	// line on bottom to resize rect ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - 20.0,
										 selfBounds.origin.y + borderWidth)];
#endif
	// lines around resize rect ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - 20,
										 selfBounds.origin.y + 20.0)];
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - borderWidth,
										 selfBounds.origin.y + 20.0)];
	// line on right ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - borderWidth, 
										 selfBounds.size.height - 20.0)];
	// line on top ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.origin.x + borderWidth, 
										 selfBounds.size.height - 20.0)];
	// line on left ...
#if FAFGRAPHITEWINDOW_DRAWSTATUSBARZONE == 1
	[innerBorder lineToPoint:NSMakePoint(selfBounds.origin.x + borderWidth, 
										 selfBounds.origin.y + borderWidth + 14.0)];
#else
	[innerBorder lineToPoint:NSMakePoint(selfBounds.origin.x + borderWidth, 
										 selfBounds.origin.y + borderWidth)];
#endif
	
	[innerBorder setLineWidth:1.0];
	[innerBorder stroke];
	
	// *** white line on bottom and right, 1 line below and right ***
	[[NSColor whiteColor] set];
	innerBorder = [NSBezierPath bezierPath];
#if FAFGRAPHITEWINDOW_DRAWSTATUSBARZONE == 1
	// starting point (lower-left corder) ...
	[innerBorder moveToPoint:NSMakePoint(selfBounds.origin.x + borderWidth,
										 selfBounds.origin.y + borderWidth - 0.5 + 14.0)];
	// line on bottom to resize rect ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - 19.5,
										 selfBounds.origin.y + borderWidth - 0.5 + 14.0)];
#else
	// starting point (lower-left corder) ...
	[innerBorder moveToPoint:NSMakePoint(selfBounds.origin.x + borderWidth,
										 selfBounds.origin.y + borderWidth - 0.5)];
	// line on bottom to resize rect ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - 19.5,
										 selfBounds.origin.y + borderWidth - 0.5)];
#endif
	// lines around resize rect ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - 19.5,
										 selfBounds.origin.y + 19.5)];
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - borderWidth + 0.5,
										 selfBounds.origin.y + 19.5)];
	// line on right ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - borderWidth + 0.5, 
										 selfBounds.size.height - 20.0)];
	
	[innerBorder setLineWidth:1.0];
	[innerBorder stroke];
	
	// *** white line on top and left borders, 1 line to the above and left ***
	[[NSColor whiteColor] set];
	innerBorder = [NSBezierPath bezierPath];
#if FAFGRAPHITEWINDOW_DRAWSTATUSBARZONE == 1
	// starting point (lower-left corder) ...
	[innerBorder moveToPoint:NSMakePoint(selfBounds.origin.x + borderWidth - 0.5,
										 selfBounds.origin.y + borderWidth + 14.0)];
#else
	// starting point (lower-left corder) ...
	[innerBorder moveToPoint:NSMakePoint(selfBounds.origin.x + borderWidth - 0.5,
										 selfBounds.origin.y + borderWidth)];
#endif
	// line left ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.origin.x + borderWidth - 0.5,
										 selfBounds.size.height - 19.5)];
	// line on top ...
	[innerBorder lineToPoint:NSMakePoint(selfBounds.size.width - borderWidth, 
										 selfBounds.size.height - 19.5)];
	
	[innerBorder setLineWidth:1.0];
	[innerBorder stroke];
	
	/* strip width and title text width are the same, so share measurements */
	CGFloat	stripXmin = (selfBounds.origin.x + 23.0);
	CGFloat	stripXmax = (selfBounds.size.width - (5 * 5) - (3 * 14) + 3);
	
#pragma mark Draw Title Bar Stripes
	if ([[self window] isMainWindow] && ( ! [self inLiveResize] ))
	{
		/*** Draw 6 Title Bar Stripes ***/
		[NSBezierPath setDefaultLineWidth:0.0];
		// use fractional Y to get crisp lines
		currentLineY = (selfBounds.size.height) - 4.5;
		int i;
		for (i = 1; i < 7; i++)
		{
			// the white line
			[[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(stripXmin,		currentLineY) 
									  toPoint:NSMakePoint(stripXmax - 1.0,	currentLineY)];
			currentLineY--;
			
			// the blackish line
			[[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(stripXmin + 1.0,	currentLineY) 
									  toPoint:NSMakePoint(stripXmax,		currentLineY)];
			currentLineY--;
		}
	}
	
#pragma mark Draw Title Text
	// title string draws in rect the width of title bar, and thus does its own centering.
	// add surrounding spaces to ward off striping's intrusion
	NSString *windowTitle = [NSString stringWithFormat:@"  %@  ", [[self window] title]];
	NSRect titleRect = NSMakeRect(stripXmin,
								  selfBounds.size.height - 15.0,
								  stripXmax,
								  20.0);
	
	NSMutableParagraphStyle *paragraphStyle =
		[[[NSMutableParagraphStyle alloc] init] autorelease];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
	
	NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSColor colorWithCalibratedWhite:0.8 alpha:1.0],	NSBackgroundColorAttributeName,
				paragraphStyle,										NSParagraphStyleAttributeName,
				[NSFont systemFontOfSize:13],						NSFontAttributeName,
								nil];
	
	
	[windowTitle
		drawWithRect:titleRect
		options:0
		attributes:attributes];
	
	
	//[NSGraphicsContext restoreGraphicsState];
	//[self unlockFocus];

	
	
}


- (BOOL) acceptsFirstMouse: (id) sender
// start actions (move/resize) on first click
// http://stackoverflow.com/questions/5656266/growl-notification-like-nswindow-level
{
	return YES;
}



@end
