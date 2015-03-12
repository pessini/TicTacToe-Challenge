//
//  GameViewController.m
//  TicTacToe
//
//  Created by Leandro Pessini on 3/12/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController () <UIAlertViewDelegate>

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

@property NSArray *arrayWinnerX;
@property NSArray *arrayWinnerO;

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

    // X will be the first to play
    self.whichPlayerLabel.text = @"X";

    self.arrayWinnerX = [NSArray arrayWithObjects:@"X",@"X",@"X", nil];
    self.arrayWinnerO = [NSArray arrayWithObjects:@"O",@"O",@"O", nil];
}

#pragma mark Gesture Recognizer

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{

    CGPoint point = [tapGestureRecognizer locationInView:self.view];
    UILabel *labelTouched = [self findLabelUsingPoint:point];

    // check if a UILabel was touched and it was not touched before
    if (labelTouched != nil && [labelTouched.text isEqualToString:@""]) {
        labelTouched.text = self.whichPlayerLabel.text;

        if ([self.whichPlayerLabel.text isEqualToString:@"X"])
        {
            labelTouched.textColor = [UIColor redColor];
            self.whichPlayerLabel.text = @"O";
        }
        else
        {
            labelTouched.textColor = [UIColor blueColor];
            self.whichPlayerLabel.text = @"X";
        }

        NSString *whoWon = [self whoWon];

        // it has a winner
        if (whoWon) {
            UIAlertView *alertWinner = [[UIAlertView alloc] initWithTitle:@"The Winner"
                                                                  message:whoWon
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"Start Over", nil];
            [alertWinner show];
        }
    }
}

#pragma mark UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self resetGame];
    }
}

#pragma mark Helpers Methods

- (UILabel *)findLabelUsingPoint:(CGPoint)point
{

    if (CGRectContainsPoint(self.labelOne.frame, point))
    {
        return self.labelOne;
    }
    else if (CGRectContainsPoint(self.labelTwo.frame, point))
    {
        return self.labelTwo;
    }
    else if (CGRectContainsPoint(self.labelThree.frame, point))
    {
        return self.labelThree;
    }
    else if (CGRectContainsPoint(self.labelFour.frame, point))
    {
        return self.labelFour;
    }
    else if (CGRectContainsPoint(self.labelFive.frame, point))
    {
        return self.labelFive;
    }
    else if (CGRectContainsPoint(self.labelSix.frame, point))
    {
        return self.labelSix;
    }
    else if (CGRectContainsPoint(self.labelSeven.frame, point))
    {
        return self.labelSeven;
    }
    else if (CGRectContainsPoint(self.labelEight.frame, point))
    {
        return self.labelEight;
    }
    else if (CGRectContainsPoint(self.labelNine.frame, point))
    {
        return self.labelNine;
    }

    return nil;
}

-(NSString *)whoWon
{

    NSString *theWinner = nil;


    // combinations to win - 8

    NSArray *arrayCombOne = @[self.labelOne.text, self.labelTwo.text, self.labelThree.text];
    NSArray *arrayCombTwo = @[self.labelOne.text, self.labelFour.text, self.labelSeven.text];
    NSArray *arrayCombThree = @[self.labelOne.text, self.labelFive.text, self.labelNine.text];

    NSArray *arrayCombFour = @[self.labelTwo.text, self.labelFive.text, self.labelEight.text];

    NSArray *arrayCombFive = @[self.labelThree.text, self.labelFive.text, self.labelSeven.text];
    NSArray *arrayCombSix = @[self.labelThree.text, self.labelSix.text, self.labelNine.text];

    NSArray *arrayCombSeven = @[self.labelFour.text, self.labelFive.text, self.labelSix.text];
    NSArray *arrayCombEight = @[self.labelSeven.text, self.labelEight.text, self.labelNine.text];


    if ([self.arrayWinnerX isEqualToArray:arrayCombOne]
        || [self.arrayWinnerX isEqualToArray:arrayCombTwo]
        || [self.arrayWinnerX isEqualToArray:arrayCombThree]
        || [self.arrayWinnerX isEqualToArray:arrayCombFour]
        || [self.arrayWinnerX isEqualToArray:arrayCombFive]
        || [self.arrayWinnerX isEqualToArray:arrayCombSix]
        || [self.arrayWinnerX isEqualToArray:arrayCombSeven]
        || [self.arrayWinnerX isEqualToArray:arrayCombEight]
        )
    {
        theWinner = @"X";
    }
    else if ([self.arrayWinnerO isEqualToArray:arrayCombOne]
             || [self.arrayWinnerO isEqualToArray:arrayCombTwo]
             || [self.arrayWinnerO isEqualToArray:arrayCombThree]
             || [self.arrayWinnerO isEqualToArray:arrayCombFour]
             || [self.arrayWinnerO isEqualToArray:arrayCombFive]
             || [self.arrayWinnerO isEqualToArray:arrayCombSix]
             || [self.arrayWinnerO isEqualToArray:arrayCombSeven]
             || [self.arrayWinnerO isEqualToArray:arrayCombEight]
             )
    {
        theWinner = @"O";

    }

    return theWinner;
}
- (IBAction)resetGame:(UIBarButtonItem *)sender {
    [self resetGame];
}

- (void)resetGame
{
    self.labelOne.text = nil;
    self.labelTwo.text = nil;
    self.labelThree.text = nil;
    self.labelFour.text = nil;
    self.labelFive.text = nil;
    self.labelSix.text = nil;
    self.labelSeven.text = nil;
    self.labelEight.text = nil;
    self.labelNine.text = nil;

    self.whichPlayerLabel.text = @"X";
}

@end
