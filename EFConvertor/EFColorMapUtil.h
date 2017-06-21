//
//  EFColorMapUtil.h
//  EFConvertor
//
//  Created by zuoming on 2017/6/21.
//  Copyright © 2017年 zuoming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFColorMapUtil : NSObject

+ (EFColorMapUtil *)sharedInstance;

+ (NSString *)standardColrStatementWith:(NSString *)hexColor;
+ (NSString *)version;
+ (void)updateConfig:(NSDictionary *)config;

@end
