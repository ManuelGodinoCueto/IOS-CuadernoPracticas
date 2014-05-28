//
//  DetailSplitViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 25/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "DetailSplitViewController.h"
#import "WebServices.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Social/Social.h>

@interface DetailSplitViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) UIActionSheet *uploadActionSheet;
@property (strong, nonatomic) UIPopoverController *popOverController;

@end

@implementation DetailSplitViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
	
    // Only shows information on Detail SplitView if a folder is selected
    if (self.folder) {
        
        // Configure toolbar items:
        //
        //  --------   ------                                     -----------
        // | Upload | | Rate | <-----------> Title <-----------> | Video|PDF |
        //  --------   ------                                     -----------
        //
        
        // Upload
        UIBarButtonItem *uploadButtonItem;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelectedRol"] isEqualToString:@"Professor"]) {
            // Selected Twitter account is a Professor account
            uploadButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publicar PDF" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadPDF)];
        } else {
            // Selected Twitter account is a Student account
            uploadButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publicar vídeo" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadVideo)];
        }
        
        // Rate
        UIBarButtonItem *rateButtonItem;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelectedRol"] isEqualToString:@"Professor"]) {
            // Selected Twitter account is a Professor account
            rateButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Calificar vídeo" style:UIBarButtonItemStyleBordered target:self action:@selector(rate)];
        } else {
            // Selected Twitter account is a Student account
            rateButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Ver calificación" style:UIBarButtonItemStyleBordered target:self action:@selector(getRate)];
        }
        
        // Flexible space
        UIBarButtonItem *flexibleSpacebarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        // Title
        NSString *title = self.folder;
        
        if (self.video) {
            title = [NSString stringWithFormat:@"%@ - %@", self.video, title];
        }
        
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:Nil action:Nil];
        
        // Video|PDF
        UIBarButtonItem *PDFVideobarButtonItem;
        
        if (self.video) {
            PDFVideobarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Vídeo" style:UIBarButtonItemStyleBordered target:self action:@selector(loadVideo)];
        }
        
        // Combine all items on toolbar
        NSMutableArray *toolbarButtons = [NSMutableArray arrayWithObjects:uploadButtonItem, rateButtonItem, flexibleSpacebarButtonItem, titleItem, flexibleSpacebarButtonItem, PDFVideobarButtonItem, nil];
        [self.toolBar setItems:toolbarButtons];
        
        // Load Video or PDF depending on user choice
        self.video && [[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelectedRol"] isEqualToString:@"Professor"] ? [self loadVideo] : [self loadPDF];
    }
}

#pragma mark - Loading

-(void)loadPDF
{
    // Dismiss ActionSheet or Popover if are visible
    [self.uploadActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    self.uploadActionSheet = nil;
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
    
    NSURL *emptyURL = [NSURL URLWithString:@"about:blank"];
    NSURLRequest *emptyRequest = [NSURLRequest requestWithURL:emptyURL];
    [self.webView loadRequest:emptyRequest];
    
    [UIView transitionWithView:self.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        [[[self.toolBar items] lastObject] setTitle:@"Vídeo"];
                        [(UIBarButtonItem *)[[self.toolBar items] lastObject] setAction:@selector(loadVideo)];
                        
                        NSString *webServicePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServicePath"];
                        NSString *webServiceDownloadPDF = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceDownloadPDF"];
                        NSURL *url = [NSURL URLWithString:[[webServicePath stringByAppendingFormat:webServiceDownloadPDF, self.folder] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        //                        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"ftp://IOS-CuadernoPracticas:TFG-miSEL-2013@seldata.sel.inf.uc3m.es/home/www/IOS-CuadernoPracticas/%@/Enunciado.pdf", self.folder] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        
                        NSURLRequest *request = [NSURLRequest requestWithURL:url];
                        [self.webView loadRequest:request];
                        [self.webView setScalesPageToFit:YES];
                    }
                    completion:NULL];
}

-(void)loadVideo
{
    // Dismiss ActionSheet or Popover if are visible
    [self.uploadActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    self.uploadActionSheet = nil;
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
    
    NSURL *emptyURL = [NSURL URLWithString:@"about:blank"];
    NSURLRequest *emptyRequest = [NSURLRequest requestWithURL:emptyURL];
    [self.webView loadRequest:emptyRequest];
    
    [UIView transitionWithView:self.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [[[self.toolBar items] lastObject] setTitle:@"PDF"];
                        [(UIBarButtonItem *)[[self.toolBar items] lastObject] setAction:@selector(loadPDF)];
                        
                        dispatch_queue_t queue = dispatch_queue_create("loadVideo", NULL);
                        dispatch_async(queue, ^{
                            NSURL *url = [NSURL URLWithString:@"about:blank"];
                            if ([WebServices doesVideoExistForFolder:self.folder andFollower:self.video]) {
                                url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://seldata.sel.inf.uc3m.es/~IOS-CuadernoPracticas/IOS-CuadernoPracticas/%@/%@.mov", self.folder, self.video] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^ {
                                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                
                                [self.webView loadRequest:request];
                                
                            });
                        });
                        
                    }
                    completion:NULL];
}

#pragma mark - Uploading

-(void)uploadPDF
{
    // Dismiss ActionSheet or Popover if are visible
    [self.uploadActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    self.uploadActionSheet = nil;
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
    
    NSString *importedPDFName = [[NSUserDefaults standardUserDefaults] stringForKey:@"importedPDFURL"];
    
    if (![importedPDFName isEqualToString:@""]) {
        // A PDF has been imported
        NSString *text = [NSString stringWithFormat:@"Publicar enunciado en la carpeta: %@", self.folder];
        self.uploadActionSheet = [[UIActionSheet alloc] initWithTitle:[importedPDFName lastPathComponent] delegate:self cancelButtonTitle:Nil destructiveButtonTitle:Nil otherButtonTitles:text, nil];
        UIBarButtonItem *uploadButtonItem = [self.toolBar.items objectAtIndex:0];
        [self.uploadActionSheet showFromBarButtonItem:uploadButtonItem animated:YES];
    } else {
        // A PDF has not been imported
        NSString *message = @"No se ha importado ningún PDF";
        UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:@"Publicar PDF" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [openURLAlert show];
    }
}

-(void)uploadVideo
{
    // Dismiss ActionSheet or Popover if are visible
    [self.uploadActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    self.uploadActionSheet = nil;
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
    
    self.uploadActionSheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:Nil destructiveButtonTitle:Nil otherButtonTitles:@"Grabar vídeo", @"Seleccionar existente", nil];
    UIBarButtonItem *uploadButtonItem = [self.toolBar.items objectAtIndex:0];
    [self.uploadActionSheet showFromBarButtonItem:uploadButtonItem animated:YES];
    
}

#pragma mark - Rating

-(void)rate
{
    // Dismiss ActionSheet or Popover if are visible
    [self.uploadActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    self.uploadActionSheet = nil;
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
    
    if (self.folder && self.video) {
        [self performSegueWithIdentifier:@"rate" sender:self];
    } else {
        NSString *message = @"Seleccione un vídeo para calificarlo.";
        UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:@"Calificar vídeo" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [openURLAlert show];
    }
}

-(void)getRate
{
    // Dismiss ActionSheet or Popover if are visible
    [self.uploadActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    self.uploadActionSheet = nil;
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
    
    [self performSegueWithIdentifier:@"getRate" sender:self];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
    self.activityIndicator.center = self.webView.center;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelectedRol"] isEqualToString:@"Professor"]) {
        //  0: Publicar enunciado en la carpeta: XXXX
        // -1: Cancel
        if (buttonIndex == 0) {
            
            dispatch_queue_t queue = dispatch_queue_create("pdfPostRequest", NULL);
            dispatch_async(queue, ^{
                [self pdfPostRequest];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self loadPDF];
                    [self sendTweet];
                });
            });
        }
    } else {
        // 0: Grabar vídeo
        // 1: Seleccionar existente
        if (buttonIndex == 0) {
            [self recordVideo];
        } else if (buttonIndex == 1) {
            [self useVideoRoll];
        }
    }
}

#pragma mark -

-(void)recordVideo
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)useVideoRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        self.popOverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.popOverController.delegate = self;
        
        imagePicker.delegate = self;
        imagePicker.editing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        UIBarButtonItem *uploadVideoBarButtonItem = [self.toolBar.items objectAtIndex:0];
        
        [self.popOverController presentPopoverFromBarButtonItem:uploadVideoBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
        // Selected from Library
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        dispatch_queue_t queue = dispatch_queue_create("postRequestWithAssetURL", NULL);
        dispatch_async(queue, ^{
            [self postRequestWithAssetURL:videoURL];
        });
    } else {
        // Recorder from camera
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:videoURL
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            [self postRequestWithAssetURL:assetURL];
                                        }
             ];
        }
    }
    // Dismiss Popover or Picker if are visible
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
    [picker dismissViewControllerAnimated:YES completion:Nil];
    picker = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark -

-(void)postRequestWithAssetURL:(NSURL *)assetURL
{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:assetURL
                  resultBlock:^(ALAsset *asset) {
                      // Data
                      ALAssetRepresentation *rep = [asset defaultRepresentation];
                      Byte *buffer = (Byte*)malloc(rep.size);
                      NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                      NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                      
                      // URL
                      NSString *webServicePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServicePath"];
                      NSString *webServiceUploadVideo = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceUploadVideo"];
                      NSURL *url = [NSURL URLWithString:[[webServicePath stringByAppendingFormat:webServiceUploadVideo, self.folder] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                      
                      // Body
                      NSMutableData *body = [NSMutableData data];
                      [body appendData:[@"\r\n--%@\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                      NSString *twitterUsernameSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelected"];
                      NSString *content = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.mov\"\r\n", twitterUsernameSelected];
                      [body appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
                      [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                      [body appendData:data];
                      [body appendData:[@"\r\n--%@--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                      
                      // Request
                      NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                      [request setURL:url];
                      [request setHTTPMethod:@"POST"];
                      [request setValue:@"multipart/form-data; boundary=%@" forHTTPHeaderField: @"Content-Type"];
                      [request setHTTPBody:body];
                      
                      NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                      NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                      NSLog(@"%@", returnString);
                      
                      dispatch_async(dispatch_get_main_queue(), ^ {
                          [self loadVideo];
                      });
                  }
     
                 failureBlock:^(NSError *err) {
                     NSLog(@"Error: %@",[err localizedDescription]);
                 }
     ];
}

- (void)pdfPostRequest
{
    // Data
    NSString *filePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"importedPDFURL"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    // URL
    NSString *webServicePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServicePath"];
    NSString *webServiceUploadPDF = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceUploadPDF"];
    NSURL *url = [NSURL URLWithString:[[webServicePath stringByAppendingFormat:webServiceUploadPDF, self.folder] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Body
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"Content-Length %d", [data length]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n\r\n\r\n--\r\nContent-Disposition: form-data; name=\"pdf\";filename=\"Enunciado.pdf\"\r\nContent-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n----\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data; boundary= " forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
}

-(void)sendTweet
{
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [composeViewController setInitialText:[NSString stringWithFormat:@"Se ha publicado el enunciado para la %@.", self.folder]];
        [self presentViewController:composeViewController animated:YES completion:Nil];
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[DetailSplitViewController class]]) {
        if ([segue.identifier isEqualToString:@"rate"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setFolder:)]) {
                [segue.destinationViewController performSelector:@selector(setFolder:) withObject:self.folder];
            }
            
            if ([segue.destinationViewController respondsToSelector:@selector(setVideo:)]) {
                [segue.destinationViewController performSelector:@selector(setVideo:) withObject:self.video];
            }
        } else if ([segue.identifier isEqualToString:@"getRate"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setFolder:)]) {
                [segue.destinationViewController performSelector:@selector(setFolder:) withObject:self.folder];
            }
            
            if ([segue.destinationViewController respondsToSelector:@selector(setVideo:)]) {
                [segue.destinationViewController performSelector:@selector(setVideo:) withObject:self.video];
            }
        }
    }
}

@end