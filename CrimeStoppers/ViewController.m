//
//  ViewController.m
//  CrimeStoppers
//
//  Created by Demond Childers on 5/5/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//


//#import "AppDelegate.h."
#import "ViewController.h"
#import "Reachability.h"
#import "Precincts.h"
#import "Licenses.h"
#import "Homocides.h"



@interface ViewController ()



@property (nonatomic, strong) NSString                          *hostname;
@property (nonatomic, strong) NSMutableArray                    *precinctsearchArray;
@property (nonatomic, weak)   IBOutlet          MKMapView       *crimeMapView;
@property (nonatomic, strong) NSMutableArray                    *licensesearchArray;
@property (nonatomic, strong) NSMutableArray                    *homocidesearchArray;


//@property (nonatomic, strong) AppDelegate    *appDelegate;

@end

@implementation ViewController



Reachability *hostReach;
Reachability *hostReach;
Reachability *internetReach;
Reachability *wifiReach;
bool internetAvailable;
bool serverAvailable;





#pragma mark - MapView Methods

// ZOOM in on Map 

-(void)zoomToPins {
    [_crimeMapView showAnnotations:[_crimeMapView annotations] animated:true];
}

-(void)annotateMapLocations {
    NSMutableArray *pinsToRemove = [[NSMutableArray alloc] init];
    for (id <MKAnnotation> annot in [_crimeMapView annotations]) {
        if ([annot isKindOfClass:[MKPointAnnotation class]]) {
            [pinsToRemove addObject:annot];
        }
        
    }
    
    // REMOVES PINS
    [_crimeMapView removeAnnotations:pinsToRemove];
    
    
    for (Precincts *currPrecinct in _precinctsearchArray) {
        MKPointAnnotation *pa1 = [[MKPointAnnotation alloc] init];
        pa1.coordinate = CLLocationCoordinate2DMake([currPrecinct.precinctLat floatValue], [currPrecinct.precinctLon floatValue]);
        pa1.title = currPrecinct.precinctName;
        pa1.subtitle = currPrecinct.precinctAddress;
        [_crimeMapView addAnnotation:pa1];
    }
    
    for (Licenses *currLicense in _licensesearchArray) {
        MKPointAnnotation *pa2 = [[MKPointAnnotation alloc] init];
        pa2.coordinate = CLLocationCoordinate2DMake([currLicense.licenseLat floatValue], [currLicense.licenseLon floatValue]);
        pa2.title = currLicense.licenseBizName;
        pa2.subtitle = currLicense.licenseAddress;
        [_crimeMapView addAnnotation:pa2];
    }
    for (Homocides *currHomocide in _homocidesearchArray) {
        MKPointAnnotation *pa3 = [[MKPointAnnotation alloc] init];
        pa3.coordinate = CLLocationCoordinate2DMake([currHomocide.homocideLatY floatValue], [currHomocide.homocideLongX floatValue]);
        [_crimeMapView addAnnotation:pa3];
    }
    

    
    [self zoomToPins];
    
    
}



-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"VFA");
    if (annotation != mapView.userLocation) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        }
        pinView.canShowCallout = true;
//        pinView.animatesDrop = false;
        pinView.pinTintColor = [UIColor purpleColor];
        UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.tag = 2;
        pinView.rightCalloutAccessoryView = pinButton;
        return pinView;
    }
    return nil;
    
}




//Create and Render Circle Around Map Pin



-(IBAction)mapLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long Press");
        CGPoint point = [gestureRecognizer locationInView:_crimeMapView];
        CLLocationCoordinate2D pointCoord = [_crimeMapView convertPoint:point toCoordinateFromView:_crimeMapView];
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = pointCoord;
        
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:pointCoord radius:3000];
        [_crimeMapView addOverlay:circle level:MKOverlayLevelAboveRoads];
    }
    
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        [renderer setFillColor:[UIColor greenColor]];
        [renderer setAlpha:2.0f];
        

        
        
        return renderer;
    }
    return nil;
}










#pragma mark- Interativity Methods


- (IBAction)getPoliceStationsFromServer {
    NSLog(@"grab from host");
    

        
        if (serverAvailable) {
            NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://data.detroitmi.gov/resource/3n6r-g9kp.json"]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:fileURL];
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            [request setTimeoutInterval:30.0];
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"Got Response");
                
                if (([data length] > 0) && (error == nil)) {
                    
                    //TEST TO RETURN HEX DATA
                    NSLog(@"Got Data: %@", data);
                    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Got String: %@",dataString);
                    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSLog(@"Json: %@",json);
                    
                    NSArray *precinctTempArray = (NSArray *) json;
                    _precinctsearchArray = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *precinctDict in precinctTempArray) {
                        
                        
                        NSDictionary *coorDict = [precinctDict objectForKey:@"location"];
                        NSArray *coordinates = [coorDict objectForKey:@"coordinates"];
                        
                        Precincts *currentPrecinct= [[Precincts alloc] initWithID:[precinctDict objectForKey:@"id"] andPrecinctPhone:[precinctDict objectForKey:@"phone_number"] andPrecinctZip:[precinctDict objectForKey:@"zip_code"] andPrecinctAddress:[precinctDict objectForKey:@"address_1"] andPrecinctCaptain:[precinctDict objectForKey:@"captain"]];
                        currentPrecinct.precinctLat = coordinates[1];
                        currentPrecinct.precinctLon = coordinates[0];
                        currentPrecinct.precinctName = [precinctDict objectForKey:@"precinct"];
                        [_precinctsearchArray addObject:currentPrecinct];
                        NSLog(@"Precinct: %@",currentPrecinct.precinctName);

                    }
                    NSLog(@"Precinct Count:%li",_precinctsearchArray.count);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Refresh Data on Interface
                        [self annotateMapLocations];
                    });
                }
                
            }] resume];
        }
}



-(IBAction)getLiquorLicensesFromServer {
    NSLog(@"grab from host");
    
    if (serverAvailable) {
        NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://data.detroitmi.gov/resource/djd8-sm8q.json"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:fileURL];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [request setTimeoutInterval:30.0];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"Got Response");
            
              if (([data length] > 0) && (error == nil)) {
//                  TEST TO RETURN HEX DATA
                  NSLog(@"Got Data: %@", data);
                  NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  NSLog(@"Got String: %@",dataString);
                  NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                  NSLog(@"Json: %@",json);
                  
                  NSArray *licenseTempArray = (NSArray *) json;
//                [_licensesearchArray removeAllObjects];
                  _licensesearchArray = [[NSMutableArray alloc] init];
                  
                  for (NSDictionary *licenseDict in licenseTempArray) {
                  
                      
                      NSDictionary *coorDict = [licenseDict objectForKey:@"full_address_value"];
                      NSArray *coordinates = [coorDict objectForKey:@"coordinates"];
                      
                      Licenses *currentLicense= [[Licenses alloc] initWithLicenseActive:[licenseDict objectForKey:@"active"] andLicenseBizName:[licenseDict objectForKey:@"name"] andLicenseAddress:[licenseDict objectForKey:@"full_address_value_address"] andLicenseZip:[licenseDict objectForKey:@"full_address_value_zip"] andLicensePermitType:[licenseDict objectForKey:@"permit_type"]];
                      
                      
                      currentLicense.licenseLat = coordinates[1];
                      currentLicense.licenseLon = coordinates[0];
                      currentLicense.licenseBizName = [licenseDict objectForKey:@"name"];
                      [_licensesearchArray addObject:currentLicense];
                      NSLog(@"License: %@",currentLicense.licenseBizName);
                    
                  }
                  
                  NSLog(@"Liquor License Count:%li",_licensesearchArray.count);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      // Refresh Data on Interface
                      [self annotateMapLocations];
                  });
              }
            
        }] resume];
    }
}

          
-(IBAction)getHomocidesFromServer {
    NSLog(@"grab from host");
    
    if (serverAvailable) {
        NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://data.detroitmi.gov/resource/sr29-szd3.json"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:fileURL];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [request setTimeoutInterval:30.0];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"Got Response");
            
            if (([data length] > 0) && (error == nil)) {
    
    
//                  TEST TO RETURN HEX DATA
                NSLog(@"Got Data: %@", data);
                NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Got String: %@",dataString);
                NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"Json: %@",json);
                
                NSArray *homocidesTempArray = (NSArray *) json;
                 _homocidesearchArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *homocidesDict in homocidesTempArray){
                    
                    
                NSDictionary *coorDict = [homocidesDict objectForKey:@"x, y"];
                NSArray *coordinates = [coorDict objectForKey:@"coordinates"];
                    
                    Homocides *newHomocide= [[Homocides alloc] initWithHomocideAddress:[homocidesDict objectForKey:@"address"] andHomocidePrecinct:[homocidesDict objectForKey:@"precinct"] andHomocideReportNo:[homocidesDict objectForKey:@"report_no"] andHomocideTime:[homocidesDict objectForKey:@"time"] andHomocideLongX:[homocidesDict objectForKey:@"x"] andHomocideLatY:[homocidesDict objectForKey:@"y"]];
                    
                    newHomocide.homocideLatY = coordinates [1];
                    newHomocide.homocideLongX = coordinates [0];
                    
                    [_homocidesearchArray addObject:newHomocide];
                    NSLog(@"Homocide: %@",newHomocide.homocideReportNo);
                    
                }

                NSLog(@"Homocides Count:%li",_homocidesearchArray.count);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Refresh Data on Interface
                    [self annotateMapLocations];
                });
                
            }
        }] resume];
        
    }
    
}


#pragma mark- Network Methods


- (void)updateReachabilitStatus:(Reachability *)currentReach {
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [currentReach currentReachabilityStatus];
    
    //HOST REACH
    
    if (currentReach == hostReach) {
        switch (netStatus) {
            case NotReachable:
                NSLog(@"Server Not Avaiable");
                serverAvailable = false;
                break;
            case ReachableViaWWAN:
                NSLog(@"Server Reachable via WWAN");
            case ReachableViaWiFi:
                NSLog(@"Server Reachable via WiFi");
                serverAvailable = true;
            default:
                break;
        }
    }
    //INTERNET REACH
    
    if (currentReach == internetReach || currentReach == wifiReach) {
        
        switch (netStatus) {
            case NotReachable:
                NSLog(@"Internet Not Available");
                internetAvailable = false;
                break;
            case ReachableViaWWAN:
                NSLog(@"Internet Available via WWAN");
                internetAvailable = true;
            case ReachableViaWiFi:
                NSLog(@"Internet Available via WifFi");
                internetAvailable = true;
            default:
                break;
        }
    }
}

-(void)reachabilityChanged:(NSNotification *)notification {
    Reachability *currentReach = [notification object];
    [self updateReachabilitStatus:currentReach];
}


                

#pragma mark- Life Cycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
        _hostname = @"data.detroitmi.gov";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    



    
        hostReach = [Reachability reachabilityWithHostname:_hostname];
        [hostReach startNotifier];
    
        internetReach = [Reachability reachabilityForInternetConnection];
        [internetReach startNotifier];
    
        wifiReach = [Reachability reachabilityForLocalWiFi];
        [wifiReach startNotifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

                
@end



