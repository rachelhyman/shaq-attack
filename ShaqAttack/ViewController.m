//
//  ViewController.m
//  ShaqAttack
//
//  Created by Rachel Hyman on 11/26/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "ViewController.h"
#import "SHQNetworkingUtility.h"

@interface ViewController () <UITextFieldDelegate>

@property BOOL isAuthorized;

@property (weak, nonatomic) IBOutlet UITextField *logInTextField;
@property (weak, nonatomic) IBOutlet UITextField *makeShaqTextField;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.logInTextField.delegate = self; 
    self.makeShaqTextField.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)logIn:(id)sender
{
    NSString *authString = self.logInTextField.text;
    [SHQNetworkingUtility logInWithAuthString:authString completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [self statusCodeFromResponse:response];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (statusCode == 200) {
                self.responseLabel.text = @"Authentication successful!";
                self.logInTextField.text = @"";
                self.isAuthorized = YES;
            } else {
                self.responseLabel.text = @"Authentication failed. Try again.";
                self.isAuthorized = NO;
            }
        }];
    }];
}

- (IBAction)makeShaq:(id)sender
{
    if (self.isAuthorized) {
        if ([self.makeShaqTextField.text length] > 0) {
            [SHQNetworkingUtility makeShaqWithBasketballs:self.makeShaqTextField.text completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSInteger statusCode = [self statusCodeFromResponse:response];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (statusCode == 201) {
                        self.responseLabel.text = [NSString stringWithFormat:@"You made a Shaq with %@ basketballs!", self.makeShaqTextField.text];
                        self.makeShaqTextField.text = @"";
                    } else if (statusCode == 403) {
                        self.responseLabel.text = @"Try giving Shaq some more basketballs.";
                    }
                }];
            }];
        } else {
            self.responseLabel.text = @"Give Shaq some basketballs!";
        }
    } else {
        self.responseLabel.text = @"You must authenticate to do this.";
    }
}

- (IBAction)checkShaq:(id)sender
{
    if (self.isAuthorized) {
        [SHQNetworkingUtility checkShaqTotalsWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSInteger statusCode = [self statusCodeFromResponse:response];
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (statusCode == 200) {
                    self.responseLabel.text = [NSString stringWithFormat:@"There are %@ Shaqs on the court with a total of %@ basketballs!", jsonDictionary[@"shaqTotal"], jsonDictionary[@"basketballTotal"]];
                } else {
                    self.responseLabel.text = @"Error";
                }
            }];
        }];
    } else {
        self.responseLabel.text = @"You must authenticate to do this.";
    }
}

- (IBAction)deleteShaq:(id)sender
{
    if (self.isAuthorized) {
        [SHQNetworkingUtility deleteShaqWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSInteger statusCode = [self statusCodeFromResponse:response];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (statusCode == 204) {
                    self.responseLabel.text = @"You just took a Shaq off the court!";
                } else if (statusCode == 500) {
                    self.responseLabel.text = @"There are no Shaqs to take away!";
                }
            }];
        }];
    } else {
       self.responseLabel.text = @"You must authenticate to do this.";
    }

}

- (NSInteger)statusCodeFromResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    return httpResponse.statusCode;
}

- (void)dismissKeyboard
{
    [self.logInTextField resignFirstResponder];
    [self.makeShaqTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
