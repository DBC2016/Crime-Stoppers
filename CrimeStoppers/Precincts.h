//
//  Precincts.h
//  CrimeStoppers
//
//  Created by Demond Childers on 5/6/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Precincts : NSObject



@property (nonatomic, strong) NSString *precinctId;
@property (nonatomic, strong) NSString *precinctPhone;
@property (nonatomic, strong) NSString *precinctZip;
@property (nonatomic, strong) NSString *precinctAddress;
@property (nonatomic, strong) NSString *precinctCaptain;
@property (nonatomic, strong) NSString *precinctLat;
@property (nonatomic, strong) NSString *precinctLon;
@property (nonatomic, strong) NSString *precinctName;


- (id) initWithID:(NSString *)precinctId andPrecinctPhone:(NSString *)precinctPhone andPrecinctZip:(NSString *)precintZip andPrecinctAddress:(NSString *) precinctAddress andPrecinctCaptain:(NSString *)precinctCaptain;



@end
