/********************************************************************
 * File   : MainScene.m
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

#import "MainScene.h"

const NSInteger MAX_PICTS = 60;
const NSInteger TAG_MENU = 100;

@interface MainScene()
{
   CCParticleSystemQuad* particles;
   CCRenderTexture* renderTexture;
   NSInteger pictIndex;
   BOOL takeSnapshots;
}

@property (nonatomic,retain) CCParticleSystemQuad* particles;
@property (nonatomic,retain) CCRenderTexture* renderTexture;

@end

@implementation MainScene

@synthesize particles;
@synthesize renderTexture;

-(id)init
{
   self = [super init];
   if(self != nil)
   {
      CGSize scrSize = [[CCDirector sharedDirector] winSize];
      CGPoint center = ccp(scrSize.width/2,scrSize.height/2);
      CGPoint anchor = ccp(0.5,0.5);
      self.renderTexture = [ CCRenderTexture renderTextureWithWidth:scrSize.width height:scrSize.height];
      self.renderTexture.position = center;
      self.renderTexture.anchorPoint = anchor;
      [self addChild: self.renderTexture ];
      
      // manually retain the particles as you dont add them to a container
      self.particles = [CCParticleSystemQuad particleWithFile:@"emitter.plist"];
      //self.particles = [CCParticleFire node];
      self.particles.position = center;
      self.particles.anchorPoint = anchor;
      pictIndex = 0;
      takeSnapshots = NO;
      [self createMenu];
   }
   return self;
}

-(void)dealloc
{
   [self.renderTexture dealloc];
   [self.particles dealloc];
   
   self.particles = nil;
   self.renderTexture = nil;
   [super dealloc];
}

-(void)createMenu
{
   CGSize scrSize = [[CCDirector sharedDirector] winSize];
   // Achievement Menu Item using blocks
   CCMenuItem *item1 = [CCMenuItemFont itemWithString:@"Tap To Take Snapshots" block:^(id sender)
                        {
                           [self removeMenu];
                           [self startTakingSnapshots];
                        }
                        ];
   
   CCMenu *menu = [CCMenu menuWithItems:item1, nil];
   [menu alignItemsVerticallyWithPadding:20];
   [menu setPosition:ccp( scrSize.width/2, scrSize.height/2)];
   // Add the menu to the layer
   [self addChild:menu z:10 tag:TAG_MENU];
}

-(void)removeMenu
{
   [self removeChildByTag:TAG_MENU cleanup:YES];
}

-(void)startTakingSnapshots
{
   takeSnapshots = YES;
}

-(void)takeSnapshot
{
   if(takeSnapshots && pictIndex < MAX_PICTS)
   {
      NSString* fileName = [NSString stringWithFormat:@"file_%04d.png",pictIndex];
      pictIndex++;
      CCLOG(@"Storing snapshot to %@",fileName);
      [self.renderTexture saveToFile:fileName format:kCCImageFormatPNG];
      if(pictIndex >= MAX_PICTS)
      {
         takeSnapshots = NO;
         pictIndex = 0;
         [self createMenu];
      }
   }
}

-( void )update:( ccTime )dt
{   
   [ self.particles update:1/30.0];
   [ self.renderTexture beginWithClear:0.0 g:0.0 b:0.0 a:1.0];
   [ self.particles visit ];
   [ self.renderTexture end ];
   [ self takeSnapshot];
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
   [self scheduleUpdate];
}

-(void)onExitTransitionDidStart
{
   [self unscheduleUpdate];
   self.renderTexture = nil;
   self.particles = nil;
   [super onExitTransitionDidStart];
}

@end
