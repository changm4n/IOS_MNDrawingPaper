//
//  ViewController.m
//  MNDrawingPaper
//
//  Created by 이창민 on 2016. 1. 18..
//  Copyright © 2016년 changmin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
  CGFloat red;
  CGFloat green;
  CGFloat blue;
  CGFloat brush;
}



@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  red = 0/255.0;
  blue = 0/255.0;
  green = 0/255.0;
  brush = 10;
  
  // Do any additional setup after loading the view, typically from a nib.
  
  
  UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
  UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
  UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
  UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
  
  
  [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
  [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
  [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
  [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
  
  [swipeRight setNumberOfTouchesRequired:2];
  [swipeLeft setNumberOfTouchesRequired:2];
  [swipeUp setNumberOfTouchesRequired:2];
  [swipeDown setNumberOfTouchesRequired:2];
  
  
  [_drawImageView addGestureRecognizer:swipeUp];
  [_drawImageView addGestureRecognizer:swipeRight];
  [_drawImageView addGestureRecognizer:swipeLeft];
  [_drawImageView addGestureRecognizer:swipeDown];
  
  
  
}
-(void)swipe:(UISwipeGestureRecognizer *)sender{
  
  
  CGPoint point = [sender locationInView:self.view];
  
  
  if(sender.direction == UISwipeGestureRecognizerDirectionRight){
    
    red = 240/255.0;
    green = 240/255.0;
    blue = 240/255.0;
    brush = 20;
    
  }
  if(sender.direction == UISwipeGestureRecognizerDirectionLeft){
    
    red = 0/255.0;
    green = 0/255.0;
    blue = 0/255.0;
    brush = 10;
    
  }
  if(sender.direction == UISwipeGestureRecognizerDirectionUp){
    if(self.view.frame.size.height - point.y < 100){
      
      _mainImage.image = nil;
      _drawImageView.image = nil;
      
      [UIView transitionWithView:_mainImage duration:0.8 options:UIViewAnimationOptionTransitionCurlUp animations:^{
      } completion:^(BOOL finished) {
      }];
      
    }
    
  }
  if(sender.direction == UISwipeGestureRecognizerDirectionDown){
    if(point.y < 100){
      
      
      
      UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
      [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
      UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
      
      
    }
    
  }
  
  
  
  
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
  // Was there an error?
  if (error != NULL)
  {
    
    
    
  } else {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, -40, 320, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"success";
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    [UIView animateWithDuration:1 animations:^{
      label.frame = CGRectMake(0, 0, 320, 40);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        label.frame = CGRectMake(0, -40, 320, 40);
      } completion:^(BOOL finished) {
        [label removeFromSuperview];
      }];
      
      
//      [UIView animateWithDuration:1.5  animations:^{
//        label.frame = CGRectMake(0, -40, 320, 40);
//      }completion:^(BOOL finished) {
//        [label removeFromSuperview];
//      }];
    }];
    
    
    
  }
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  mouseSwiped = NO;
  
  UITouch *touch = [touches anyObject];
  lastPoint = [touch locationInView:self.view];
  
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  
  UITouch *touch = [touches anyObject];
  CGPoint currentPoint = [touch locationInView:self.view];
  
  UIGraphicsBeginImageContext(self.view.frame.size);
  [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
  CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
  CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
  CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red,green,blue, 1.0);
  CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
  
  CGContextStrokePath(UIGraphicsGetCurrentContext());
  self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
  [self.drawImageView setAlpha:1.0];
  UIGraphicsEndImageContext();
  
  lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
  if(!mouseSwiped) {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red,green,blue, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  
  
  
  
  UIGraphicsBeginImageContext(self.mainImage.frame.size);
  [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
  [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
  self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
  self.drawImageView.image = nil;
  UIGraphicsEndImageContext();
}

@end
