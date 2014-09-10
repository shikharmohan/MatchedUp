//
//  SMConstants.h
//  MatchedUp
//
//  Created by Shikhar Mohan on 9/5/14.
//  Copyright (c) 2014 Shikhar Mohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMConstants : NSObject

#pragma mark - User Class

extern NSString *const kSMUserTagLineKey;

//immutable pointer to mutable NSString obj
extern NSString *const kSMUserProfileKey;
extern NSString *const kSMUserProfileNameKey;
extern NSString *const kSMUserProfileFirstNameKey;
extern NSString *const kSMUserProfileLocationKey;
extern NSString *const kSMUserProfileGenderKey;
extern NSString *const kSMUserProfileBirthdayKey;
extern NSString *const kSMUserProfileInterestedInKey;
extern NSString *const kSMUserProfilePictureURL;
extern NSString *const kSMUserProfileRelationshipStatusKey;
extern NSString *const kSMUserProfileAgeKey;



#pragma mark - Photo Class

extern NSString *const kSMPhotoClassKey;
extern NSString *const kSMPhotoUserKey;
extern NSString *const kSMPhotoPictureKey;

#pragma mark - Activity Class

extern NSString *const kSMActivityClassKey;
extern NSString *const kSMActivityTypeKey;
extern NSString *const kSMActivityFromUserKey;
extern NSString *const kSMActivityToUserKey;
extern NSString *const kSMActivityPhotoKey;
extern NSString *const kSMActivityTypeLikeKey;
extern NSString *const kSMActivityTypeDislikeKey;



@end
