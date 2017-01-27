//
//  SearchRecipeVC.h
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchRecipeVC : UIViewController<UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *searchResultView;
@property (weak, nonatomic) IBOutlet UITableView *ingredientTblView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchMethod;

- (IBAction)selectSearchMode:(id)sender;
- (IBAction)backAction:(id)sender;

@end
