//
//  CubeServiceMessage.h
//  LOLGramatik
//
//  Created by Jan Brond on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CubeServiceMessage : NSObject {
    int cubeId;
    NSString * cubeName;
}

@property (nonatomic) int cubeId;
@property (strong,nonatomic) NSString * cubeName;

@end
