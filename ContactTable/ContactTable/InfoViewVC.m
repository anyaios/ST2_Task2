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
    cell.InfoLabel.text = _phones[indexPath.row];
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
    self.label.preferredMaxLayoutWidth = tableView.bounds.size.width;
    return 300;
//    return [self.header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(void)setHeaderConstraints{
    
    _header = [[UIView alloc] initWithFrame:CGRectZero];
    _label = [[UILabel alloc] init];
    _label.text = _fullName;
    _label.numberOfLines = 0; //unlimited
    _label.textAlignment = NSTextAlignmentCenter;
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
  
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(_infoTable.frame.size.width/2  -75, _infoTable.frame.size.height /8 -75, 150, 150)];
    [_icon setImage:_infoImage];
    _icon.layer.cornerRadius = CGRectGetHeight(_icon.frame) / 2;
    _icon.clipsToBounds = YES;
    
    _conteiner = [[UIView alloc] initWithFrame:self.view.frame];
    [_conteiner addSubview:_label];
    [_conteiner addSubview:_icon];
    _conteiner.center = _icon.center;
    
    [_header addSubview:_conteiner];
  //  [_header addSubview:_label];
    _conteiner.layer.borderWidth = 0;
    
    _conteiner.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *horiz = @"H:|-[label]-|";
    NSArray *horizontalC = [NSLayoutConstraint constraintsWithVisualFormat:horiz options:0 metrics:nil views:@{@"label":self.label}];
    [self.conteiner addConstraints:horizontalC];
    
    NSString *horizontalFormat = @"H:|-[conteiner]-|";
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalFormat options:0 metrics:nil views:@{@"conteiner":self.conteiner}];
    [self.header addConstraints:horizontalConstraints];
    
    NSString *verticalFormat = @"V:|-[conteiner]-|";
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalFormat options:0 metrics:nil views:@{@"conteiner":self.conteiner}];
    [self.header addConstraints:verticalConstraints];
    
    
    
}

@end
