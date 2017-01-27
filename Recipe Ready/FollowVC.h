//
//  FollowVC.h
//  Recipe Ready
//
//  Created by mac on 12/19/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *recipeCollectView;
@property (weak, nonatomic) IBOutlet UILabel *lblPostUserName;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeNum;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowNum;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

@property (nonatomic, strong) NSString* strUserId;

- (IBAction)followAction:(id)sender;
- (IBAction)backAction:(id)sender;

@end
