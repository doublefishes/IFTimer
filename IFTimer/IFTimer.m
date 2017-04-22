//
//  IFTimer.m
//
//  Created by Jun Lin on 13/04/2017.
//

#import "IFTimer.h"

// in second
#define _DEFAULT_TIMER_ACTIVE_INTERVAL 0.1

NSString* evt_name = 				@"name";
NSString* evt_interval = 			@"interval";
NSString* evt_last_active_time =	@"time";

@interface IFTimer()
{
    NSTimer*				_timer;
    NSTimeInterval			_interval;
    NSMutableArray*			_events;
    NSObject*				_lock;
}
@end

@implementation IFTimer

+ (void)addObserver:(id)observer selector:(SEL)aSelector evtName:(NSString*)aEvtName
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aEvtName object:nil];
}

+ (void)removeObserver:(id)observer evtName:(NSString*)aEvtName
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aEvtName object:nil];
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _timer 	= nil;
        _lock	= [[NSObject alloc] init];
        _interval = _DEFAULT_TIMER_ACTIVE_INTERVAL;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    if(_events)
    {
        for (NSMutableDictionary* evt in _events)
        {
            [evt release];
        }
        [_events release];
        _events = nil;
    }
    if(_lock)
    {
        [_events release];
        _events = nil;
    }
}

- (void)setActiveInterval:(NSTimeInterval)interval
{
    _interval = interval;
    
    if(_timer)
    {
        [self stop];
        [self start];
    }
}

- (BOOL)isExistEvent:(NSString*)aEvtName
{
    @synchronized (_lock)
    {
        for(int n=0; n<[_events count]; n++)
        {
            NSMutableDictionary* evt = [_events objectAtIndex:n];
            NSString* currName = [evt objectForKey:evt_name];
            
            if([aEvtName isEqualToString:currName])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)addEvent:(NSString*)aEvtName interval:(NSNumber*)ms
{
    if([self isExistEvent:aEvtName])
        return;
    
    @synchronized (_lock)
    {
        if(!_events)
            _events = [[NSMutableArray alloc] init];
        
        NSMutableDictionary* evt = [[NSMutableDictionary alloc] init];
        [evt setValue:aEvtName forKey:evt_name];
        [evt setValue:ms forKey:evt_interval];
        [evt setValue:[NSNumber numberWithInt:[self getSysTime]] forKey:evt_last_active_time];
        [_events addObject:evt];
    }
}

- (void)removeEvent:(NSString*)aEvtName
{
    if(!_events || [_events count]<=0)
        return;
    
    @synchronized (_lock)
    {
        for(int n=0; n<[_events count]; n++)
        {
            NSMutableDictionary* evt = [_events objectAtIndex:n];
            NSString* currName = [evt objectForKey:evt_name];
            if([aEvtName isEqualToString:currName])
            {
                [_events removeObject:evt];
                break;
            }
        }
    }
}


- (void)start
{
    [self stop];

    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(onFire) userInfo:nil repeats:YES];
}

- (void)stop
{
    if(_timer)
    {
        [_timer invalidate];
    }
}

- (void)onFire
{
    if(!_events || [_events count]<=0)
        return;

    @synchronized (_lock)
    {
        //NSLog(@"Fired");
        
        int currTime = [self getSysTime];
        
        for(NSDictionary* evt in _events)
        {
            NSNumber* interval = [evt objectForKey:evt_interval];
            NSNumber* lastTime = [evt objectForKey:evt_last_active_time];
            
            if((currTime-lastTime.intValue) >= [interval floatValue]*1000)
            {
                NSString* name = [evt objectForKey:evt_name];
                [evt setValue:[NSNumber numberWithInt:currTime] forKey:evt_last_active_time];
                [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
            }
        }
    }
}

- (int)getSysTime
{
    return [[NSProcessInfo processInfo] systemUptime] * 1000;
}



@end
