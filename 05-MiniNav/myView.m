//
//  myView.m
//  05-MiniNav
//
//  Created by Arnaud Leclaire on 27/05/2014.
//  Copyright (c) 2014 GromiNet. All rights reserved.
//

#import "myView.h"

@implementation myView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Test iPad ou iPhone
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            isIpad = YES;
        } else {
            isIpad = NO;
        }
        
        // Test taille de l'écran, pour affichage des Alertes avec message
        if ([[UIScreen mainScreen]bounds].size.width<768) {
            isLowRes = YES;
        } else {
            isLowRes = NO;
        }
        
        // Init WebView
        maWebView = [[UIWebView alloc] init];
        [maWebView setDelegate:self];
        [maWebView setScalesPageToFit:YES]; //pour pinch+zoom
        [maWebView setBackgroundColor:[UIColor whiteColor]]; // sinon c'est noir par défaut et ça fait moche
        [self addSubview:maWebView];
        
        // Init ToolBar
            // Init bouton de la ToolBar
        refreshBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPage:)];
        backBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(changePage:)];
        [backBarButton setEnabled:NO];
        forwardBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(changePage:)];
        [forwardBarButton setEnabled:NO];
        homeBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(defineHomePage:)];
        chooseBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(chooseURL:)];
        flexibleSpaceBarButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        fixed20SpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixed20SpaceBarButton setWidth:20];
        NSArray* myTab = [NSArray arrayWithObjects:refreshBarButton,flexibleSpaceBarButton,backBarButton,fixed20SpaceBarButton,chooseBarButton,fixed20SpaceBarButton,forwardBarButton,flexibleSpaceBarButton,homeBarButton, nil];
            // addSubView
        maToolBar = [[UIToolbar alloc] init];
        [maToolBar setItems:myTab animated:YES];
        [self addSubview:maToolBar];
        
        // Init homePage
        homePageURLString = @"http://www.apple.fr";

        // Init chooseHomePage
        chooseHomePage = [[UIAlertView alloc] initWithTitle:@"Définir la page d'accueil" message:@"Nouvelle URL de la page d'accueil:" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Changer", nil];
        [chooseHomePage setAlertViewStyle:UIAlertViewStylePlainTextInput];

        // Init chooseWebPage
        chooseWebPage = [[UIAlertView alloc] initWithTitle:@"Nouvelle page web" message:@"Entrez l'adresse web:" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Surf", nil];
        [chooseWebPage setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        // et on affiche tout ça
        [self setFromOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        
        // on charge la pageWeb d'acceuil tant qu'a faire
        [self refreshPage:nil];
    }
    return self;
}


-(void)setFromOrientation:(UIInterfaceOrientation)orientation
{
    
    // on récupère la frame de l'écran pour la redimensionner selon l'orientation
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if ( orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight )    {
        // mode Horizontal
        self.frame = CGRectMake(screenRect.origin.x,screenRect.origin.y,screenRect.size.height,screenRect.size.width);
    }else{
        // sinon mode Vertical (pas d'autres mode hein?)
        self.frame = CGRectMake(screenRect.origin.x,screenRect.origin.y,screenRect.size.width,screenRect.size.height);
    }

    // Check du frame après
    NSLog(@"setFromOrientation X:%F et Y:%f",[self bounds].size.width,[self bounds].size.height);
    
    // c'est parti pour les positionnements
    float tailleX = [self bounds].size.width;
    float tailleY = [self bounds].size.height;
    int bordureX = 10;
    int bordureY = 20;
    
    // maToolBar
    [maToolBar setFrame:CGRectMake(0, bordureY, tailleX, 30)];
    
    // maWebView
    [maWebView setFrame:CGRectMake(bordureX, bordureY + [maToolBar bounds].size.height+10, tailleX - 2*bordureX, tailleY - (2*bordureY + [maToolBar bounds].size.height+10))];
    
    // Alert message
    if (isLowRes) {
        [chooseWebPage setMessage:@""];
        [chooseHomePage setMessage:@""];
    } else {
        [chooseWebPage setMessage:@"Entrez l'adresse web:"];
        [chooseHomePage setMessage:@"Nouvelle URL de la page d'accueil:"];
    }
    
    
    [self setNeedsLayout];
}

-(void)refreshPage:(UIBarButtonItem*)sender {
    [self getThisURL:[[NSURL alloc] initWithString:homePageURLString]];
}

-(void)defineHomePage:(UIBarButtonItem*)sender {
    [chooseHomePage show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Choose HomePage Alert
    if (alertView == chooseHomePage) {
        if (buttonIndex ==1) {
            // Recharger la page d'accueil
            homePageURLString = [self getURLfromString:[[alertView textFieldAtIndex:0] text]];
            NSLog(@"url:%@",homePageURLString);
        }
    }

    // Choose WebPage Alert
    if (alertView == chooseWebPage) {
        if (buttonIndex ==1) {
            // Changer la PageWeb
            [self getThisURL:[[NSURL alloc] initWithString:[self getURLfromString:[[alertView textFieldAtIndex:0] text]]]];
        }
    }
    
}

-(void)getThisURL:(NSURL*)monURL
{
    NSURLRequest* newRequest = [[NSURLRequest alloc] initWithURL:monURL];
    [maWebView loadRequest:newRequest];
}

-(void)chooseURL:(UIBarButtonItem*)sender {
    [chooseWebPage show];
}


-(void)changePage:(UIBarButtonItem*)sender {
    if (sender == backBarButton) {
        if ([maWebView canGoBack]) {
            [maWebView goBack];
        }
    } else {
        if ([maWebView canGoForward]) {
            [maWebView goForward];
        }
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Init Alert de la WebView
    [[[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"Oops" otherButtonTitles:nil] show];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Gestion des boutons précédent/suivant
        //goBack
    if ([webView canGoBack]) {
        [backBarButton setEnabled:YES];
    } else {
        [backBarButton setEnabled:NO];
    }
        //goForward
    if ([webView canGoForward]) {
        [forwardBarButton setEnabled:YES];
    } else {
        [forwardBarButton setEnabled:NO];
    }
    
    
}

-(NSString *)getURLfromString:(NSString *)text{
 
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    NSLog(@"%@",matches);
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSURL* url = [match URL];
            NSLog(@"%@",url);
            text = [url absoluteString];
        }
    }
    return text;
}

@end
