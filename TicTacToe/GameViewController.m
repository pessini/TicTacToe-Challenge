//
//  GameViewController.m
//  TicTacToe
//
//  Created by Leandro Pessini on 3/12/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
@property (weak, nonatomic) IBOutlet UILabel *labelEight;
@property (weak, nonatomic) IBOutlet UILabel *labelNine;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;


@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // add borders for UILabels
    self.labelOne.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelOne.layer.borderWidth = 3.0;
    self.labelTwo.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelTwo.layer.borderWidth = 3.0;
    self.labelThree.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelThree.layer.borderWidth = 3.0;
    self.labelFour.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelFour.layer.borderWidth = 3.0;
    self.labelFive.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelFive.layer.borderWidth = 3.0;
    self.labelSix.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelSix.layer.borderWidth = 3.0;
    self.labelSeven.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelSeven.layer.borderWidth = 3.0;
    self.labelEight.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelEight.layer.borderWidth = 3.0;
    self.labelNine.layer.borderColor = [UIColor grayColor].CGColor;
    self.labelNine.layer.borderWidth = 3.0;
    self.whichPlayerLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.whichPlayerLabel.layer.borderWidth = 3.0;
}

#pragma mark Gesture Recognizer

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{

    

}

#pragma mark Helpers Methods

- (void)findLabelUsingPoint:(CGPoint)point
{

}

@end
