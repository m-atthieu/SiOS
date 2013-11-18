//
//  LMDPadView.m
//  SiOS
//
//  Created by Lucas Menge on 1/4/12.
//  Copyright (c) 2012 Lucas Menge. All rights reserved.
//

#import "LMDPadView.h"

#import "../SNES9XBridge/Snes9xMain.h"

@interface LMDPadView ()
@property (strong, nonatomic) NSDictionary* states;
@end

@implementation LMDPadView
@synthesize states = _states;
@end

@implementation LMDPadView(Privates)

- (void) handleTouches: (NSSet*) touches
{
    UITouch* touch = [touches anyObject];
    if(touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded || touch == nil){
        SISetControllerReleaseButton(SIOS_UP);
        SISetControllerReleaseButton(SIOS_LEFT);
        SISetControllerReleaseButton(SIOS_RIGHT);
        SISetControllerReleaseButton(SIOS_DOWN);
        [self setImage: [self.states objectForKey: @"empty"]];
        return;
    }
    SISetControllerReleaseButton(SIOS_UP);
    SISetControllerReleaseButton(SIOS_LEFT);
    SISetControllerReleaseButton(SIOS_RIGHT);
    SISetControllerReleaseButton(SIOS_DOWN);
    
  CGPoint location = [touch locationInView: self];
  if(location.x < 50){
    if(location.y < 50){
      SISetControllerPushButton(SIOS_UP);
      SISetControllerPushButton(SIOS_LEFT);
        [self setImage: [self.states objectForKey: @"up-left"]];
    } else if(location.y < 100){
      SISetControllerPushButton(SIOS_LEFT);
        [self setImage: [self.states objectForKey: @"left"]];
    } else {
      SISetControllerPushButton(SIOS_DOWN);
      SISetControllerPushButton(SIOS_LEFT);
        [self setImage: [self.states objectForKey: @"down-left"]];
    }
  } else if(location.x < 100) {
    if(location.y < 50){
      SISetControllerPushButton(SIOS_UP);
        [self setImage: [self.states objectForKey: @"up"]];
    } else if(location.y > 100){
      SISetControllerPushButton(SIOS_DOWN);
        [self setImage: [self.states objectForKey: @"down"]];
    } else {
      // inside the middle square things get "tricky"
      int x = location.x - 75;
      int y = location.y - 75;
      if(x > 0){
        // right or up or down
        if(y > 0){
          // right or down
          if(x > y){
            SISetControllerPushButton(SIOS_RIGHT);
              [self setImage: [self.states objectForKey: @"right"]];
	  } else {
            SISetControllerPushButton(SIOS_DOWN);
          [self setImage: [self.states objectForKey: @"down"]];
	  }
        } else {
          // right or up
          if(x > -y){
            SISetControllerPushButton(SIOS_RIGHT);
              [self setImage: [self.states objectForKey: @"right"]];
	  } else {
            SISetControllerPushButton(SIOS_UP);
          [self setImage: [self.states objectForKey: @"up"]];
	  }
        }
      } else {
        // left or up or down
        if(y > 0){
          // left or down
          if(-x > y){
            SISetControllerPushButton(SIOS_LEFT);
              [self setImage: [self.states objectForKey: @"left"]];
          } else {
            SISetControllerPushButton(SIOS_DOWN);
              [self setImage: [self.states objectForKey: @"down"]];
	  }
        }  else {
          // left or up
          if(-x > -y){
            SISetControllerPushButton(SIOS_LEFT);
              [self setImage: [self.states objectForKey: @"left"]];
	  } else {
            SISetControllerPushButton(SIOS_UP);
          [self setImage: [self.states objectForKey: @"up"]];
	  }
        }
      }
    }
  } else {
    if(location.y < 50){
      SISetControllerPushButton(SIOS_UP);
      SISetControllerPushButton(SIOS_RIGHT);
        [self setImage: [self.states objectForKey: @"up-right"]];
    } else if(location.y < 100){
      SISetControllerPushButton(SIOS_RIGHT);
        [self setImage: [self.states objectForKey: @"right"]];
    } else {
      SISetControllerPushButton(SIOS_DOWN);
      SISetControllerPushButton(SIOS_RIGHT);
        [self setImage: [self.states objectForKey: @"down-right"]];
    }
  }
}
@end

#pragma mark -

@implementation LMDPadView(UIView)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if(self){
        self.userInteractionEnabled = YES;
    
        self.image = [UIImage imageNamed: @"ButtonDPad.png"];
        self.contentMode = UIViewContentModeCenter;
        self.states = @{
                  @"empty":      [UIImage imageNamed: @"ButtonDPad.png"],
                  @"up":         [UIImage imageNamed: @"ButtonDPad-pressed-up.png"],
                  @"down":       [UIImage imageNamed: @"ButtonDPad-pressed-down.png"],
                  @"left":       [UIImage imageNamed: @"ButtonDPad-pressed-left.png"],
                  @"right":      [UIImage imageNamed: @"ButtonDPad-pressed-right.png"],
                  @"up-left":    [UIImage imageNamed: @"ButtonDPad-pressed-up-left.png"],
                  @"up-right":   [UIImage imageNamed: @"ButtonDPad-pressed-up-right.png"],
                  @"down-left":  [UIImage imageNamed: @"ButtonDPad-pressed-down-left.png"],
                  @"down-right": [UIImage imageNamed: @"ButtonDPad-pressed-down-right.png"],
        };
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches: touches];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches: touches];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches: touches];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches: touches];
}

@end
