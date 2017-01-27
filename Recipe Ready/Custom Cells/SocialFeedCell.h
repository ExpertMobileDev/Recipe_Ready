//
//  SocialFeedCell.h
//  Recipe Ready
//
//  Created by mac on 11/21/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"


@class SocialFeedVC;
@interface SocialFeedCell : UITableViewCell
{
	NSArray* arrIngredients;
}

@property (weak, nonatomic) IBOutlet UIImageView *recipeImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeName;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UILabel *lblPosterName;
@property (weak, nonatomic) SocialFeedVC* viewController;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIView *favoriteView;
@property (weak, nonatomic) IBOutlet UIButton *btnGotoPersonData;

@end
