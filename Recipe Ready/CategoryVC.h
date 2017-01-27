//
//  CategoryVC.h
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *recipeCollectView;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;

@property (nonatomic, strong) NSString* strSearchKey;


- (IBAction)backAction:(id)sender;

@end
