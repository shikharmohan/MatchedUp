//
//  SMConstants.m
//  MatchedUp
//
//  Created by Shikhar Mohan on 9/5/14.
//  Copyright (c) 2014 Shikhar Mohan. All rights reserved.
//

#import "SMConstants.h"

@implementation SMConstants

#pragma mark - User Class
NSString *const kSMUserTagLineKey               = @"tagLine";

NSString *const kSMUserProfileKey               = @"profile";
NSString *const kSMUserProfileNameKey           = @"name";
NSString *const kSMUserProfileFirstNameKey      = @"first_name";
NSString *const kSMUserProfileLocationKey       = @"location";
NSString *const kSMUserProfileGenderKey         = @"gender";
NSString *const kSMUserProfileBirthdayKey       = @"birthday";
NSString *const kSMUserProfileInterestedInKey   = @"interested_in";
NSString *const kSMUserProfilePictureURL        = @"pictureURL";
NSString *const kSMUserProfileAgeKey            = @"age";
NSString *const kSMUserProfileRelationshipStatusKey = @"relationshipStatus";

#pragma mark - Photo Class

NSString *const kSMPhotoClassKey            = @"Photo";
NSString *const kSMPhotoUserKey             = @"user";
NSString *const kSMPhotoPictureKey          = @"image";

#pragma mark - Activity Class
NSString *const kSMActivityClassKey             = @"Activity";
NSString *const kSMActivityTypeKey              = @"type";
NSString *const kSMActivityFromUserKey          = @"fromUser";
NSString *const kSMActivityToUserKey            = @"toUser";
NSString *const kSMActivityPhotoKey             = @"photo";
NSString *const kSMActivityTypeLikeKey          = @"like";
NSString *const kSMActivityTypeDislikeKey       = @"dislike";
@end
