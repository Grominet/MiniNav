//
//  myView.h
//  05-MiniNav
//
//  Created by Arnaud Leclaire on 27/05/2014.
//  Copyright (c) 2014 GromiNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myView : UIView <UIWebViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    // Vues
    UIWebView *maWebView;
    UIToolbar *maToolBar;
    UIImageView *monFond;
    
    // ToolBar Button
    UIBarButtonItem *refreshBarButton;
    UIBarButtonItem *backBarButton;
    UIBarButtonItem *forwardBarButton;
    UIBarButtonItem *homeBarButton;
    UIBarButtonItem *chooseBarButton;
    UIBarButtonItem *flexibleSpaceBarButton;
    UIBarButtonItem *fixed20SpaceBarButton;
    
    UIAlertView *chooseHomePage;
    UIAlertView *chooseWebPage;
    
    // Alerte
    UIAlertView *erreurWebPage;
    BOOL isLoading;
    
    // Bool
    BOOL isIpad;
    BOOL isLowRes;
    
    // Mémorisation
    NSString *homePageURLString;
}

- (void) setFromOrientation:(UIInterfaceOrientation)orientation;


@end
