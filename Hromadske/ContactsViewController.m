//
//  ContactsViewController.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "ContactsViewController.h"
#import "Contacts.h"

@interface ContactsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *adress;
@property (strong, nonatomic) IBOutlet UILabel *webPage;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UILabel *phone;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[DataManager sharedManager] contactsDataWithCompletion:^(Contacts *contacts) {
//        _adress.text = [_adress.text stringByAppendingString:contacts.place];
//        _webPage.text = [_webPage.text stringByAppendingString:contacts.url];
//        _email.text = [_email.text stringByAppendingString:contacts.emails];
//        _phone.text = [_phone.text stringByAppendingString:contacts.phones];
//    }];
}



@end
