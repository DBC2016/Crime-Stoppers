//
//  Precincts.m
//  CrimeStoppers
//
//  Created by Demond Childers on 5/6/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

#import "Precincts.h"

@implementation Precincts


-(id)initWithID:(NSString *)precinctId andPrecinctPhone:(NSString *)precinctPhone andPrecinctZip:(NSString *)precintZip andPrecinctAddress:(NSString *)precinctAddresss andPrecinctCaptain:(NSString *)precinctCaptain {
    self = [super init];
    if (self) {
        self.precinctId = precinctId;
        self.precinctPhone = precinctPhone;
        self.precinctZip = precintZip;
        self.precinctAddress = precinctAddresss;
        self.precinctCaptain = precinctCaptain;
    }
    return  self;
}



@end
