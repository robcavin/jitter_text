//
//  LTFirstViewController.m
//  LighttTest
//
//  Created by Rob on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LTFirstViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LTFirstViewController ()

@end

@implementation LTFirstViewController
@synthesize overlayText;
@synthesize overlayImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",[UIFont familyNames]);
    NSLog(@"%@",[UIFont fontNamesForFamilyName:@"pencilPete FONT"]);
    [self.overlayText setFont:[UIFont fontWithName:@"PencilPeteFONT" size:40]];
    self.overlayText.numberOfLines = 5;
    self.overlayText.text = @"This next video is about... you guessed it...  cats";
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImageRotation) userInfo:nil repeats:YES];
}

- (CATransform3D) BuildPerspProjMatWithFov:(float)fov aspect:(float)aspect znear:(float)znear zfar:(float)zfar {
    float xymax = (float) (znear * tan(fov * M_PI/360));
    float ymin = -xymax;
    float xmin = -xymax;
    
    float width = xymax - xmin;
    float height = xymax - ymin;
    
    float depth = zfar - znear;
    float q = -(zfar + znear) / depth;
    float qn = -2 * (zfar * znear) / depth;
    
    float w = 2 * znear / width;
    w = w / aspect;
    float h = 2 * znear / height;

    CATransform3D m; 
    m.m11  = w;
    m.m21  = 0;
    m.m31  = 0;
    m.m41  = 0;
    
    m.m12  = 0;
    m.m22  = h;
    m.m32  = 0;
    m.m42  = 0;
    
    m.m13  = 0;
    m.m23  = 0;
    m.m33 = q;
    m.m43 = -1;
    
    m.m14 = 0;
    m.m24 = 0;
    m.m34 = qn;
    m.m44 = 0;
    
    return m;
}


- (void) changeImageRotation {
    float rotation = 1.0 - 1.0 * rand() / RAND_MAX * 2.0;
    float x_trans = 1.0 * rand() / RAND_MAX * 4.0;
    float y_trans = 1.0 * rand() / RAND_MAX * 4.0;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x_trans, y_trans);
    transform = CGAffineTransformRotate(transform, M_PI*rotation/180);
    //self.overlayImage.transform = CGAffineTransformRotate(transform, M_PI*rotation/180);
    //self.overlayText.transform = CGAffineTransformRotate(transform, M_PI*(rotation + 6)/180);
    
    CATransform3D perspectiveTransform;
    perspectiveTransform = [self BuildPerspProjMatWithFov:65 aspect:1 znear:0.1 zfar:100];

    
    CATransform3D rotationXTransform = CATransform3DMakeRotation(M_PI*(1.0*rand()/RAND_MAX*0.025 - 0.0125)/180, 1, 0,0);
    CATransform3D rotationYTransform = CATransform3DMakeRotation(M_PI*(1.0*rand()/RAND_MAX*0.025 - 0.0125)/180, 0, 1,0);
    CATransform3D rotationZTransform = CATransform3DMakeRotation(M_PI*(1.0*rand()/RAND_MAX*1.000 - 0.5)/180, 0, 0,1);
    CATransform3D rotationTransform = CATransform3DConcat(CATransform3DConcat(rotationZTransform, rotationYTransform), rotationXTransform);
    CATransform3D translationTransform = CATransform3DMakeTranslation(0,0, -7.5);
    
    CATransform3D finalTransform = CATransform3DConcat(CATransform3DConcat(rotationTransform,translationTransform),  perspectiveTransform);
    self.overlayImage.layer.transform = finalTransform;

    rotationZTransform = CATransform3DRotate(rotationZTransform,M_PI*6/180, 0, 0, 1);
    rotationTransform = CATransform3DConcat(CATransform3DConcat(rotationZTransform, rotationYTransform), rotationXTransform);
    translationTransform = CATransform3DTranslate(translationTransform, 0, 0, 0.0001);
    finalTransform = CATransform3DConcat(CATransform3DConcat(rotationTransform,translationTransform),  perspectiveTransform);
    self.overlayText.layer.transform = finalTransform;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
