//
//  Licenses.h
//  CrimeStoppers
//
//  Created by Demond Childers on 5/8/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Licenses : NSObject



@property (nonatomic, strong) NSString *licenseActive;
@property (nonatomic, strong) NSString *licenseBizName;
@property (nonatomic, strong) NSString *licenseAddress;
@property (nonatomic, strong) NSString *licenseZip;
@property (nonatomic, strong) NSString *licensePermitType;
@property (nonatomic, strong) NSString *licenseLat;
@property (nonatomic, strong) NSString *licenseLon;


- (id) initWithLicenseActive: (NSString *)licenseActive andLicenseBizName:(NSString *)licensebizName andLicenseAddress:(NSString *)licenseAddress andLicenseZip:(NSString *)licenseZip andLicensePermitType:(NSString *)licensePermitType;


@end


