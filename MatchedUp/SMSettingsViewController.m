//
//  SMSettingsViewController.m
//  MatchedUp
//
//  Created by Shikhar Mohan on 9/9/14.
//  Copyright (c) 2014 Shikhar Mohan. All rights reserved.
//

#import "SMSettingsViewController.h"

@interface SMSettingsViewController ()
@property (strong, nonatomic) IBOutlet UISlider *ageSilder;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singleSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;

@end

@implementation SMSettingsViewController

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
- (IBAction)logoutButtonPressed:(UIButton *)sender {
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender {
}


@end
