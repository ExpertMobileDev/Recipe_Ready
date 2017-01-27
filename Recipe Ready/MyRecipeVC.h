//
//  MyRecipeVC.h
//  Recipe Ready
//
//  Created by mac on 11/23/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecipeVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblCreatedTab;
@property (weak, nonatomic) IBOutlet UILabel *lblFavoriteTab;
@property (weak, nonatomic) IBOutlet UIView *favorBottomBar;
@property (weak, nonatomic) IBOutlet UIView *createBottomBar;
@property (weak, nonatomic) IBOutlet UICollectionView *favoriteCollectView;
@property (weak, nonatomic) IBOutlet UIView *favoriteView;
@property (weak, nonatomic) IBOutlet UICollectionView *createdCollectView;
@property (weak, nonatomic) IBOutlet UIView *createdView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateRecipe;

- (IBAction)selectCreatedTab:(id)sender;
- (IBAction)selectFavorTab:(id)sender;
- (IBAction)createNewRecipe:(id)sender;

- (void)refreshFavoriteData;
- (void)refreshCreatedData;

@end
