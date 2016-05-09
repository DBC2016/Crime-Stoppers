//
//  Licenses.m
//  CrimeStoppers
//
//  Created by Demond Childers on 5/8/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

#import "Licenses.h"

@implementation Licenses

-(id)initWithLicenseActive:(NSString *)licenseActive andLicenseBizName:(NSString *)licensebizName andLicenseAddress:(NSString *)licenseAddress andLicenseZip:(NSString *)licenseZip andLicensePermitType:(NSString *)licensePermitType {
    
    self = [super init];
    if (self) {
        self.licenseActive = licenseActive;
        self.licenseBizName = licensebizName;
        self.licenseAddress = licenseAddress;
        self.licenseZip = licenseZip;
        self.licensePermitType = licensePermitType;
        
    }
    
    return self;
    
}



@end







