//
//  GenerateRecipeVC.h
//  Recipe Ready
//
//  Created by mac on 12/10/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenerateRecipeVC : UIViewController<UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearch;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchResultCollectView;
@property (weak, nonatomic) IBOutlet UITableView *myIngredientTblView;

- (IBAction)backAction:(id)sender;

@end
