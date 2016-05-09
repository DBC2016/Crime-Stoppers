//
//  Homocides.h
//  CrimeStoppers
//
//  Created by Demond Childers on 5/8/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Homocides : NSObject


@property (nonatomic, strong) NSString      *homocideAddress;
@property (nonatomic, strong) NSString      *homocidePrecinct;
@property (nonatomic, strong) NSString      *homocideReportNo;
@property (nonatomic, strong) NSString      *homocideTime;
@property (nonatomic, strong) NSString      *homocideLongX;
@property (nonatomic, strong) NSString      *homocideLatY;



-(id)initWithHomocideAddress: (NSString *)homocideAddress andHomocidePrecinct: (NSString* )homocidePrecinct andHomocideReportNo: (NSString *)homocideReportNo andHomocideTime: (NSString *)homocideTime andHomocideLongX:(NSString *)homocideLongX andHomocideLatY: (NSString *)homocideLatY;






@end
