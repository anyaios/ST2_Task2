//
//  InfoViewVC.m
//  ContactTable
//
//  Created by Anna Ershova on 6/14/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import "InfoViewVC.h"
#import "MainTableViewController.h"
#import "InfoTableViewCell.h"

@interface InfoViewVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation InfoViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // MainTableViewController *vc = [MainTableViewController new];
    self.infoTable.dataSource = self;
    self.infoTable.delegate = self;
    
    
    UINib *nib = [UINib nibWithNibName:@"InfoTableViewCell" bundle:nil];
    [_infoTable registerNib:nib forCellReuseIdentifier:@"InfoPhotoCell"];
    //_phoneNumber = [NSString string];
//
//    MainTableViewController *vc = [MainTableViewController new];
//    vc.message = _phoneNumber;
    NSLog(@"%@ phone number", _phoneNumber);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"InfoPhotoCell" forIndexPath:indexPath];
    cell.InfoLabel.text = _phoneNumber;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *icon = [[UIImageView alloc] initWithImage:_infoImage];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 154, 154)];
    UILabel *infoName = [[UILabel alloc] initWithFrame: icon.frame];
    infoName.text = _fullName;
    NSLog(@"My name is -  %@" , _fullName);
    [icon addSubview:infoName];
    [header addSubview:icon];
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
} 
@end
