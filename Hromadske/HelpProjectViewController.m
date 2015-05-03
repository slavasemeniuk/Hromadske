//
//  HelpProjectViewController.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "HelpProjectViewController.h"
#import "Constants.h"
#import "ControllersManager.h"
//#import "HelpProject.h"

@interface HelpProjectViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) NSString *url;

@end

@implementation HelpProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showAllert];
//    [self setUpLabel];
//    [self setUpData];
}

- (void) showAllert
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults valueForKey:@"Allert"] isEqual:@"Choosed"]) {
        UIAlertView *allert =[[UIAlertView alloc] initWithTitle:@"Хочете поставити нагадування про допомогу Громадському" message:nil delegate:self cancelButtonTitle:@"Ні" otherButtonTitles:@"Так", nil];
        [allert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Choosed" forKey:@"Allert"];
    [defaults synchronize];
    
    if (buttonIndex != [alertView cancelButtonIndex]){
        [self setUpLoacalNotification];
    }
}

- (void) setUpLoacalNotification{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit) fromDate:[NSDate date]];
    [comp setDay:1];
    [comp setHour:15];
    
    localNotification.fireDate = [gregorian dateFromComponents:comp];
    localNotification.repeatInterval = kCFCalendarUnitMonth;
    localNotification.alertBody = [NSString stringWithFormat:@"Допомогти Громадському"];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

//- (void) setUpLabel {
//    _label.lineBreakMode = NSLineBreakByWordWrapping;
//    _label.numberOfLines = 0;
//}

//-(void) setUpData {
//    [[DataManager sharedManager] helpProjectDataWithCompletion: ^(id helpData) {
//        HelpProject *helpProjectData = helpData;
//        [_label setText: helpProjectData.content];
//        _url = helpProjectData.url;
//    }];
//}

- (IBAction)goToWebSite:(id)sender {
    [self.navigationController pushViewController:[[ControllersManager sharedManager] createNavigationControllerWithIdentifier:@"webhelp"] animated:YES];
}

@end
