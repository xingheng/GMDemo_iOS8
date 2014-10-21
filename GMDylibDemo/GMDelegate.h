//
//  GMDelegate.h
//  GMDylibDemo
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "GMDylibDemo.h"

#ifndef GMDylibDemo_GMDelegate_h
#define GMDylibDemo_GMDelegate_h

@protocol GMDelegate <NSObject>

- (NSArray *)loadData:(NSError **)error;

@end

#endif
