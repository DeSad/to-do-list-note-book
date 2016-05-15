//
//  ViewController.h
//  ToDoList
//
//  Created by Stanislav Kozhemyako on 4/10/16.
//  Copyright © 2016 Stanislav Kozhemyako. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate * eventDate;
@property (strong, nonatomic) NSString *eventInfo;
@property (assign, nonatomic) BOOL isDetail;

@end

