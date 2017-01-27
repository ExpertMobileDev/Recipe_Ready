//
//  SocialFeedVC.h
//  Recipe Ready
//
//  Created by mac on 11/21/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialFeedVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *socialFeedTblView;

- (void)refreshFollowInfo;
@end
