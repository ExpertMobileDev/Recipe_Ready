//
//  NotificationPreferenceVC.h
//  Recipe Ready
//
//  Created by mac on 12/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationPreferenceVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *notificationTblView;

- (IBAction)backAction:(id)sender;

@end
