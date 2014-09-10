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
}

- (IBAction)likeButtonPressed:(UIButton *)sender
{
}



- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender

{
}



- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
}


@end
