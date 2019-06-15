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
    
    [self.navigationController.navigationBar sizeThatFits:CGSizeMake(self.view.frame.size.width, 64)];
    
    _infoTable.alwaysBounceVertical = NO;
    
    UINib *nib = [UINib nibWithNibName:@"InfoTableViewCell" bundle:nil];
    [_infoTable registerNib:nib forCellReuseIdentifier:@"InfoPhotoCell"];
    NSLog(@"%@ phone number", _phoneNumber);
    
    [self setHeaderConstraints];
    
    CGFloat height = self.view.frame.size.height/2;
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
    
    cell.infoLabel.text = _phones[indexPath.row];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

        NSLog(@"My name is -  %@" , _fullName);
    
    return self.header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 300;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)setHeaderConstraints{
    
     _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _infoTable.frame.size.width, 300)];
     _conteiner = [[UIView alloc] initWithFrame:_header.frame];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(_conteiner.frame.size.width / 2 - 75 , 40, 150, 150)];
    [_icon setImage:_infoImage];
    _icon.layer.cornerRadius = CGRectGetHeight(_icon.frame) / 2;
    _icon.clipsToBounds = YES;
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _icon.frame.size.height + 70, _conteiner.frame.size.width, 40)];
    _label.text = _fullName;
    _label.numberOfLines = 0; 
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];

   
    [_conteiner addSubview:_label];
    [_conteiner addSubview:_icon];
    [_header addSubview:_conteiner];
    _conteiner.center = _icon.center;
     _conteiner.layer.borderWidth = 0;
     _conteiner.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [_conteiner.heightAnchor constraintEqualToAnchor:_header.heightAnchor constant:0],
                                              ]];
    
    
}

@end
