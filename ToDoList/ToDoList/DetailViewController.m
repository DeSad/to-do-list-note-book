//
//  ViewController.m
//  ToDoList
//
//  Created by Stanislav Kozhemyako on 4/10/16.
//  Copyright © 2016 Stanislav Kozhemyako. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *bottonSave;

@end

@implementation DetailViewController

#pragma mark - viewDidLoad -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.isDetail) {
        
        self.textField.text = self.eventInfo;
        self.textField.userInteractionEnabled = NO;
        
        [self performSelector:@selector(setDatePickerValueWithAnimation) withObject:nil afterDelay:0.5];
        self.dataPicker.userInteractionEnabled = NO;
        
        self.bottonSave.alpha = 0;
        
    }else{
    
    
    self.bottonSave.userInteractionEnabled = NO;
    [self.bottonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndEditing)];
    
    [self.view addGestureRecognizer:handleTap];
   
    self.dataPicker.minimumDate = [NSDate date];
    
    [self.dataPicker addTarget:self action:@selector(datePickerValueChange) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)setDatePickerValueWithAnimation{
    [self.dataPicker setDate:self.eventDate animated:YES];
}

#pragma mark - didReciveMemoryWarning -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - datePickerValueChange -

-(void)datePickerValueChange{
    self.eventDate = self.dataPicker.date;
    
    NSLog(@"Date picker %@", self.eventDate);
}

#pragma mark - handleEndEditing -

-(void)handleEndEditing{
    
    if ([self.textField.text length] != 0) {
        [self.view endEditing:YES];
        self.bottonSave.userInteractionEnabled = YES;
        
    }else{
        [self showAlertWithMessage:@"Для сохранения события введите значение в текстовое поле."];
    }
}

#pragma mark - Save -

-(void)save{
    if (self.eventDate) {
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
            [self showAlertWithMessage:@"Дата будующего события не может совпадать с текущей датой."];
            
        }else if([self.eventDate compare:[NSDate date]] == NSOrderedAscending){
            [self showAlertWithMessage:@"Дата будующего события не может быть ранее текущей даты."];

        }else{
            [self setNotification];
        }
    }else{
        
        [self showAlertWithMessage:@"Для созранения события измените значение даты на более позднее."];
    }

}

#pragma mark - Notifications -

-(void)setNotification{
    
    NSString * eventInfo = self.textField.text;
    
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"HH: mm dd.MMMM.yyyy";
    
    NSString * eventDate = [formater stringFromDate:self.eventDate];
    
    NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 eventInfo, @"eventInfo",
                                 eventDate, @"eventDate",
                                 nil];
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.userInfo = dictionary;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [[NSNotificationCenter defaultCenter ] postNotificationName:@"NewEvent" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFieldShouldReturn -

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:self.textField]) {
        
        if ([self.textField.text length] != 0) {
            
            [self.textField resignFirstResponder];
            self.bottonSave.userInteractionEnabled = YES;
            
            return YES;
        }else{
            [self showAlertWithMessage:@"Для сохранения события введите значение в текстовое поле."];
        }

    }
    return NO;
}

#pragma mark - showAlertMessage -

-(void)showAlertWithMessage : (NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Внимание"
                          message:message
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil,
                          nil];
    [alert show];
}

@end
