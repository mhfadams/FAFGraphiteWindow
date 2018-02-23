//
//	FAFGraphiteWindow
//		FAFGraphiteWindow.h
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

#import <Cocoa/Cocoa.h>
//#import <Compatibility.h>

@class FAFGraphiteWindowFrameView;

@interface FAFGraphiteWindow : NSWindow
{
	NSView*	statusBarView; // the 14.0 high space below content view and between left border and resize box;
	NSView *childContentView;
	
	NSRect		restoreRect;
	BOOL		isScrolled;

	BOOL inActive;
}

- (NSView*) statusBarView;
- (void) setStatusBarView: (NSView*) view;


- (BOOL)isScrolled;

- (void) performShade: (id) sender;
- (void) performScrollUp: (id) sender;
- (void) performScrollDown: (id) sender;

- (void) checkFrame;

@end
