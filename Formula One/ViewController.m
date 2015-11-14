//
//  ViewController.m
//  Formula One
//
//  Created by Chris Bateman on 2015-05-09.
//  Copyright (c) 2015 Chris Bateman. All rights reserved.
//

#import "DriverData.h"
#import "FormulaOneData.h"
#import "CollectionViewCell.h"
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableData *apiReturnData;
@property (strong, nonatomic) NSURLConnection *currentConnection;
@property (strong, nonatomic) FormulaOneData *formulaOneData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"viewDidLoad");
    
    self.apiReturnData = [NSMutableData data];
    self.formulaOneData = [[FormulaOneData alloc] init];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reloadPressed:(id)sender {
    NSLog(@"reloadPressed");
    
    [self requestData];
}

// Make a request for json data from url.
- (void)requestData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *restURL = [NSURL URLWithString:@"http://ergast.com/api/f1/current/last/results.json"];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:45.0];
    
    if (self.currentConnection) {
        [self.currentConnection cancel];
        self.currentConnection = nil;
        [self.apiReturnData setLength:0];
    }
    
    if (!self.currentConnection) {
        self.currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    }
}

- (void)updateView {
    [self.titleLabel setText:[NSString stringWithFormat:@"%@", self.formulaOneData.raceName]];
    [self.descriptionLabel setText:
        [NSString stringWithFormat:@"round (%@) season (%@)", self.formulaOneData.round, self.formulaOneData.season]];
    [self.collectionView reloadData];
}

#pragma mark - NSURLConnectionDelegate ----------------------------------------------------------

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    
    [self.apiReturnData setLength:0];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    NSLog(@"didReceiveData");
    
    [self.apiReturnData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"didFailWithError");
    self.currentConnection = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                   message:@"Network error occured"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([self.formulaOneData parse:self.apiReturnData]) {
        [self updateView];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                       message:@"Could not parse data"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"OK", nil];
        [alert show];
    }
    self.currentConnection = nil;
}

#pragma mark - UICollectionViewDataSource ----------------------------------------------------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.formulaOneData.drivers count] + 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSUInteger section = [indexPath indexAtPosition:0];
    NSUInteger row = [indexPath indexAtPosition:1];
    
    if (section == 0) {
        switch (row) {
            case 0:
                [cell.contentLabel setText:@"Rank"];
                break;
            case 1:
                [cell.contentLabel setText:@"Points"];
                break;
            case 2:
                [cell.contentLabel setText:@"Driver"];
                break;
            case 3:
                [cell.contentLabel setText:@"Vehicle"];
                break;
            default:
                break;
        }
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.contentLabel.backgroundColor = [UIColor lightGrayColor];
        cell.contentLabel.textColor = [UIColor whiteColor];
        cell.contentLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0]];
    }
    else {
        if ((section - 1) < [self.formulaOneData.drivers count]) {
            DriverData *data = self.formulaOneData.drivers[section - 1];
            switch (row) {
                case 0:
                    [cell.contentLabel setText:data.rank];
                    cell.contentLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                case 1:
                    [cell.contentLabel setText:data.points];
                    cell.contentLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                case 2:
                    [cell.contentLabel setText:data.driver];
                    cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                    break;
                case 3:
                    [cell.contentLabel setText:data.vehicle];
                    cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                    break;
                default:
                    break;
            }
        }
        
        if (section % 2 != 0) {
            cell.backgroundColor = [UIColor colorWithWhite:242/255.0 alpha:1.0];
            cell.contentLabel.backgroundColor = [UIColor colorWithWhite:242/255.0 alpha:1.0];
            cell.contentLabel.textColor = [UIColor blackColor];
            [cell.contentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0]];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentLabel.backgroundColor = [UIColor whiteColor];
            cell.contentLabel.textColor = [UIColor blackColor];
            [cell.contentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0]];
        }
    }
    
    return cell;
}

@end
