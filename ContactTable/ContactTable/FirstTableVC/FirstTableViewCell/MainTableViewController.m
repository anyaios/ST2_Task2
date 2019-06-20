//
//  MainTableViewController.m
//  ContactTable
//
//  Created by Anna Ershova on 6/8/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import "MainTableViewController.h"
#import "ContactObject.h"
#import "CustomTableViewCell.h"
#import "UIColor+HexColor.h"
#import "InfoViewVC.h"




@interface MainTableViewController () <UITableViewDelegate, UITableViewDataSource, CNContactViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *array;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0XF9F9F9"];
    [self addNavigation];
    
    _array = [NSMutableArray array];
    _helpArray = [NSMutableArray array];
    _dictionary = [NSMutableDictionary dictionary];
    _arrayWithDict =  [NSMutableArray array];
    [self fetchContactsandAuthorization];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
    [_mainTableView registerNib:nib forCellReuseIdentifier:@"CustomCell"];
    for (int i=0; i<_dictionary.allKeys.count; i++) {
        [_helpArray addObject:[NSNumber numberWithBool:NO]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [_mainTableView reloadData];
}


-(void)sort {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", @"[a-zA-Z0-9 @&$]*$"];
    NSArray *results = [self.sortedArray filteredArrayUsingPredicate:predicate];
    //NSLog(@"fullnames%@", results);
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", @"^[a-z0-9!&#]*$"];
    NSArray *results2 = [self.sortedArray filteredArrayUsingPredicate:predicate2];
    //NSLog(@"sumbols%@", results2);
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_sortedArray];
    [arr removeObjectsInArray:results];
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:arr];
    [arr2 removeObjectsInArray:results2];
    NSArray *newArray=[arr2 arrayByAddingObjectsFromArray:results];
    _finalArray = [newArray arrayByAddingObjectsFromArray:results2];
    NSLog(@"rus%@", _finalArray);
}

- (void)addNavigation {
    self.title = @"Контакты";
    [self.navigationController.navigationBar sizeThatFits:CGSizeMake(self.view.frame.size.width, 64)];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"0XE6E6E6"];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"0XFFFFFF"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0X000000"],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]}];
}

- (void)fetchContactsandAuthorization {
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            self.keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:self.keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            }
            else
            {
                NSString *fullName;
                ContactObject *object = [ContactObject new];
                NSMutableArray *contactNumbersArray = [[NSMutableArray alloc]init];
                for (CNContact *contact in cnContacts) {
                    NSMutableArray *contactArray = [[NSMutableArray alloc]init];
                    object.name = contact.givenName;
                    object.lastname = contact.familyName;
                    NSString *newName = [NSString string];
                    newName = [object.name substringFromIndex:0];
                    NSString *newLastname = [NSString string];
                    newLastname = [object.lastname substringFromIndex:0];
                    if (newLastname.length <= 0 ) {
                        fullName = newName;
                        NSLog(@".%lu.", (unsigned long)[object.name length]);
                        NSLog(@"name  .%@. ",object.name);
                    }else if (newName.length <= 0){
                        
                        fullName = newLastname;
                    }
                    else if (!(newName && newLastname)||!(newName)||!(newLastname)){
                        fullName = @"#";
                    } else {
                        fullName=[NSString stringWithFormat:@"%@ %@",newLastname,newName];
                    }
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        object.image = image;
                    } else {
                        object.image = [UIImage imageNamed:@"noPhoto"];
                    }
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        object.phone = [label.value stringValue];
                        if ([object.phone length] > 0) {
                            [contactNumbersArray addObject:object.phone];
                        }
                         [contactArray addObject: object.phone];
                    }
                    object.phoneNumbers = contactArray;
                    self.personDict = [[NSDictionary alloc] initWithObjectsAndKeys:  fullName,@"fullName",object.image,@"userImage",object.phone,@"phoneNumber",object.phoneNumbers,@"phoneNumbersAll" ,nil];
                    [self.array addObject:[NSString stringWithFormat:@"%@",[self.personDict  objectForKey:@"fullName"]]];
                    [self.arrayWithDict addObject:self.personDict];
                }
                self.sortedArray = [self.array sortedArrayUsingSelector:@selector(compare:)];
                [self sort];
                [self makeSection];
                [self sortDictionary];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                   [self.mainTableView reloadData];
//                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView removeFromSuperview];
                [self makeWarning];
                [self.mainTableView reloadData];
            });
            
        }
    }];
}

-(void)sortDictionary{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *string in self.finalArray) {
        NSString *firstLetter = [string substringToIndex:1];
        if (!dict[firstLetter]) {
            dict[firstLetter] = [[NSMutableArray alloc] init];
        }
        [((NSMutableArray *)dict[firstLetter]) addObject:string];
    }
    self.dictionary = dict;
    NSLog(@"The contactsArray are - %@",self.dictionary);
}

-(void)makeWarning {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    textLabel.text = @"Доступ к списку контактов запрещен. Войдите в Settings и разрешите доступ.";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 3;
    [textLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:textLabel];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [textLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [textLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [textLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [textLabel.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
                                              ]
     ];
}

- (void)makeSection {
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=0; i<[_finalArray count]; i++){
        NSString *alphabet = [[_finalArray objectAtIndex:i] uppercaseString];
        NSString *first = [alphabet substringToIndex:1];
        [arr addObject:first];
    }
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arr];
    _titles = orderedSet.array;
    NSLog(@"titles %@", _titles);
    
}


#pragma mark - DataSourse

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self.titles objectAtIndex:section];
    NSArray *sectionArray = [self.dictionary objectForKey:sectionTitle];
    
    if ([[_helpArray objectAtIndex:section] boolValue]){
        return 0;
        
    } else {
        return sectionArray.count;
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    
    NSString *sectionTitle = [self.titles objectAtIndex:indexPath.section];
    NSArray *sectionName = [self.dictionary objectForKey:sectionTitle];
    NSString *contact = [sectionName objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    cell.layer.borderColor = [[UIColor colorWithHexString:@"0xDFDFDF"] CGColor];
    
    UIImage *infoIcon = [UIImage imageNamed:@"info"];
    cell.info.imageView.image = infoIcon;
    cell.labelName.text = contact;
    
    UIView *highlightedView = [[UIView alloc] init];
    highlightedView.backgroundColor = [UIColor colorWithHexString:@"0XFEF6E6"];
    [cell setSelectedBackgroundView:highlightedView];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60;
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self.titles objectAtIndex:section];
    NSArray *sectionArray = [self.dictionary objectForKey:sectionTitle];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width, 60)];;
    header.backgroundColor = [UIColor colorWithHexString:@"0XF9F9F9"];
    header.layer.borderColor = [[UIColor colorWithHexString:@"0XDFDFDF"] CGColor];
    header.layer.borderWidth = 1;
    
    UILabel *letter = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 12, 60)];
    letter.text = [[NSString stringWithString:sectionTitle] uppercaseString];
    letter.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [header addSubview:letter];
    
    UILabel *contacts = [[UILabel alloc] initWithFrame:CGRectMake(25 + letter.frame.size.width + 10, 0, 100, 60)];
    contacts.text = [NSString stringWithFormat:@"контактов: %lu",(unsigned long)sectionArray.count];
    contacts.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
    [header addSubview:contacts];
    
    
    
    UIImage *up = [UIImage imageNamed:@"arrow_up"];
    UIImage *down = [UIImage imageNamed:@"arrow_down"];
    UIImageView *icon = [[UIImageView alloc]init];
    
    if ([[_helpArray objectAtIndex:section] boolValue]) {
        icon = [[UIImageView alloc] initWithImage:up];
        letter.textColor = [UIColor colorWithHexString:@"0xD99100"];
        contacts.textColor = [UIColor colorWithHexString:@"0xD99100"];
    } else {
        icon = [[UIImageView alloc] initWithImage:down];
    }
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [header addSubview:icon];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [icon.trailingAnchor constraintEqualToAnchor:header.trailingAnchor constant: -20],
                                              [icon.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
                                              [icon.heightAnchor constraintEqualToConstant:20]
                                              
                                              ]];
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    header.tag = section;
    [header addGestureRecognizer:headerTapped];
    return header;
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[_helpArray objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<_titles.count; i++) {
            if (indexPath.section==i) {
                [_helpArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"tapped");
    }
    
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 

    NSString *sectionTitle = [self.titles objectAtIndex:indexPath.section];
    NSArray *sectionName = [self.dictionary objectForKey:sectionTitle];
    NSString *contact = [sectionName objectAtIndex:indexPath.row];
    
    for (id dict in _arrayWithDict) {
        for (NSString *str in [dict objectForKey:@"phoneNumbersAll"]) {
            if ([contact isEqualToString: [dict objectForKey:@"fullName"]]) {
                _message = str;
                _image = [dict objectForKey:@"userImage"];
                _fullName = contact;
                _phoneNumbersAll = [dict objectForKey:@"phoneNumbersAll"];
            }
        }
    }

    
    NSLog(@"%@", self.arrayWithDict);
    NSLog(@"%@", _message);
    
    InfoViewVC *vc = [InfoViewVC new];
    vc.phoneNumber = _message;
    vc.infoImage = _image;
    vc.fullName = _fullName;
    vc.phones = _phoneNumbersAll;
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:contact
                                                                   message:_message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
        NSLog(@"OK");
    [self.navigationController pushViewController:vc animated:YES];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


@end



