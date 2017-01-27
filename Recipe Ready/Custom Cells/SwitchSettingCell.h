//
//  SwitchSettingCell.h
//  Recipe Ready
//
//  Created by mac on 12/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblSettingName;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;

@end
