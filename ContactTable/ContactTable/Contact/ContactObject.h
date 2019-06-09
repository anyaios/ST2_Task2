//
//  ContactObject.h
//  ContactTable
//
//  Created by Anna Ershova on 6/8/19.
//  Copyright © 2019 Anna Ershova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>


@interface ContactObject : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) UIImage *image;
@end


