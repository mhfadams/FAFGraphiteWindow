//
//	FAFGraphiteWindow
//		FAFGraphiteWindow.m
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

#import "FAFGraphiteWindow.h"
#import "FAFGraphiteWindowFrameView.h"
#import "FAFGraphiteWindowCloseButton.h"
#import "FAFGraphiteWindowShadeButton.h"
#import "FAFGraphiteWindowDockButton.h"
#import "FAFGraphiteWindowZoomButton.h"

//#import <objc/runtime.h>

@implementation FAFGraphiteWindow

//
// initWithContentRect:styleMask:backing:defer:screen:
//
// Init method for the object.
//
- (id)initWithContentRect:(NSRect)contentRect
	styleMask:(NSUInteger)windowStyle
	backing:(NSBackingStoreType)bufferingType
	defer:(BOOL)deferCreation
{
	self = [super
		initWithContentRect:contentRect
		styleMask:NSBorderlessWindowMask
		backing:bufferingType
		defer:deferCreation];
	if (self)
	{
		[self setOpaque:NO];
		[self setBackgroundColor:[NSColor clearColor]];
		
		[[NSNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(mainWindowChanged:)
			name:NSWindowDidBecomeMainNotification
			object:self];
		
		[[NSNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(mainWindowChanged:)
			name:NSWindowDidResignMainNotification
			object:self];
		
		
		isScrolled = NO;
		
		[self checkFrame];
		
		/*
		unsigned int methodCount = 0;
		Method *mlist = class_copyMethodList([NSWindow class], &methodCount);
		for (int i = 0; i < methodCount; ++i){
			NSString* methName = NSStringFromSelector(method_getName(mlist[i]));
			
			if ([methName rangeOfString:@"Drawer"].location != NSNotFound)
				NSLog(@"%@", methName);
		}
		
		*/
		
	}
	return self;
}

//
// dealloc
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void) awakeFromNib
{
	[self checkFrame];
}

- (BOOL)isScrolled
{
	return isScrolled;
}

//
// setContentSize:
//
// Convert from childContentView to frameView for size.
//
- (void)setContentSize:(NSSize)newSize
{
	NSSize sizeDelta = newSize;
	NSSize childBoundsSize = [childContentView bounds].size;
	sizeDelta.width -= childBoundsSize.width;
	sizeDelta.height -= childBoundsSize.height;
	
	FAFGraphiteWindowFrameView *frameView = [super contentView];
	NSSize newFrameSize = [frameView bounds].size;
	newFrameSize.width += sizeDelta.width;
	newFrameSize.height += sizeDelta.height;
	
	[super setContentSize:newFrameSize];
}

//
// mainWindowChanged:
//
// Redraw the close button when the main window status changes.
//
- (void)mainWindowChanged:(NSNotification *)aNotification
{
	//[closeButton setNeedsDisplay];
	//[zoomButton setNeedsDisplay];
	[[super contentView] setNeedsDisplay:YES];

}

- (void) setDocumentEdited:(BOOL)flag
{
	[super setDocumentEdited:flag];
	[[super contentView] setNeedsDisplay:YES];

}

//
// setContentView:
//
// Keep our frame view as the content view and make the specified "aView"
// the child of that.
//
- (void)setContentView:(NSView *)aView
{

	if ([childContentView isEqualTo:aView])
	{
		return;
	}
	
	NSRect bounds = [self frame];
	bounds.origin = NSZeroPoint;

	FAFGraphiteWindowFrameView *frameView = [super contentView];
	if (!frameView)
	{
		frameView = [[[FAFGraphiteWindowFrameView alloc] initWithFrame:bounds] autorelease];
		
		[super setContentView:frameView];
		

		const CGFloat windowButtonWidth = 14;
		const CGFloat windowButtonGap = 5;
		
		/*** Shade Button ***/
		FAFGraphiteWindowShadeButton* shadeButton;
		shadeButton = [[FAFGraphiteWindowShadeButton alloc] initWithFrame:NSMakeRect(bounds.size.width - 7 - (1 * windowButtonWidth), 
																					 bounds.size.height - 2.0 - windowButtonWidth, 
																					 0,0)]; // button sets own size
		[shadeButton setTarget:self];
		[shadeButton setAction:@selector(performShade:)];
		[frameView addSubview:shadeButton];
		[shadeButton release];
		
		/*** Dock Button ***/
		FAFGraphiteWindowDockButton* dockButton;
		dockButton = [[FAFGraphiteWindowDockButton alloc] initWithFrame:NSMakeRect(bounds.size.width - 7 - windowButtonGap - (2 * windowButtonWidth), 
																					 bounds.size.height - 2.0 - windowButtonWidth, 
																					 0,0)]; // button sets own size
		[dockButton setTarget:self];
		[dockButton setAction:@selector(performMiniaturize:)];
		[frameView addSubview:dockButton];
		[dockButton release];
		
		/*** Zoom Button ***/
		FAFGraphiteWindowZoomButton* zoomButton;
		zoomButton = [[FAFGraphiteWindowZoomButton alloc] initWithFrame:NSMakeRect(bounds.size.width - 7 - (2 * windowButtonGap) - (3 * windowButtonWidth), 
																					 bounds.size.height - 2.0 - windowButtonWidth, 
																					 0,0)]; // button sets own size
		[zoomButton setTarget:self];
		[zoomButton setAction:@selector(zoom:)];
		[frameView addSubview:zoomButton];
		[zoomButton release];
		
		/*** Close Button ***/
		FAFGraphiteWindowCloseButton* closeButton;
		closeButton = [[FAFGraphiteWindowCloseButton alloc] initWithFrame:NSMakeRect(7, 
																					 bounds.size.height - 3.0 - windowButtonWidth, 
																					 0,0)]; // button sets own size
		[closeButton setTarget:self];
		[closeButton setAction:@selector(performClose:)];
		[frameView addSubview:closeButton];
		[closeButton release];
		
		
	}
	
	if (childContentView)
	{
		[childContentView removeFromSuperview];
	}
	childContentView = aView;
	[childContentView setFrame:[self contentRectForFrameRect:bounds]];
	[childContentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[frameView addSubview:childContentView];
	
	
	
	
	
}

//
// contentView
//
// Returns the child of our frame view instead of our frame view.
//
- (NSView *)contentView
{
	return childContentView;
}

- (NSView*) statusBarView
{
	if ( ! statusBarView )
	{
		// create it...
		
		FAFGraphiteWindowFrameView* frameView = [super contentView];
		
		
		
		statusBarView = [[[NSView alloc] initWithFrame:NSMakeRect(3.0,
																  0.0,
																  [frameView bounds].size.width - 20.0,
																  19.0)] autorelease];
		[statusBarView setAutoresizingMask:(NSViewWidthSizable)];
		[frameView addSubview:statusBarView];
	}
	return statusBarView;
}

- (void) setStatusBarView: (NSView*) view
{
	// to do: make sure new view was inited with the right bounds.
	if (statusBarView && view)
	{
		FAFGraphiteWindowFrameView* frameView = [super contentView];
		[statusBarView removeFromSuperview];
		[statusBarView release];
		[frameView addSubview:statusBarView];
	}
}


//
// canBecomeKeyWindow
//
// Overrides the default to allow a borderless window to be the key window.
//
- (BOOL)canBecomeKeyWindow
{
	return YES;
}

//
// canBecomeMainWindow
//
// Overrides the default to allow a borderless window to be the main window.
//
- (BOOL)canBecomeMainWindow
{
	return YES;
}


- (void) performClose: (id)sender
{
	/* we have to re-implement performClose: because default implementation depends on
	 presense (so it seems) of standard window close button
	 */
	BOOL shouldClose = YES;
	if ([[self delegate] respondsToSelector:@selector(windowShouldClose:)])
		shouldClose = [[self delegate] windowShouldClose:self];
	if (shouldClose)
	{
		[self orderOut:self];
		if ([self isReleasedWhenClosed])
			[self performSelector:@selector(release) withObject:nil afterDelay:0];
	}
}


- (void) performShade: (id)sender
{
	if (isScrolled)
		[self performScrollDown:sender];
	else
		[self performScrollUp:sender];
}

/*!
\brief	trap the miniaturize button's action, pass through.
 */
- (void) performMiniaturize: (id)sender
{
	[super miniaturize:sender];
}

- (void) performScrollUp: (id) sender
{
	//FAFGraphiteWindowFrameView *frameView = [super contentView];
	NSRect bounds = [self frame];
	bounds.origin = NSZeroPoint;
	
	// remove content view from use;
	[childContentView retain]; // will release upon reinsertion
	[childContentView removeFromSuperview];
	
	
	// scroll ...

	// determine top left corner
	restoreRect = [self frame];
	int newHeight = 40.0;
	
	// newOrigin is top left corner minus new height
	NSPoint newOrigin = NSMakePoint(restoreRect.origin.x, 
									(restoreRect.origin.y + restoreRect.size.height - newHeight));
	NSRect newRect = NSMakeRect(newOrigin.x, 
								newOrigin.y, 
								restoreRect.size.width, 
								newHeight);
	
	[self setFrame:newRect display:YES animate:NO];
	isScrolled = YES;
	
		
}

- (void) performScrollDown: (id) sender
{
	FAFGraphiteWindowFrameView *frameView = [super contentView];
	NSRect bounds = [self frame];
	//bounds.origin = NSZeroPoint;
	
	
	// restore height, keep other measurements ...
	bounds.origin.y = bounds.origin.y - restoreRect.size.height + 40;
	restoreRect.origin = bounds.origin;
	[self setFrame:restoreRect display:YES animate:NO];
	isScrolled = NO;

	// restore content view to use;
	[childContentView autorelease]; // was retained upon removal
	[frameView addSubview:childContentView];
}


//
// contentRectForFrameRect:styleMask:
//
// Returns the rect for the content rect, taking the frame.
//
+ (NSRect)contentRectForFrameRect:(NSRect)windowFrame styleMask:(NSUInteger)windowStyle
{
	// ignore style mask since we are always the same
	
	windowFrame.origin = NSZeroPoint;
	return NSMakeRect(windowFrame.origin.x + 7.0,
					  windowFrame.origin.y + 7.0 + 14.0,
					  windowFrame.size.width - 14.0,
					  windowFrame.size.height - 7.0 - 22.0 - 14.0);
}

//
// contentRectForFrameRect:
//
// Returns the rect for the content rect, taking the frame.
//
- (NSRect)contentRectForFrameRect:(NSRect)windowFrame
{
	windowFrame.origin = NSZeroPoint;
	return NSMakeRect(windowFrame.origin.x + 7.0,
					  windowFrame.origin.y + 7.0 + 14.0,
					  windowFrame.size.width - 14.0,
					  windowFrame.size.height - 7.0 - 22.0 - 14.0);
}

// private (undocumented) NSWindow internal, needed to correctly position sheets.
- (NSRect) startRectForSheet: (NSWindow*) sheet
{
	NSRect windowFrame = [self frame];
	return NSMakeRect(0.0,
					  windowFrame.size.height - 20.0,
					  windowFrame.size.width,
					  0.0);
}

//
// frameRectForContentRect:styleMask:
//
// Ensure that the window is make the appropriate amount bigger than the content.
//
+ (NSRect)frameRectForContentRect:(NSRect)windowContentRect styleMask:(NSUInteger)windowStyle
{
	return NSMakeRect(windowContentRect.origin.x - 6.0,
					  windowContentRect.origin.y - 6.0 - 14.0,
					  windowContentRect.size.width + 12.0,
					  windowContentRect.size.height + 6.0 + 20.0 + 14.0);
}


- (NSSize) maxSize
{
	NSSize size = [super maxSize];
	// make sure window doesnt go taller than screen
	NSRect screenBounds = [[NSScreen mainScreen] visibleFrame];
	if (screenBounds.size.height < size.height)
		size.height = screenBounds.size.height;
	
	return size;
	
}

- (void) checkFrame
{
	//printf("%s", __PRETTY_FUNCTION__);
	NSRect oldFrame = [self frame];
	NSRect newFrame = NSMakeRect(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
	NSRect visibleScreenRect = [[NSScreen mainScreen] visibleFrame];
	CGFloat yMin = visibleScreenRect.origin.y;
	CGFloat yMax = visibleScreenRect.size.height + yMin;
	
	if ( (newFrame.origin.y + newFrame.size.height) > yMax)
		newFrame.origin.y = newFrame.origin.y - ((newFrame.origin.y + newFrame.size.height) - yMax);
	
	
	[self setFrame:newFrame display:YES];
	
}

@end
