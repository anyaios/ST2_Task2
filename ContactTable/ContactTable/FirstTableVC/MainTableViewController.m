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



@interface MainTableViewController () <UITableViewDelegate, UITableViewDataSource, CNContactViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
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
  //  _sortedArray = [NSMutableArray array];
  //  _titles = [NSMutableArray array];
  
    [self fetchContactsandAuthorization];
    
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
    [_mainTableView registerNib:nib forCellReuseIdentifier:@"CustomCell"];
    [self.mainTableView reloadData];
}

- (void)addNavigation {
    self.title = @"Контакты";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"0XE6E6E6"];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"0XFFFFFF"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0X000000"],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]}];
}

- (void)fetchContactsandAuthorization
{
    // Request authorization to Contacts
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES)
        {
            //keys with fetching properties
            self.keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:self.keys error:&error];
            
            if (error)
            {
                NSLog(@"error fetching contacts %@", error);
            }
            else
            {
                NSString *fullName;
                ContactObject *object = [ContactObject new];
                NSMutableArray *contactNumbersArray = [[NSMutableArray alloc]init];
                for (CNContact *contact in cnContacts) {
                    
                    // copy data to my custom Contacts class.
                    object.name = contact.givenName;
                    object.lastname = contact.familyName;
                    if (object.lastname == nil) {
                        fullName=[NSString stringWithFormat:@"%@",[object.name substringFromIndex:object.lastname.length]];
                        NSLog(@".%lu.", (unsigned long)[object.name length]);
                    }else if (object.name == nil){
                        fullName=[NSString stringWithFormat:@"%@",object.lastname];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",object.lastname,object.name];
                    }
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        object.image = image;
                    }else{
                        object.image = [UIImage imageNamed:@"person-icon.png"];
                    }
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        object.phone = [label.value stringValue];
                        if ([object.phone length] > 0) {
                            [contactNumbersArray addObject:object.phone];
                        }
                    }
                    NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",object.image,@"userImage",object.phone,@"PhoneNumbers", nil];
                    [self.array addObject:[NSString stringWithFormat:@"%@",[personDict objectForKey:@"fullName"]]];
                   // NSLog(@"The contactsArray are - %@",self.array);
                    
                }
                self.sortedArray = [self.array sortedArrayUsingSelector:@selector(compare:)];
                [self makeSection];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                for (NSString *string in self.sortedArray) {
                    NSString *firstLetter = [string substringToIndex:1];
                    if (!dict[firstLetter]) {
                        dict[firstLetter] = [[NSMutableArray alloc] init];
                    }
                    [((NSMutableArray *)dict[firstLetter]) addObject:string];
                }
                self.dictionary = dict;
                NSLog(@"The contactsArray are - %@",self.dictionary);
   
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView reloadData];
                });
            }
        } else {
            //self.mainTableView.backgroundView = nil;
            [self.mainTableView removeFromSuperview];
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
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
            });
            
        }
    }];
}
- (void) makeSection {
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=0; i<[_sortedArray count]; i++){
        NSString *alphabet = [[_sortedArray objectAtIndex:i] uppercaseString];
        NSString *first = [alphabet substringToIndex:1];
        [arr addObject:first];
    }
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arr];
   // _titles = orderedSet.array;
    _titles = [orderedSet.array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@",orderedSet.array.firstObject]];
    NSLog(@"titles %@", _titles);
    
}

#pragma mark - DataSourse

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = [self.titles objectAtIndex:section];
    NSArray *sectionArray = [self.dictionary objectForKey:sectionTitle];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    NSString *sectionTitle = [self.titles objectAtIndex:indexPath.section];
    NSArray *sectionName = [self.dictionary objectForKey:sectionTitle];
    NSString *contact = [sectionName objectAtIndex:indexPath.row];
    cell.labelName.text = contact;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titles count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.titles objectAtIndex:section];
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ContactObject *object = _array[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Message"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end


