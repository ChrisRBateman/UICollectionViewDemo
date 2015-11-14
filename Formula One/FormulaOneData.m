//
//  FormulaOneData.m
//  Formula One
//
//  Created by Chris Bateman on 2015-05-09.
//  Copyright (c) 2015 Chris Bateman. All rights reserved.
//

#import "DriverData.h"
#import "FormulaOneData.h"

@implementation FormulaOneData

- (id)init {
    self = [super init];
    if (self) {
        self.drivers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)clear {
    self.season = @"";
    self.round = @"";
    self.raceName = @"";
    [self.drivers removeAllObjects];
}

- (Boolean)parse:(NSData *)data {
    [self clear];
    
    NSError *error = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        return NO;
    }
    
    NSDictionary *mRDataDict = parsedObject[@"MRData"];
    NSDictionary *raceTableDict = mRDataDict[@"RaceTable"];
    NSArray *racesArray = raceTableDict[@"Races"];
    NSDictionary *arrayElementDict = racesArray[0];
    
    self.season = arrayElementDict[@"season"];
    self.round = arrayElementDict[@"round"];
    self.raceName = arrayElementDict[@"raceName"];
    
    NSArray *resultsArray = arrayElementDict[@"Results"];
    
    for (NSDictionary *dict in resultsArray) {
        DriverData *driverData = [[DriverData alloc] init];
        driverData.points = dict[@"points"];
        
        NSDictionary *driverDict = dict[@"Driver"];
        driverData.driver = driverDict[@"familyName"];
        
        NSDictionary *constructorDict = dict[@"Constructor"];
        driverData.vehicle = constructorDict[@"name"];
        
        NSDictionary *fastestLapDict = dict[@"FastestLap"];
        driverData.rank = (fastestLapDict != nil) ? fastestLapDict[@"rank"] : @"";
        
        [self.drivers addObject:driverData];
    }
    
    return YES;
}

@end
