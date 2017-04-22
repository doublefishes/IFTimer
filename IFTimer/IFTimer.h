//
//  IFTimer.h
//
//  Created by Jun Lin on 13/04/2017.
//

#import <Foundation/Foundation.h>

@interface IFTimer : NSObject


+ (void)addObserver:(id)observer selector:(SEL)aSelector evtName:(NSString*)aEvtName;
+ (void)removeObserver:(id)observer evtName:(NSString*)aEvtName;

- (void)addEvent:(NSString*)aEvtName interval:(NSNumber*)ms;
- (void)removeEvent:(NSString*)aEvtName;

- (void)start;
- (void)stop;

- (void)setActiveInterval:(NSTimeInterval)interval;
@end
