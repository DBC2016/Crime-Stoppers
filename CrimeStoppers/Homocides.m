//
//  Homocides.m
//  CrimeStoppers
//
//  Created by Demond Childers on 5/8/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

#import "Homocides.h"

@implementation Homocides


-(id)initWithHomocideAddress:(NSString *)homocideAddress andHomocidePrecinct:(NSString *)homocidePrecinct andHomocideReportNo:(NSString *)homocideReportNo andHomocideTime:(NSString *)homocideTime andHomocideLongX:(NSString *)homocideLongX andHomocideLatY:(NSString *)homocideLatY {
    
    self = [super init];
    if (self) {
        self.homocideAddress = homocideAddress;
        self.homocidePrecinct = homocidePrecinct;
        self.homocideReportNo = homocideReportNo;
        self.homocideTime   = homocideTime;
        self.homocideLongX = homocideLongX;
        self.homocideLatY = homocideLatY;
    }
    return self;

}

@end
