//
//  MyIngredientVC.h
//  Recipe Ready
//
//  Created by mac on 11/20/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIngredientVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ingreditTblView;
@property (weak, nonatomic) IBOutlet UIView *addIngredientView;
@property (weak, nonatomic) IBOutlet UISearchBar *ingredientSearch;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTblView;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *selectUnitView;
@property (weak, nonatomic) IBOutlet UITableView *unitTblView;

- (IBAction)addIngredientBySearch:(id)sender;
- (IBAction)addIngredientByBarcode:(id)sender;
- (IBAction)editIngredient:(id)sender;
- (IBAction)addIngredients:(id)sender;

- (void)minusAmount:(int) nId;
- (void)plusAmount:(int) nId;
- (void)changeUnits:(int)nId;
- (void)refreshData;

@end
