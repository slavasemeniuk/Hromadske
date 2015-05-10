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
#import "NetworkTracker.h"

@interface HelpProjectViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) NSString *url;

@end

@implementation HelpProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showAllert];
}

- (void)showAllert
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults valueForKey:@"Allert"] isEqual:@"Choosed"]) {
        UIAlertView *allert =[[UIAlertView alloc] initWithTitle:@"Нагадування" message:@"Ми постійно потребуємо твоєї підтримки. Встановити щомісячне нагадування про допомогу?" delegate:self cancelButtonTitle:@"Пізніше" otherButtonTitles:@"Авжеж", nil];
        [allert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Choosed" forKey:@"Allert"];
        [defaults synchronize];
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
    localNotification.alertBody = [NSString stringWithFormat:@"Громадське чекає на допомогу"];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

- (IBAction)goToWebSite:(id)sender {
    if ([NetworkTracker isReachable]) {
        UIViewController *controller = [[ControllersManager sharedManager] viewControllerWithIdentefier:@"WebHelpViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"Помилка" message:@"Перевірте підключення до мережі" delegate:self cancelButtonTitle:@"Добре" otherButtonTitles: nil];
        [noConnection show];
    }
    
}

@end
