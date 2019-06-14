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
@property (nonatomic, strong, readwrite) UIView *header;
@property (nonatomic, strong, readwrite) UILabel *label;
@property (nonatomic, strong, readwrite) UIView *conteiner;
@property (nonatomic, strong, readwrite) UIImageView *icon;



@end

@implementation InfoViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoTable.dataSource = self;
    self.infoTable.delegate = self;
    
    
    UINib *nib = [UINib nibWithNibName:@"InfoTableViewCell" bundle:nil];
    [_infoTable registerNib:nib forCellReuseIdentifier:@"InfoPhotoCell"];
    NSLog(@"%@ phone number", _phoneNumber);
    
  //  [self setHeaderConstraints];
    
    CGFloat height = 40;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _infoTable.bounds.size.width, height)];
    self.infoTable.tableHeaderView = view;
    self.infoTable.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _phones.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"InfoPhotoCell" forIndexPath:indexPath];
    cell.InfoLabel.text = _phones[indexPath.row];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
//    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
//    [icon setImage:_infoImage];
//    icon.layer.cornerRadius = CGRectGetHeight(icon.frame) / 2;
//    icon.clipsToBounds = YES;
//    [header addSubview:icon];
//
//    UILabel *infoName = [[UILabel alloc] initWithFrame: CGRectZero];
//    infoName.text = _fullName;
//    infoName.textAlignment = NSTextAlignmentCenter;
//    infoName.font = [UIFont systemFontOfSize:23 weight:NSDateFormatterMediumStyle];
//    NSLog(@"My name is -  %@" , _fullName);
//    //[icon addSubview:infoName];
//    header.layer.borderWidth = 2;
//    [header addSubview:infoName];
  //  [self setHeaderConstraints];
    _headerXib = _header;
    _labelXib.text = _fullName;
    _labelXib.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [_icon setImage:_infoImage];
    _icon.layer.cornerRadius = CGRectGetHeight(_icon.frame) / 2;
    _icon.clipsToBounds = YES;
    
    
    [_imageXib setImage:_icon.image];
    
    
    return self.headerXib;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    self.label.preferredMaxLayoutWidth = tableView.bounds.size.width;
    return [self.headerXib systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
