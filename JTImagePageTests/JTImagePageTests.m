//
//  JTImagePageTests.m
//  JTImagePageTests
//
//  Created by CC on 15/5/19.
//  Copyright (c) 2015年 John TSai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface JTImagePageTests : XCTestCase

@end

@implementation JTImagePageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    
}

- (void)testExchangeArrayMeta {
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"first",@"second",@"third", nil];
    
    XCTAssertEqualObjects([array firstObject], @"first");
    XCTAssertEqualObjects([array objectAtIndex:1], @"second");
    XCTAssertEqualObjects([array lastObject], @"third");
    
    [array exchangeObjectAtIndex:2 withObjectAtIndex:1];
    [array exchangeObjectAtIndex:0 withObjectAtIndex:2];
    
    XCTAssertEqualObjects([array firstObject], @"second");
    XCTAssertEqualObjects([array objectAtIndex:1], @"third");
    XCTAssertEqualObjects([array lastObject], @"first");
    
    
    [array exchangeObjectAtIndex:2 withObjectAtIndex:1];
    [array exchangeObjectAtIndex:0 withObjectAtIndex:2];
    
    XCTAssertEqualObjects([array firstObject], @"third");
    XCTAssertEqualObjects([array objectAtIndex:1], @"first");
    XCTAssertEqualObjects([array lastObject], @"second");
    
    
    [array exchangeObjectAtIndex:2 withObjectAtIndex:1];
    [array exchangeObjectAtIndex:0 withObjectAtIndex:2];
    
    XCTAssertEqualObjects([array firstObject], @"first");
    XCTAssertEqualObjects([array objectAtIndex:1], @"second");
    XCTAssertEqualObjects([array lastObject], @"third");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
