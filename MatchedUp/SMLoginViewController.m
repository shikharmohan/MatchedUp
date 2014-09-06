//
//  SMLoginViewController.m
//  MatchedUp
//
//  Created by Shikhar Mohan on 9/5/14.
//  Copyright (c) 2014 Shikhar Mohan. All rights reserved.
//

#import "SMLoginViewController.h"

@interface SMLoginViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong,nonatomic) NSMutableData *imageData; //query for infomation and build obj as info comes from FB
@end

@implementation SMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        if(!user){
            if(!error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Facebook Login was Cancelled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        else{
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
            
        }
    }];
}

#pragma mark  - Helper method

- (void) updateUserInformation
{
    FBRequest *req = [FBRequest requestForMe];
    [req startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            
            NSDictionary *userDictionary = (NSDictionary *)result;
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc]
                                               initWithCapacity:8];
            //create URLs
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookID]];
            
            //key validation,testing
            if(userDictionary[@"name"]){
                userProfile[kSMUserProfileNameKey] = userDictionary[@"name"];
            }
            if(userDictionary[@"first_name"]){
                userProfile[kSMUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if(userDictionary[@"location"][@"name"]){
                userProfile[kSMUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            if(userDictionary[@"gender"]){
                userProfile[kSMUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if(userDictionary[@"birthday"]){
                userProfile[kSMUserProfileBirthdayKey] = userDictionary[@"birthday"];
            }
            if(userDictionary[@"interested_in"]){
                userProfile[kSMUserProfileInterestedInKey] = userDictionary[@"interested_in"];
            }
            if([pictureURL absoluteString]){
                userProfile[kSMUserProfilePictureURL] = [pictureURL absoluteString];
            }
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            //get image
            
            [self requestImage];
            
        }
        else{
            NSLog(@"Error in FB request %@", error);
        }
    }];
}

- (void) uploadPFFileToParse:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if(!imageData){
        NSLog(@"image data not found");
        return;
    }
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            PFObject *photo = [PFObject objectWithClassName:kSMPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kSMPhotoUserKey];
            [photo setObject:photoFile forKey:kSMPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo Saved Successfully!");
            }];
        }
    }];
}

- (void) requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kSMPhotoClassKey];
    [query whereKey:kSMPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(number == 0)
        {
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kSMUserProfileKey][kSMUserProfilePictureURL]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if(!urlConnection){
                NSLog(@"Failed to download picture");
            }
            
        }
    }];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
}

@end
