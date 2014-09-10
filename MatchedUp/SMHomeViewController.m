//
//  SMHomeViewController.m
//  MatchedUp
//
//  Created by Shikhar Mohan on 9/9/14.
//  Copyright (c) 2014 Shikhar Mohan. All rights reserved.
//

#import "SMHomeViewController.h"

@interface SMHomeViewController ()
@property (strong, nonatomic) IBOutlet UINavigationItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *taglineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSMutableArray *activities; //keep track of who we like, dislike

@property (nonatomic) int currentPhotoIndex; //current photo displayed
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;

@end

@implementation SMHomeViewController

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
    //disable all buttons on load
    self.likeButton.enabled = NO;
    self.infoButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    
    //show first photo
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kSMActivityPhotoKey];
    [query includeKey:kSMPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
            [self updateView];
        }
        else{
            NSLog(@"%@", error);
        }
    }];
    
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

- (IBAction)infoButtonPressed:(id)sender
{
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
}



- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender

{
}



- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
}

#pragma mark - Helper methods

- (void) queryForCurrentPhotoIndex{
    if([self.photos count] > 0){
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kSMPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error)
            {   //convert NSData to UIImage
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
            }
            else NSLog(@"%@", error);
        }];
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kSMActivityClassKey];
        [queryForLike whereKey:kSMActivityTypeKey equalTo:kSMActivityTypeLikeKey];
        [queryForLike whereKey:kSMActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kSMActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kSMActivityClassKey];
        [queryForDislike whereKey:kSMActivityTypeKey equalTo:kSMActivityTypeDislikeKey];
        [queryForDislike whereKey:kSMActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kSMActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                self.activities = [objects mutableCopy];
                if([self.activities count] == 0){
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                }
                else{
                    PFObject *activity = self.activities[0];
                    if([activity[kSMActivityTypeKey] isEqualToString:kSMActivityTypeLikeKey]){
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    else if([activity[kSMActivityTypeKey] isEqualToString:kSMActivityTypeDislikeKey]){
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    }
                    else{
                        //some other activity
                    };
                }
                self.likeButton.enabled =  YES;
                self.dislikeButton.enabled = YES;
            }
        }];

    }
}

- (void) updateView
{
    self.nameLabel.text = self.photo[kSMPhotoUserKey][kSMUserProfileKey][kSMUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@",self.photo[kSMPhotoUserKey][kSMUserProfileKey][kSMUserProfileAgeKey]];
    self.taglineLabel.text = self.photo[kSMPhotoUserKey][kSMUserTagLineKey];
}

- (void)setupNextPhoto
{
    if(self.currentPhotoIndex + 1 < [self.photos count])
    {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check back later for more people!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

}

- (void) saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kSMActivityClassKey];
    [likeActivity setObject:kSMActivityTypeLikeKey forKey:kSMActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kSMActivityFromUserKey]; //when current user likes a photo, it is the current user
    [likeActivity setObject:[self.photo objectForKey:kSMActivityToUserKey] forKey:kSMActivityToUserKey]; //which user owns this photo
    [likeActivity setObject:self.photo forKey:kSMActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self setupNextPhoto];
    }];
    
}

- (void) saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kSMActivityClassKey];
    [dislikeActivity setObject:kSMActivityTypeDislikeKey forKey:kSMActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kSMActivityFromUserKey]; //when current user likes a photo, it is the current user
    [dislikeActivity setObject:[self.photo objectForKey:kSMPhotoUserKey] forKey:kSMActivityToUserKey]; //which user owns this photo
    [dislikeActivity setObject:self.photo forKey:kSMActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject:dislikeActivity];
        [self setupNextPhoto];
    }];
}

- (void) checkLike
{
    if(self.isLikedByCurrentUser){
        [self setupNextPhoto];
        return;
    }
    else if(self.isDislikedByCurrentUser){
        for(PFObject *activity in self.activities){
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else{
        [self saveLike];
    }
}

- (void) checkDislike
{
    if(self.isDislikedByCurrentUser){
        [self setupNextPhoto];
        return;
    }
    else if(self.isLikedByCurrentUser){
        for(PFObject *activity in self.activities){
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else{
        [self saveDislike];
    }
}

@end














