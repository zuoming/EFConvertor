//
//  EFColorMapUtil.m
//  EFConvertor
//
//  Created by zuoming on 2017/6/21.
//  Copyright © 2017年 zuoming. All rights reserved.
//

#import "EFColorMapUtil.h"

#define kUserDefaultsKeyConfig @"ef_config_color_map"

@interface EFColorMapUtil ()

@property (nonatomic, readonly) NSDictionary *colorMap; /**<  */
@property (nonatomic, readonly) NSString *version; /**<  */
@property (nonatomic, strong) NSDictionary *config; /**<  */

@end

@implementation EFColorMapUtil

+ (EFColorMapUtil *)sharedInstance
{
    static EFColorMapUtil *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    
    return __sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self readConfig];
    }
    return self;
}

- (NSUserDefaults *)userDefaults
{
    return [[NSUserDefaults alloc] initWithSuiteName:@"ef_mac_source_editor_ttjj"];
}

- (void)readConfig
{
    NSUserDefaults *userDefaults = [self userDefaults];
    
    self.config = [userDefaults objectForKey:kUserDefaultsKeyConfig];
    if (self.config) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ef_color_map.plist" ofType:nil];
    self.config = [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (NSString *)version
{
    return [self.config valueForKey:@"version"];
}

- (NSDictionary *)colorMap
{
    return [self.config valueForKey:@"maps"];
}

- (NSString *)standardColrStatementWith:(NSString *)hexColor
{
    if (hexColor.length == 0) {
        return nil;
    }
    if (self.colorMap.count == 0) {
        return nil;
    }
    NSString *standardCode = [self.colorMap objectForKey:[hexColor lowercaseString]];
    if (standardCode.length == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"[UIColor ef_color%@]", standardCode];
}

- (void)updateConfig:(NSDictionary *)config
{
    self.config = config;
    NSUserDefaults *userDefaults = [self userDefaults];
    [userDefaults setObject:config forKey:kUserDefaultsKeyConfig];
}

+ (NSString *)version
{
    return [[self sharedInstance] version];
}

+ (NSString *)standardColrStatementWith:(NSString *)hexColor
{
    return [[self sharedInstance] standardColrStatementWith:hexColor];
}

+ (void)updateConfig:(NSDictionary *)config
{
    [[self sharedInstance] updateConfig:config];
}

@end
