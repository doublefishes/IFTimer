//
//  ViewController.m
//  IFTimer
//
//  Created by Jun Lin on 21/04/2017.
//

#import "ViewController.h"
#import "IFTimer.h"

NSString* EVT_NAME1 = @"EVENT1";
NSString* EVT_NAME2 = @"EVENT2";
NSString* EVT_NAME3 = @"EVENT3";

@interface ViewController ()
{
    IFTimer* _timer;
    
    UILabel* _lable1;
    UILabel* _lable2;
    UILabel* _lable3;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 18)];
    [self.view addSubview:_lable1];
    _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 300, 18)];
    [self.view addSubview:_lable2];
    _lable3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 300, 18)];
    [self.view addSubview:_lable3];
    
    // register
    [IFTimer addObserver:self selector:@selector(updateEvt1:) evtName:EVT_NAME1];
    [IFTimer addObserver:self selector:@selector(updateEvt2:) evtName:EVT_NAME2];
    [IFTimer addObserver:self selector:@selector(updateEvt3:) evtName:EVT_NAME3];
    
    _timer = [[IFTimer alloc] init];
    [_timer addEvent:EVT_NAME1 interval:[NSNumber numberWithFloat:1.0]];
    [_timer addEvent:EVT_NAME2 interval:[NSNumber numberWithFloat:5.0]];
    [_timer addEvent:EVT_NAME3 interval:[NSNumber numberWithFloat:10.0]];
    [_timer start];
}

- (void)updateEvt1:(NSNotification*)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self._evtCount1++;
        [_lable1 setText:[NSString stringWithFormat:@"%@ comes, count %ld", EVT_NAME1, self._evtCount1]];
    }];
}

- (void)updateEvt2:(NSNotification*)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self._evtCount2++;
        [_lable2 setText:[NSString stringWithFormat:@"%@ comes, count %ld", EVT_NAME2, self._evtCount2]];
    }];
}

- (void)updateEvt3:(NSNotification*)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self._evtCount3++;
        [_lable3 setText:[NSString stringWithFormat:@"%@ comes, count %ld", EVT_NAME3, self._evtCount3]];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    
    [IFTimer removeObserver:self evtName:EVT_NAME1];
    [IFTimer removeObserver:self evtName:EVT_NAME2];
    [IFTimer removeObserver:self evtName:EVT_NAME3];
    
    if(_timer)
    {
        [_timer stop];
        [_timer release];
        _timer = nil;
    }
    if(_lable1)
    {
        [_lable1 release];
        _lable1 = nil;
    }
    if(_lable2)
    {
        [_lable2 release];
        _lable2 = nil;
    }
    if(_lable3)
    {
        [_lable3 release];
        _lable3 = nil;
    }
}


@end
