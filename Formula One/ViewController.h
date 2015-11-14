//
//  ViewController.h
//  Formula One
//
//  Created by Chris Bateman on 2015-05-09.
//  Copyright (c) 2015 Chris Bateman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLConnectionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIButton *reloadButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)reloadPressed:(id)sender;
- (void)requestData;
- (void)updateView;

@end

