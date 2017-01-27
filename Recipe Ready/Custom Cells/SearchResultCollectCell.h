//
//  SearchResultCollectCell.h
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface SearchResultCollectCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeName;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIButton *btnGoUserPostedData;

@end
