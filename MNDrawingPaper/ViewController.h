//
//  ViewController.h
//  MNDrawingPaper
//
//  Created by 이창민 on 2016. 1. 18..
//  Copyright © 2016년 changmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>{
  BOOL mouseSwiped;
  BOOL doubleTouch;
  BOOL singleTouch;
  
  BOOL resetTouch;
  CGPoint lastPoint;
}

@property (strong, nonatomic) IBOutlet UIImageView *drawImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;

@end

