//
//  FormulaOneData.h
//  Formula One
//
//  Created by Chris Bateman on 2015-05-09.
//  Copyright (c) 2015 Chris Bateman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormulaOneData : NSObject

@property (strong, nonatomic) NSString *season;
@property (strong, nonatomic) NSString *round;
@property (strong, nonatomic) NSString *raceName;
@property (strong, nonatomic) NSMutableArray *drivers;

- (void)clear;
- (Boolean)parse:(NSData *)data;

@end
