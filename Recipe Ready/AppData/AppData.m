//
//  AppData.m
//  Dopple
//
//  Created by Mitchell Williams on 21/08/2015.
//  Copyright (c) 2015 Mitchell Williams. All rights reserved.
//

#import "AppData.h"
#import "AFAppDotNetAPIClient.h"

@implementation AppData

#pragma mark - Initialization
+ (AppData*) sharedData
{
    static AppData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
	
    return sharedInstance;
}

+ (BOOL) isNullOrEmptyString:(NSString *)inString
{
    BOOL retVal = YES;
    
    if (inString != nil) {
        if ([inString isKindOfClass:[NSString class]]) {
            retVal = inString.length == 0;
        } else {
            NSLog(@"isNullOrEmpty, value not a string");
        }
    }
    return retVal;
}

+(BOOL)validateEmail:(NSString *)emailStr
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:emailStr];
}


- (id) init
{
    self = [super init];
    if (self)
    {
        _me = [[User alloc] init];
        [_me load];
    }
    
    return self;
}


- (void) setBRemember:(BOOL)bRemember
{
	[UD setBool:bRemember forKey:kBRemember];
	[UD synchronize];
}


- (BOOL) bRemember
{
	return [UD boolForKey:kBRemember];
}

- (void) setBRemoveAds:(BOOL)bRemoveAds
{
	[UD setBool:bRemoveAds forKey:kBRemoveAds];
	[UD synchronize];
}

- (BOOL) bRemoveAds
{
	return [UD boolForKey:kBRemoveAds];
}

- (void) setBFavorite:(BOOL)bFavorite
{
	[UD setBool:bFavorite forKey:kBFavorite];
	[UD synchronize];
}

- (BOOL) bFavorite
{
	return [UD boolForKey:kBFavorite];
}

- (void) setBNewFollower:(BOOL)bNewFollower
{
	[UD setBool:bNewFollower forKey:kBFollower];
	[UD synchronize];
}

- (BOOL) bNewFollower
{
	return [UD boolForKey:kBFollower];
}

- (void) setBShare:(BOOL)bShare
{
	[UD setBool:bShare forKey:kBShare];
	[UD synchronize];
}

- (BOOL) bShare
{
	return [UD boolForKey:kBShare];
}

- (void) setBLoggedIn:(BOOL)bLoggedIn
{
    [UD setBool:bLoggedIn forKey:kBLoggedIn];
    [UD synchronize];
}

- (BOOL) bLoggedIn
{
    return [UD boolForKey:kBLoggedIn];
}

- (void) setNCreateMode:(int)nCreateMode
{
	[UD setInteger:nCreateMode forKey:kNCreateMode];
	[UD synchronize];
}

- (int) nCreateMode
{
	return (int)[UD integerForKey:kNCreateMode];
}

- (void) setNMyRecipeShowMode:(int)nMyRecipeShowMode
{
	[UD setInteger:nMyRecipeShowMode forKey:kNMyRecipeShowMode];
	[UD synchronize];
}

- (int) nMyRecipeShowMode
{
	return (int)[UD integerForKey:kNMyRecipeShowMode];
}

- (void) setNSelectRecipeIndex:(int)nSelectRecipeIndex
{
	[UD setInteger:nSelectRecipeIndex forKey:kNSelectedIndex];
	[UD synchronize];
}

- (int) nSelectRecipeIndex
{
	return (int)[UD integerForKey:kNSelectedIndex];
}

- (void)showAlertAndReturn:(NSString *)_message andController:(UIViewController*) controller
{
	UIAlertController * alert = [UIAlertController
								 alertControllerWithTitle:@""
								 message:_message
								 preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* okButton = [UIAlertAction
							   actionWithTitle:@"OK"
							   style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction * action) {
								   //Handle your yes please button action here
								   [controller.navigationController popToRootViewControllerAnimated:YES];
							   }];
	
	[alert addAction:okButton];
	
	[controller presentViewController:alert animated:YES completion:nil];
}

- (void) setArrFavorite:(NSMutableArray *)arrFavorite
{
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrFavorite];
	
	[UD setObject:encodedObject forKey:kFavorite];
	[UD synchronize];
}

- (NSMutableArray*) arrFavorite
{
	NSData *encodedObject = [UD objectForKey:kFavorite];
	
	NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
	
	NSMutableArray* arrResult = nil;
	if (!arrTemp)
	{
		arrResult = [NSMutableArray new];
	}
	else
	{
		arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
	}
	
	return arrResult;
}

- (void) setArrCreated:(NSMutableArray *)arrCreated
{
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrCreated];
	
	[UD setObject:encodedObject forKey:kCreated];
	[UD synchronize];
}

- (NSMutableArray*) arrCreated
{
	NSData *encodedObject = [UD objectForKey:kCreated];
	
	NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
	
	NSMutableArray* arrResult = nil;
	if (!arrTemp)
	{
		arrResult = [NSMutableArray new];
	}
	else
	{
		arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
	}
	
	return arrResult;
}

- (void) setArrPosted:(NSMutableArray *)arrPosted
{
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrPosted];
	
	[UD setObject:encodedObject forKey:kPosted];
	[UD synchronize];
}

- (NSMutableArray*) arrPosted
{
	NSData *encodedObject = [UD objectForKey:kPosted];
	
	NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
	
	NSMutableArray* arrResult = nil;
	if (!arrTemp)
	{
		arrResult = [NSMutableArray new];
	}
	else
	{
		arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
	}
	
	return arrResult;
}

- (void) setArrBasket:(NSMutableArray *)arrBasket
{
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrBasket];
	
	[UD setObject:encodedObject forKey:kBasket];
	[UD synchronize];
}

- (NSMutableArray*) arrBasket
{
	NSData *encodedObject = [UD objectForKey:kBasket];
	
	NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
	
	NSMutableArray* arrResult = nil;
	if (!arrTemp)
	{
		arrResult = [NSMutableArray new];
	}
	else
	{
		arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
	}
	
	return arrResult;
}

- (void) setArrRate:(NSMutableArray *)arrRate
{
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrRate];
	
	[UD setObject:encodedObject forKey:kRate];
	[UD synchronize];
}

- (NSMutableArray*) arrRate
{
	NSData *encodedObject = [UD objectForKey:kRate];
	
	NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
	
	NSMutableArray* arrResult = nil;
	if (!arrTemp)
	{
		arrResult = [NSMutableArray new];
	}
	else
	{
		arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
	}
	
	return arrResult;
}

- (void) setArrSelectedIngredients:(NSMutableArray *)arrSelectedIngredients
{
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrSelectedIngredients];
	
	[UD setObject:encodedObject forKey:kSelectedIngredients];
	[UD synchronize];
}

- (NSMutableArray*) arrSelectedIngredients
{
	NSData *encodedObject = [UD objectForKey:kSelectedIngredients];
	
	NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
	
	NSMutableArray* arrResult = nil;
	if (!arrTemp)
	{
		arrResult = [NSMutableArray new];
	}
	else
	{
		arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
	}
	
	return arrResult;
}


#pragma mark-AlertView
- (void)showAlertTips:(NSString *)_message
{
	UIAlertView *messageView = [[UIAlertView alloc] initWithTitle:@"Error"
														  message:_message
														 delegate:self
												cancelButtonTitle:@"Ok"
												otherButtonTitles:nil, nil];
	[messageView show];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)_message
{
    UIAlertView *messageView = [[UIAlertView alloc] initWithTitle:title
                                                          message:_message
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil, nil];
    [messageView show];
}

#pragma mark - String
- (NSString *) strSelectedImgName
{
	return [UD stringForKey:kStrImageName];
}

- (void) setStrSelectedImgName:(NSString *)strSelectedImgName
{
	[UD setObject:strSelectedImgName forKey:kStrImageName];
	[UD synchronize];
}

- (NSString *) strProfilePhotoOption
{
	return [UD stringForKey:kStrProfilePhotoOption];
}

- (void) setStrProfilePhotoOption:(NSString *)strProfilePhotoOption
{
	[UD setObject:strProfilePhotoOption forKey:kStrProfilePhotoOption];
	[UD synchronize];
}

- (NSString *) strCreateRecipeOption
{
	return [UD stringForKey:kStrCreatedRecipeOption];
}

- (void) setStrCreateRecipeOption:(NSString *)strCreateRecipeOption
{
	[UD setObject:strCreateRecipeOption forKey:kStrCreatedRecipeOption];
	[UD synchronize];
}

- (NSString *) strUserId
{
	return [UD stringForKey:kCurrentUserId];
}

- (void) setStrUserId:(NSString *)strUserId
{
	[UD setObject:strUserId forKey:kCurrentUserId];
	[UD synchronize];
}


#pragma mark - Get Current time

- (NSString *)getCurrentTime
{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"MM/dd HH:mm a"];
    NSString    *strTime = [objDateformat stringFromDate:[NSDate date]];
    return strTime;
}

- (NSString *)getCurrentEstTime
{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm a"];
    NSString *strTime = [objDateformat stringFromDate:[NSDate date]];
    NSString *estTime = [self convertTimeZoneFromDateString:strTime];
    return estTime;
}


-(NSString * )convertTimeZoneFromDateString:(NSString *)string
{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    
    // from server dateFormat
    [format setDateFormat:@"yyyy-MM-dd HH:mm a"];
    
    // get date from server
    NSDate * dateTemp = [format dateFromString:string];
    
    // new date format
    [format setDateFormat:@"yyyy-MM-dd HH:mm a"];
    
    // convert Timezone
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:dateTemp];
    
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:dateTemp];
    
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    // get final date in LocalTimeZone
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:dateTemp];
    
    // convert to String
    NSString *dateStr = [format stringFromDate:destinationDate];
    
    return dateStr;
}


- (NSString *)getCurrentTimeStamp
{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString    *strTime = [objDateformat stringFromDate:[NSDate date]];
    NSString    *strUTCTime = [self getUTCDateTimeFromLocalTime:strTime];//You can pass your date but be carefull about your date format of NSDateFormatter.
    NSDate *objUTCDate  = [objDateformat dateFromString:strUTCTime];
    long long milliseconds = (long long)([objUTCDate timeIntervalSince1970] * 1000.0);
    
    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    NSLog(@"The Timestamp is = %@",strTimeStamp);
    return strTimeStamp;
}


- (NSString *) getUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return strDateTime;
}

- (NSString *) getESTDateTimeFromLocalTime:(NSString *)IN_strLocalTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm a"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return [AppData isNullOrEmptyString:strDateTime] ? @"" : [NSString stringWithFormat:@"%@ EST", strDateTime];
}

-(NSString *) randomStringWithLength: (int) len {
	NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	
	NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
	for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
	}
	
	return randomString;
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return destImage;
}


#pragma mark- Add the recipe and ingredients to Firebase
- (NSString*)addIngredientToFirebase:(Ingredient*) aIngredient {
	NSMutableDictionary* dicIngredient = [[NSMutableDictionary alloc] init];
	[dicIngredient setObject:[NSNumber numberWithInteger:aIngredient.index] forKey:kIngredientId];
	[dicIngredient setObject:aIngredient.name forKey:kIngredientName];
	[dicIngredient setObject:aIngredient.originalString forKey:kIngredientOriginal];
	[dicIngredient setObject:aIngredient.snapkey forKey:kSnapKey];
	[dicIngredient setObject:[NSNumber numberWithFloat:aIngredient.amount] forKey:kIngredientAmount];
	[dicIngredient setObject:aIngredient.unit forKey:kIngredientUnit];
	
	NSString* strImgName = @"";
	if (![AppData isNullOrEmptyString:aIngredient.imgName])
		strImgName = aIngredient.imgName;
	[dicIngredient setObject:strImgName forKey:kIngredientImgName];
	
	return [self createNewIngredient:dicIngredient];
}

- (NSString*) createNewIngredient:(NSMutableDictionary*) dicIngredient {
	FIRDatabaseReference* ingreRef = [FIRIngredient childByAutoId];
	[ingreRef setValue:dicIngredient];
	
	return ingreRef.key;
}

- (NSString*)addRecipeToFavorite:(RecipeDetail*) aRecipe {
	NSMutableDictionary* dicRecipe = [[NSMutableDictionary alloc] init];
	[dicRecipe setObject:[NSNumber numberWithInteger:aRecipe.index] forKey:kRecipeId];
	[dicRecipe setObject:aRecipe.title forKey:kRecipeTitle];
	[dicRecipe setObject:aRecipe.instructions forKey:kRecipeInstruction];
	[dicRecipe setObject:@"" forKey:kSnapKey];
	[dicRecipe setObject:aRecipe.userid forKey:kUserId];
	[dicRecipe setObject:aRecipe.createdDateTime forKey:kRecipeDateTime];
	
	NSString* strImgName = @"";
	if (![AppData isNullOrEmptyString:aRecipe.imageName])
		strImgName = aRecipe.imageName;
	[dicRecipe setObject:strImgName forKey:kRecipeImgName];
	
	NSMutableArray* arrIngredient = [[NSMutableArray alloc] init];
	for (Ingredient* aIngredient in aRecipe.arrIngredients) {
		NSMutableDictionary* dicIngredient = [[NSMutableDictionary alloc] init];
		[dicIngredient setObject:[NSNumber numberWithInteger:aIngredient.index] forKey:kIngredientId];
		[dicIngredient setObject:aIngredient.name forKey:kIngredientName];
		[dicIngredient setObject:aIngredient.originalString forKey:kIngredientOriginal];
		NSString* strImgName = @"";
		if (![AppData isNullOrEmptyString:aIngredient.imgName])
			strImgName = aIngredient.imgName;
		[dicIngredient setObject:strImgName forKey:kIngredientImgName];
		[dicIngredient setObject:[NSNumber numberWithFloat:aIngredient.amount] forKey:kIngredientAmount];
		[dicIngredient setObject:aIngredient.unit forKey:kIngredientUnit];
		[arrIngredient addObject:dicIngredient];
	}
	[dicRecipe setObject:arrIngredient forKey:kRecipeIngredient];
	
	return [self createNewFavoriteRecipe:dicRecipe];
}

- (NSString*) createNewFavoriteRecipe:(NSMutableDictionary*) dicRecipe {
	FIRDatabaseReference* ingreRef = [FIRFavoriteRecipe childByAutoId];
	[ingreRef setValue:dicRecipe];
	
	return ingreRef.key;
}

- (NSString*)addCreatedRecipeToFirebase:(RecipeDetail*) aRecipe {
	NSMutableDictionary* dicRecipe = [[NSMutableDictionary alloc] init];
	[dicRecipe setObject:[NSNumber numberWithInteger:aRecipe.index] forKey:kRecipeId];
	[dicRecipe setObject:aRecipe.title forKey:kRecipeTitle];
	[dicRecipe setObject:aRecipe.instructions forKey:kRecipeInstruction];
	NSString* strImgName = @"";
	if (![AppData isNullOrEmptyString:aRecipe.imageName])
		strImgName = aRecipe.imageName;
	[dicRecipe setObject:strImgName forKey:kRecipeImgName];
	[dicRecipe setObject:aRecipe.snapkey forKey:kSnapKey];
	[dicRecipe setObject:aRecipe.userid forKey:kUserId];
	[dicRecipe setObject:aRecipe.createdDateTime forKey:kRecipeDateTime];

	NSMutableArray* arrIngredient = [[NSMutableArray alloc] init];
	for (Ingredient* aIngredient in aRecipe.arrIngredients) {
		NSMutableDictionary* dicIngredient = [[NSMutableDictionary alloc] init];
		[dicIngredient setObject:[NSNumber numberWithInteger:aIngredient.index] forKey:kIngredientId];
		[dicIngredient setObject:aIngredient.name forKey:kIngredientName];
		[dicIngredient setObject:aIngredient.originalString forKey:kIngredientOriginal];
		NSString* strImgName = @"";
		if (![AppData isNullOrEmptyString:aIngredient.imgName])
			strImgName = aIngredient.imgName;
		[dicIngredient setObject:strImgName forKey:kIngredientImgName];
		[dicIngredient setObject:[NSNumber numberWithFloat:aIngredient.amount] forKey:kIngredientAmount];
		[dicIngredient setObject:aIngredient.unit forKey:kIngredientUnit];
		[arrIngredient addObject:dicIngredient];
	}
	[dicRecipe setObject:arrIngredient forKey:kRecipeIngredient];
	
	return [self createdRecipe:dicRecipe];
}

- (NSString*) createdRecipe:(NSMutableDictionary*) dicRecipe {
	FIRDatabaseReference* createdRef = [FIRCreatedRecipe childByAutoId];
	[createdRef setValue:dicRecipe];
	
	return createdRef.key;
}

- (NSString*)addPostedRecipeToPersonalData:(RecipeDetail*) aRecipe {
	NSMutableDictionary* dicRecipe = [[NSMutableDictionary alloc] init];
	[dicRecipe setObject:[NSNumber numberWithInteger:aRecipe.index] forKey:kRecipeId];
	[dicRecipe setObject:aRecipe.title forKey:kRecipeTitle];
	[dicRecipe setObject:aRecipe.instructions forKey:kRecipeInstruction];
	NSString* strImgName = @"";
	if (![AppData isNullOrEmptyString:aRecipe.imageName])
		strImgName = aRecipe.imageName;
	[dicRecipe setObject:strImgName forKey:kRecipeImgName];
	[dicRecipe setObject:aRecipe.snapkey forKey:kSnapKey];
	[dicRecipe setObject:aRecipe.userid forKey:kUserId];
	[dicRecipe setObject:aRecipe.createdDateTime forKey:kRecipeDateTime];
	
	NSMutableArray* arrIngredient = [[NSMutableArray alloc] init];
	for (Ingredient* aIngredient in aRecipe.arrIngredients) {
		NSMutableDictionary* dicIngredient = [[NSMutableDictionary alloc] init];
		[dicIngredient setObject:[NSNumber numberWithInteger:aIngredient.index] forKey:kIngredientId];
		[dicIngredient setObject:aIngredient.name forKey:kIngredientName];
		[dicIngredient setObject:aIngredient.originalString forKey:kIngredientOriginal];
		NSString* strImgName = @"";
		if (![AppData isNullOrEmptyString:aIngredient.imgName])
			strImgName = aIngredient.imgName;
		[dicIngredient setObject:strImgName forKey:kIngredientImgName];
		[dicIngredient setObject:[NSNumber numberWithFloat:aIngredient.amount] forKey:kIngredientAmount];
		[dicIngredient setObject:aIngredient.unit forKey:kIngredientUnit];
		[arrIngredient addObject:dicIngredient];
	}
	[dicRecipe setObject:arrIngredient forKey:kRecipeIngredient];
	
	return [self postRecipeToPersonalData:dicRecipe];
}

- (NSString*) postRecipeToPersonalData:(NSMutableDictionary*) dicRecipe {
	FIRDatabaseReference* createdRef = [FIRPostedRecipePerUser childByAutoId];
	[createdRef setValue:dicRecipe];
	
	return createdRef.key;
}

- (NSString*)addPostedRecipeToGlobal:(RecipeDetail*) aRecipe {
	NSMutableDictionary* dicRecipe = [[NSMutableDictionary alloc] init];
	[dicRecipe setObject:[NSNumber numberWithInteger:aRecipe.index] forKey:kRecipeId];
	[dicRecipe setObject:aRecipe.title forKey:kRecipeTitle];
	[dicRecipe setObject:aRecipe.instructions forKey:kRecipeInstruction];
	NSString* strImgName = @"";
	if (![AppData isNullOrEmptyString:aRecipe.imageName])
		strImgName = aRecipe.imageName;
	[dicRecipe setObject:strImgName forKey:kRecipeImgName];
	[dicRecipe setObject:aRecipe.snapkey forKey:kSnapKey];
	[dicRecipe setObject:aRecipe.userid forKey:kUserId];
	[dicRecipe setObject:aRecipe.createdDateTime forKey:kRecipeDateTime];
	
	NSMutableArray* arrIngredient = [[NSMutableArray alloc] init];
	for (Ingredient* aIngredient in aRecipe.arrIngredients) {
		NSMutableDictionary* dicIngredient = [[NSMutableDictionary alloc] init];
		[dicIngredient setObject:[NSNumber numberWithInteger:aIngredient.index] forKey:kIngredientId];
		[dicIngredient setObject:aIngredient.name forKey:kIngredientName];
		[dicIngredient setObject:aIngredient.originalString forKey:kIngredientOriginal];
		NSString* strImgName = @"";
		if (![AppData isNullOrEmptyString:aIngredient.imgName])
			strImgName = aIngredient.imgName;
		[dicIngredient setObject:strImgName forKey:kIngredientImgName];
		[dicIngredient setObject:[NSNumber numberWithFloat:aIngredient.amount] forKey:kIngredientAmount];
		[dicIngredient setObject:aIngredient.unit forKey:kIngredientUnit];
		[arrIngredient addObject:dicIngredient];
	}
	[dicRecipe setObject:arrIngredient forKey:kRecipeIngredient];
	
	return [self postRecipeToGlobal:dicRecipe];
}

- (NSString*) postRecipeToGlobal:(NSMutableDictionary*) dicRecipe {
	FIRDatabaseReference* createdRef = [FIRPostedRecipe childByAutoId];
	[createdRef setValue:dicRecipe];
	
	return createdRef.key;
}

- (NSString*)addUserInfoToPersonalData:(UserInfo*) aUser {
	NSMutableDictionary* dicUserInfo = [[NSMutableDictionary alloc] init];
	[dicUserInfo setObject:aUser.email forKey:kEmail];
	[dicUserInfo setObject:aUser.username forKey:kUserName];
	[dicUserInfo setObject:aUser.password forKey:kPass];
	[dicUserInfo setObject:aUser.user_id forKey:kUserId];
	[dicUserInfo setObject:aUser.avatarName forKey:kUserAvatar];
	[dicUserInfo setObject:[NSNumber numberWithInt:aUser.nFollowNum] forKey:kFollowNum];
	[dicUserInfo setObject:[NSNumber numberWithInt:aUser.nFriendNum] forKey:kFriendNum];
	[dicUserInfo setObject:[NSNumber numberWithInt:aUser.nFollowingNum] forKey:kFollowingNum];
	[dicUserInfo setObject:[NSNumber numberWithBool:aUser.bFacebookLogin] forKey:kBFacebookLogin];
	[dicUserInfo setObject:aUser.readPhotoOption forKey:kStrProfilePhotoOption];
	[dicUserInfo setObject:aUser.readCreatedRecipeOption forKey:kStrCreatedRecipeOption];

	return [self creatNewUser:dicUserInfo];
}

- (NSString*) creatNewUser:(NSMutableDictionary*) dicUserInfo {
	FIRDatabaseReference* createdUserRef = [FIRPersonalData child:kUser];
	[createdUserRef setValue:dicUserInfo];
	
	return createdUserRef.key;
}

- (NSString*)addUserInfoToUserList:(UserInfo*) aUser {
	NSMutableDictionary* dicUserInfo = [[NSMutableDictionary alloc] init];
	[dicUserInfo setObject:aUser.email forKey:kEmail];
	[dicUserInfo setObject:aUser.username forKey:kUserName];
	[dicUserInfo setObject:aUser.password forKey:kPass];
	[dicUserInfo setObject:aUser.user_id forKey:kUserId];
	[dicUserInfo setObject:aUser.avatarName forKey:kUserAvatar];
	[dicUserInfo setObject:[NSNumber numberWithInt:aUser.nFollowNum] forKey:kFollowNum];
	[dicUserInfo setObject:[NSNumber numberWithInt:aUser.nFriendNum] forKey:kFriendNum];
	[dicUserInfo setObject:[NSNumber numberWithInt:aUser.nFollowingNum] forKey:kFollowingNum];
	[dicUserInfo setObject:[NSNumber numberWithBool:aUser.bFacebookLogin] forKey:kBFacebookLogin];
	[dicUserInfo setObject:aUser.readPhotoOption forKey:kStrProfilePhotoOption];
	[dicUserInfo setObject:aUser.readCreatedRecipeOption forKey:kStrCreatedRecipeOption];

	return [self addNewUser:dicUserInfo];
}

- (NSString*) addNewUser:(NSMutableDictionary*) dicUserInfo {
	FIRDatabaseReference* createdUserRef = [FIRUsers childByAutoId];
	[createdUserRef setValue:dicUserInfo];
	
	return createdUserRef.key;
}

- (NSString*)addUserInfoToFollowingList:(NSString*) userId {
	NSMutableDictionary* dicUserInfo = [[NSMutableDictionary alloc] init];
	[dicUserInfo setObject:userId forKey:kUserId];
	
	return [self addFollowingUser:dicUserInfo];
}

- (NSString*) addFollowingUser:(NSMutableDictionary*) dicUserInfo {
	FIRDatabaseReference* createdUserRef = [FIRFollowing childByAutoId];
	[createdUserRef setValue:dicUserInfo];
	
	return createdUserRef.key;
}



@end
