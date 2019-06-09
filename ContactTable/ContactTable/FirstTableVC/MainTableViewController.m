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


@interface MainTableViewController () <UITableViewDelegate, UITableViewDataSource, CNContactViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *array;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Контакты";
    _array = [NSMutableArray array];
//    for (int i =0 ; i < 10; ++i) {
//        ContactObject *object = [ContactObject new];
//        object.name = [NSString stringWithFormat:@"Name %i",i];
//        object.lastname = [NSString stringWithFormat:@"Last Name"];
//        [_array addObject:object];
//    }
    
    [self fetchContactsandAuthorization];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
    [_mainTableView registerNib:nib forCellReuseIdentifier:@"CustomCell"];

    //CNContactStore *store = [[CNContactStore alloc] init];
    //    CNMutableContact *contact = [[CNMutableContact alloc] init];
  
    
}

- (void)fetchContactsandAuthorization
{
    // Request authorization to Contacts
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES)
        {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
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
                        fullName=[NSString stringWithFormat:@"%@",object.name];
                    }else if (object.name == nil){
                        fullName=[NSString stringWithFormat:@"%@",object.lastname];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",object.name,object.lastname];
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
                    [self->_array addObject:[NSString stringWithFormat:@"%@",[personDict objectForKey:@"fullName"]]];
                    NSLog(@"The contactsArray are - %@",self->_array);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_mainTableView reloadData];
                });
            }
        }
    }];
}

#pragma mark - DataSourse

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
  //  ContactObject *object = _array[indexPath.row];
    cell.labelName.text = _array[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
