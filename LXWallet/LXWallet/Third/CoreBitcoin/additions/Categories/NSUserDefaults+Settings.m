//
//  NSUserDefaults+Settings.m
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 tdchainwallet. All rights reserved.
//

#import "NSUserDefaults+Settings.h"

NSString *const kSettingIsMainnet = @"kSettingExtraMessages";
NSString *const kSettingIsRPCOn = @"kSettingLongMessage";
NSString *const kFingerpringAllowed = @"kFingerpringAllowed";
NSString *const kFingerpringEnabled = @"kFingerpringEnabled";
NSString *const kLanguageSaveKey = @"kLanguageSaveKey";
NSString *const kDeviceTokenKey = @"kDeviceTokenKey";
NSString *const kPrevDeviceTokenKey = @"kPrevDeviceTokenKey";
NSString *const kWalletAddressKey = @"kWalletAddressKey";
NSString *const kIsHaveWallet = @"kIsHaveWallet";
NSString *const kIsDarkScheme = @"kIsDarkScheme";
NSString *const kIsNotFirstTimeLaunch = @"kIsNotFirstTimeLaunch";
NSString *const kCurrentVersion = @"kCurrentVersion";
NSString *const kPublicAddresses = @"kPublicAddresses";
NSString *const kFailedPinCount = @"kFailedPinCount";
NSString *const kLastFailedDate = @"kLastFailedDate";
NSString *const kRemovingContractPassed = @"kRemovingContractPassed";



NSString *const kGroupIdentifire = @"group.com.td.td-wallet";



@implementation NSUserDefaults (Settings)

+ (void)saveIsMainnetSetting:(BOOL) value {
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingIsMainnet];
}

+ (void)saveIsRPCOnSetting:(BOOL) value {
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingIsRPCOn];
}

+ (void)saveIsFingerpringAllowed:(BOOL) value {
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:kFingerpringAllowed];
}

+ (void)saveIsFingerpringEnabled:(BOOL) value {
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:kFingerpringEnabled];
}

+ (void)saveLanguage:(NSString *) lang {
	[[NSUserDefaults standardUserDefaults] setObject:lang forKey:kLanguageSaveKey];
}

+ (NSString *)getLanguage {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageSaveKey];
}

+ (BOOL)isRPCOnSetting {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingIsRPCOn];
}

+ (BOOL)isFingerprintAllowed {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kFingerpringAllowed];
}

+ (BOOL)isFingerprintEnabled {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kFingerpringEnabled];
}

+ (BOOL)isMainnetSetting {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingIsMainnet];
}

+ (void)saveDeviceToken:(NSString *) lang {
	[[NSUserDefaults standardUserDefaults] setObject:lang forKey:kDeviceTokenKey];
}

+ (NSString *)getDeviceToken {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey];
}

+ (void)savePrevDeviceToken:(NSString *) lang {
	[[NSUserDefaults standardUserDefaults] setObject:lang forKey:kPrevDeviceTokenKey];
}

+ (NSString *)getPrevDeviceToken {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kPrevDeviceTokenKey];
}

+ (void)saveWalletAddressKey:(NSString *) key {
	[[self groupDefaults] setObject:key forKey:kWalletAddressKey];
}

+ (NSString *)getWalletAddressKey {
	return [[self groupDefaults] objectForKey:kWalletAddressKey];
}

+ (void)saveIsHaveWalletKey:(NSString *) key {
	[[self groupDefaults] setObject:key forKey:kIsHaveWallet];

}

+ (NSString *)isHaveWalletKey {
	return [[self groupDefaults] objectForKey:kIsHaveWallet];
}

+ (NSUserDefaults *)groupDefaults {
	return [[NSUserDefaults alloc] initWithSuiteName:kGroupIdentifire];
}

+ (void)saveIsDarkSchemeSetting:(BOOL) value {
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:kIsDarkScheme];
}

+ (BOOL)isDarkSchemeSetting {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kIsDarkScheme];
}

+ (void)saveIsNotFirstTimeLaunch:(BOOL) value {

	[[NSUserDefaults standardUserDefaults] setBool:value forKey:kIsNotFirstTimeLaunch];
}

+ (BOOL)isNotFirstTimeLaunch {

	return [[NSUserDefaults standardUserDefaults] boolForKey:kIsNotFirstTimeLaunch];
}

+ (void)saveCurrentVersion:(NSString *) value {

	[[NSUserDefaults standardUserDefaults] setObject:value forKey:kCurrentVersion];
}

+ (void)saveFailedPinCount:(NSInteger) count {

	[[NSUserDefaults standardUserDefaults] setObject:@(count) forKey:kFailedPinCount];
}

+ (NSInteger)getCountOfPinFailed {

	NSNumber *failedCount = [[NSUserDefaults standardUserDefaults] objectForKey:kFailedPinCount];

	if (failedCount) {
		return failedCount.integerValue;
	} else {
		return 0;
	}
}

+ (void)saveLastFailedPinDate:(NSDate *) date {
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:kLastFailedDate];
}

+ (NSDate *)getLastFailedPinDate {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kLastFailedDate];
}

+ (NSString *)currentVersion {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentVersion];
}

+ (void)saveIsRemovingContractTrainingPassed:(BOOL) value {

	[[NSUserDefaults standardUserDefaults] setBool:value forKey:kRemovingContractPassed];
}

+ (BOOL)isRemovingContractTrainingPassed {

	return [[NSUserDefaults standardUserDefaults] boolForKey:kRemovingContractPassed];
}

// Public addresses

+ (void)savePublicAddresses:(NSArray *) addresses {
    
	[[NSUserDefaults standardUserDefaults] setObject:addresses forKey:kPublicAddresses];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getPublicAddresses {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kPublicAddresses];
}

@end
