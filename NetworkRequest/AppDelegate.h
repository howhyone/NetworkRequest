//
//  AppDelegate.h
//  NetworkRequest
//
//  Created by mob on 2019/1/29.
//  Copyright © 2019年 mob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

