//
//  DataBaseEngine.h
//  SJMicroBlog
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseEngine : NSObject

+ (void)saveStatus:(NSArray *)statuses;

+ (NSArray *)getStatusFromDB;

@end
