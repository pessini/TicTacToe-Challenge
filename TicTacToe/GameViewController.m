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

@property (weak, nonatomic) IBOutlet UILabel *squareX;
@property (weak, nonatomic) IBOutlet UILabel *squareO;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;


@property CGPoint originalCenterSquareX;
@property CGPoint originalCenterSquareO;

@property NSArray *arrayWinnerX;
@property NSArray *arrayWinnerO;

@property NSTimer *timer;
@property int remainingTicks;

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

    self.originalCenterSquareX = self.squareX.center;
    self.originalCenterSquareO = self.squareO.center;

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

        [self.timer invalidate];
        self.timer = nil;
        [self startTimer];
    }
}

- (IBAction)dragToPlay:(UIPanGestureRecognizer *)gestureRecognizer
{

    CGPoint point = [gestureRecognizer locationInView:self.view];
    UILabel *labelTouched = [self findLabelUsingPoint:point];

    // check if UILabel touched is some of the squares
    if ([labelTouched isEqual:self.squareX] || [labelTouched isEqual:self.squareO])
    {

        if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            NSLog(@"%@", NSStringFromCGPoint(self.squareX.center));

            // when gesture ends it starts animation block
            [UIView animateWithDuration:1.0 animations:^{
                if ([labelTouched isEqual:self.squareX])
                {
                    self.squareX.center = self.originalCenterSquareX;

                }
                else if ([labelTouched isEqual:self.squareO])
                {
                    self.squareO.center = self.originalCenterSquareO;

                }
            }];
        }
        else
        {
            // give the location a view to contextualize the gesture
            CGPoint point = [gestureRecognizer locationInView:self.view];
            labelTouched.center = point;

            NSLog(@"%@", labelTouched.text);

            if (CGRectContainsPoint(self.labelOne.frame, point))
            {
                if ([labelTouched isEqual:self.squareX])
                {
                    self.labelOne.text = @"X";
                    self.labelOne.textColor = [UIColor redColor];
                    self.whichPlayerLabel.text = @"O";
                }
                else if ([labelTouched isEqual:self.squareO])
                {
                    self.labelOne.text = @"O";
                    self.labelOne.textColor = [UIColor blueColor];
                    self.whichPlayerLabel.text = @"X";
                }
            }


//            // does the math to see if the rectangle is contained by point's coordinates
//            if (CGRectContainsPoint(labelTouched.frame, point))
//            {
//                // check if UILabel touched is some of the squares
//                if ([labelTouched isEqual:self.squareX])
//                {
//                    labelTouched.textColor = [UIColor redColor];
//                    self.whichPlayerLabel.text = @"O";
//                }
//                else if ([labelTouched isEqual:self.squareO])
//                {
//                    labelTouched.textColor = [UIColor blueColor];
//                    self.whichPlayerLabel.text = @"X";
//                }
//            }
        }
    }
}

#pragma mark NSTimer

-(void)moveForfeited:(NSTimer *)timer
{

    self.remainingTicks--;

    if (self.remainingTicks <= 0) {
        [self.timer invalidate];
        self.timer = nil;

        if ([self.whichPlayerLabel.text isEqualToString:@"X"])
        {
            self.whichPlayerLabel.text = @"O";
        }
        else
        {
            self.whichPlayerLabel.text = @"X";
        }

        [self startTimer];
    }
    else if (self.remainingTicks == 1)
    {
        self.timerLabel.text = [NSString stringWithFormat:@"%i second", self.remainingTicks];
    }
    else
    {
        self.timerLabel.text = [NSString stringWithFormat:@"%i seconds", self.remainingTicks];
    }

}

-(void)startTimer
{

    // 10 seconds each game
    self.remainingTicks = 10;
    self.timerLabel.text = [NSString stringWithFormat:@"%i seconds", self.remainingTicks];

    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector:@selector(moveForfeited:)
                                                userInfo: nil
                                                 repeats:YES];
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
    else if (CGRectContainsPoint(self.squareX.frame, point))
    {
        return self.squareX;
    }
    else if (CGRectContainsPoint(self.squareO.frame, point))
    {
        return self.squareO;
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
    self.labelOne.text      = @"";
    self.labelTwo.text      = @"";
    self.labelThree.text    = @"";
    self.labelFour.text     = @"";
    self.labelFive.text     = @"";
    self.labelSix.text      = @"";
    self.labelSeven.text    = @"";
    self.labelEight.text    = @"";
    self.labelNine.text     = @"";

    self.whichPlayerLabel.text = @"X";

    [self.timer invalidate];
    self.timer = nil;

    [self startTimer];
}

#pragma mark UIStoryboardSegue

-(IBAction)unwindFromHelp:(UIStoryboardSegue *)sender
{

}

@end
