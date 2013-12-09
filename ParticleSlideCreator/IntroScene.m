/********************************************************************
 * File   : IntroScene.m
 * Project: ParticleSlideCreator
 *
 ********************************************************************
 * Created on 4/9/13 By Nonlinear Ideas Inc.
 * Copyright (c) 2013 Nonlinear Ideas Inc. All rights reserved.
 ********************************************************************
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any
 * damages arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any
 * purpose, including commercial applications, and to alter it and
 * redistribute it freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must
 *    not claim that you wrote the original software. If you use this
 *    software in a product, an acknowledgment in the product
 *    documentation would be appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and
 *    must not be misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source
 *    distribution.
 */

#import "IntroScene.h"
#import "MainScene.h"

@implementation IntroScene

-(id)init
{
   self = [super init];
   if(self != nil)
   {
   }
   return self;
}

-(void)dealloc
{
   [super dealloc];
}

-(void)onEnter
{
   [super onEnter];
}

-(void)onExit
{
   [super onExit];
}

-(void)onEnterTransitionDidFinish
{
   [super onEnterTransitionDidFinish];
   CCLabelTTF * label = [CCLabelTTF labelWithString:@"Particle Slide Creator" fontName:@"Arial" fontSize:48];
   CGSize scrSize = [[CCDirector sharedDirector] winSize];
   label.position = ccp(scrSize.width/2,scrSize.height/2);
   label.anchorPoint = ccp(0.5,0.5);
   [self addChild:label];
   [self performSelector:@selector(showMainScene) withObject:nil afterDelay:2.0];
}

-(void)onExitTransitionDidStart
{
   [super onExitTransitionDidStart];
}

-(void)showMainScene
{
   CCTransitionFade* trans = [CCTransitionFade transitionWithDuration:1.5 scene:[MainScene node] withColor:ccc3(0,0,0)];
   [[CCDirector sharedDirector] replaceScene:trans];
}

@end
