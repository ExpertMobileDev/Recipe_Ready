//
//  ExploreVC.h
//  Recipe Ready
//
//  Created by mac on 11/20/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreVC : UIViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (IBAction)gotoSearch:(id)sender;

@end
