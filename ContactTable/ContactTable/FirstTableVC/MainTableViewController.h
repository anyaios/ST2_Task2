//
//  MainTableViewController.h
//  ContactTable
//
//  Created by Anna Ershova on 6/8/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>



@interface MainTableViewController : UIViewController
@property NSArray *keys;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *sortedArray;
@property (nonatomic, strong) NSMutableArray *helpArray;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSDictionary *personDict;
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;

@property (nonatomic, strong) NSArray *finalArray;


@property (nonatomic,strong) NSString *message;
@property (nonatomic, strong) NSMutableArray *arrayWithDict;


@end


