//
//  LPFirUpgradeServices.m
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 6/18/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPFirUpgradeServices.h"
#import "LPAlertView.h"

static NSString *const kFirVersionCheckUrl = @"http://fir.im/api/v2/app/version/";
static NSString *const kFirInstallUrl = @"itms-services://?action=download-manifest&url=";

@implementation LPFirUpgradeServices


+ (instancetype)sharedInstance {
    static LPFirUpgradeServices *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (void)checkVersionUpgrade:(NSString *)appKey {
    NSURL *checkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kFirVersionCheckUrl, appKey]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:checkUrl] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            return;
        }
        
        @try {
            NSDictionary *result= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
            NSString *build = result[@"version"];
            NSString *version = result[@"versionShort"];

            NSString *changelog = result[@"changelog"];
            NSString *installUrl = result[@"installUrl"];
            
            if (![self hasNewVersion:version withBuild:build]) {
                return;
            }
            
            [LPAlertView alertWithTitle:@"版本升级" withMessage:changelog cancelButtonTitle:@"取消" otherButtonTitle:@"升级" withCompletionBlock:^(DQAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == kLPAlertViewOtherButtonIndex) {
                    NSString *itemInstallUrl = [NSString stringWithFormat:@"%@%@", kFirInstallUrl, installUrl];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itemInstallUrl]];
                }
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Check version upgrade exception: %@", exception);
        }
    }];
}

- (BOOL)hasNewVersion:(NSString *)version withBuild:(NSString *)build {
    NSString *localBuild = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString *localVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];

    if ([version compare:localVersion options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }
    
    if ([version compare:localVersion options:NSNumericSearch] == NSOrderedDescending) {
        return YES;
    }
    
    if ([build compare:localBuild options:NSNumericSearch] == NSOrderedAscending
        || [build compare:localBuild options:NSNumericSearch] == NSOrderedSame) {
        return NO;
    }
    
    return YES;
}

@end
