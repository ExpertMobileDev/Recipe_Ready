//
//  ProfileVC.h
//  Recipe Ready
//
//  Created by mac on 11/23/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblFriendNum;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowNum;
@property (weak, nonatomic) IBOutlet UITableView *settingTblView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (IBAction)addAvatar:(id)sender;
@end
