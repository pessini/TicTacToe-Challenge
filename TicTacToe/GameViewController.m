//
//  GameViewController.m
//  TicTacToe
//
//  Created by Leandro Pessini on 3/12/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "GameViewController.h"
#import "MBProgressHUD.h"

#define TIME_FOR_EACH_PLAYER 5

@interface GameViewController () <UIAlertViewDelegate, UIGestureRecognizerDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;


@property (weak, nonatomic) IBOutlet UIView *computerTurnView;
@property (weak, nonatomic) IBOutlet UIImageView *waitingComputerImageView;


@property CGPoint originalCenterWhichPlayerSquare;

@property NSArray *arrayWinnerX;
@property NSArray *arrayWinnerO;

@property NSTimer *timer;
@property int remainingTicks;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // add borders for UILabels

    self.labelOne.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelOne.layer.borderWidth = 3.0;
    self.labelTwo.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelTwo.layer.borderWidth = 3.0;
    self.labelThree.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelThree.layer.borderWidth = 3.0;
    self.labelFour.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelFour.layer.borderWidth = 3.0;
    self.labelFive.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelFive.layer.borderWidth = 3.0;
    self.labelSix.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelSix.layer.borderWidth = 3.0;
    self.labelSeven.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelSeven.layer.borderWidth = 3.0;
    self.labelEight.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelEight.layer.borderWidth = 3.0;
    self.labelNine.layer.borderColor = [UIColor blackColor].CGColor;
    self.labelNine.layer.borderWidth = 3.0;
    self.whichPlayerLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.whichPlayerLabel.layer.borderWidth = 3.0;

    // X will be the first to play
    self.whichPlayerLabel.text = @"X";
    self.timerLabel.text = [NSString stringWithFormat:@"%i seconds", TIME_FOR_EACH_PLAYER];
    self.originalCenterWhichPlayerSquare = self.whichPlayerLabel.center;

    self.arrayWinnerX = [NSArray arrayWithObjects:@"X",@"X",@"X", nil];
    self.arrayWinnerO = [NSArray arrayWithObjects:@"O",@"O",@"O", nil];

    // hide the view which shows that it is the computer's turn
    self.computerTurnView.hidden = YES;

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
        }
        else
        {
            labelTouched.textColor = [UIColor blueColor];
        }

        self.whichPlayerLabel.text = [self switchSquare:self.whichPlayerLabel.text];

        if (self.gameTypeSegmentedControl.selectedSegmentIndex == 0)
        {
            [self computersTurn];
        }
        else
        {
            [self whoWon];
            [self changingTurn];
        }

    }
}

- (IBAction)dragToPlay:(UIPanGestureRecognizer *)gestureRecognizer
{

    CGPoint point = [gestureRecognizer locationInView:self.view];
    self.whichPlayerLabel.center = point;

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // when gesture ends it starts animation block
        [UIView animateWithDuration:1.0 animations:^{

            self.whichPlayerLabel.center = self.originalCenterWhichPlayerSquare;

        }];

        UILabel *labelTouched = [self findLabelUsingPoint:point];

        // check if a UILabel was touched and it was not touched before
        if (labelTouched != nil && [labelTouched.text isEqualToString:@""]) {

            if (CGRectContainsPoint(labelTouched.frame, point))
            {
                if ([self.whichPlayerLabel.text isEqualToString:@"X"])
                {
                    labelTouched.text = @"X";
                    labelTouched.textColor = [UIColor redColor];
                    self.whichPlayerLabel.text = @"O";
                }
                else
                {
                    labelTouched.text = @"O";
                    labelTouched.textColor = [UIColor blueColor];
                    self.whichPlayerLabel.text = @"X";
                }

                if (self.gameTypeSegmentedControl.selectedSegmentIndex == 0)
                {
                    [self computersTurn];
                }
                else
                {
                    [self whoWon];
                    [self changingTurn];
                }
            }
        }
    }
}

#pragma mark NSTimer

-(void)moveForfeited:(NSTimer *)timer
{
    self.remainingTicks--;

    if (self.remainingTicks <= 0)
    {
        self.whichPlayerLabel.text = [self switchSquare:self.whichPlayerLabel.text];

        // check if it is the computer's turn to see if the game is over
        if (self.gameTypeSegmentedControl.selectedSegmentIndex == 0)
        {
            [self whoWon];
            // need to re-reable all gestures on the view
            NSArray *gestures = self.view.gestureRecognizers;
            for(UIGestureRecognizer *gesture in gestures)
            {
                if([gesture isKindOfClass: [UITapGestureRecognizer class]])
                {
                    gesture.enabled = YES;
                }
            }
            self.computerTurnView.hidden = YES;

        }

        [self changingTurn];
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
    self.remainingTicks = TIME_FOR_EACH_PLAYER;
    self.timerLabel.text = [NSString stringWithFormat:@"%i seconds", TIME_FOR_EACH_PLAYER];

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

    return nil;
}

-(void)computersTurn
{
    [self whoWon];
    [self changingTurn];

    // need to disable all gestures on the view
    NSArray *gestures = self.view.gestureRecognizers;
    for(UIGestureRecognizer *gesture in gestures)
    {
        if([gesture isKindOfClass: [UITapGestureRecognizer class]])
        {
            gesture.enabled = NO;
        }
    }
//    self.computerTurnView.userInteractionEnabled = NO;

//    to get how many UILabels are empty yet

    int i=0;

    for (UIView *views in self.view.subviews){
        if([views isKindOfClass:[UILabel class]]){
            UILabel *newLbl = (UILabel *)views;
            if (newLbl != nil && [newLbl.text isEqualToString:@""]) {

                i++;

            }
        }
    }

    int k=0;
    int randomLabel = arc4random_uniform(i);

    for (UIView *views in self.view.subviews){
        if([views isKindOfClass:[UILabel class]]){
            UILabel *newLbl = (UILabel *)views;
            if (newLbl != nil && [newLbl.text isEqualToString:@""]) {

                if (k == randomLabel) {
                    newLbl.text = @"O";
                    newLbl.textColor = [UIColor blueColor];

                }

                k++;

            }
        }
    }

    // enable view
    self.computerTurnView.hidden = NO;

}

-(void)changingTurn
{
    [self.timer invalidate];
    self.timer = nil;
    [self startTimer];
}

-(void)whoWon
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

    // it has a winner
    if (theWinner)
    {
        [self resetGame];

        UIAlertView *alertWinner = [[UIAlertView alloc] initWithTitle:@"The Winner"
                                                              message:theWinner
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"Start Over", nil];
        [alertWinner show];

    }

    int i=0;

    for (UIView *views in self.view.subviews){
        if([views isKindOfClass:[UILabel class]]){
            UILabel *newLbl = (UILabel *)views;
            if (newLbl != nil && [newLbl.text isEqualToString:@""]) {
                i++;
            }
        }
    }

    if (i == 0)
    {
        [self resetGame];

        UIAlertView *alertWinner = [[UIAlertView alloc] initWithTitle:@"It's a draw"
                                                              message:@"No winner this time!"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"Start Over", nil];
        [alertWinner show];
    }
}

- (NSString *)switchSquare:(NSString *)current
{

    if ([current isEqualToString:@"X"])
    {
        current = @"O";
    }
    else
    {
        current = @"X";
    }

    return current;
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
    self.timerLabel.text = [NSString stringWithFormat:@"%i seconds", TIME_FOR_EACH_PLAYER];

    [self.timer invalidate];
    self.timer = nil;

    self.computerTurnView.hidden = YES;

}

#pragma mark UIStoryboardSegue

-(IBAction)unwindFromHelp:(UIStoryboardSegue *)sender
{
    
}

#pragma mark -IBAction
- (IBAction)resetGame:(UIBarButtonItem *)sender {
    [self resetGame];
}

- (IBAction)onGameTypeChoosen:(UISegmentedControl *)sender
{

    UIAlertView *alertGameType = [UIAlertView new];

    if (sender.selectedSegmentIndex == 0)
    {
        alertGameType.title = @"One Player Game";
        alertGameType.message = @"You are the X Player!";
        [alertGameType addButtonWithTitle:@"Ok"];
    }
    else
    {
        alertGameType.title = @"Two Players Game";
        alertGameType.message = @"Good Luck!";
        [alertGameType addButtonWithTitle:@"Ok"];
    }

    [alertGameType show];

}

@end
