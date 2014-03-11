//
//  Bullet.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 3/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

- (id) initWithCode: (NSString *)code andImageName:(NSString *)name{
    if ([self initWithImageNamed:@"buttletPlaceholder"]) {
       // NSLog(@"Bullet was shot");
    }
    return self;
}

@end
