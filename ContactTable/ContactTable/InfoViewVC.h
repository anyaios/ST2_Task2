//
//  InfoViewVC.h
//  ContactTable
//
//  Created by Anna Ershova on 6/14/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface InfoViewVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *infoTable;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImage *infoImage;
@property (nonatomic, strong) NSString *fullName;

@end


