//
//  JTImagePage.h
//  JTImagePage
//
//  Created by John TSai on 15/5/19.
//  Copyright (c) 2015年 John TSai. All rights reserved.
//
//  FIXME:it is have a bug when scroll fast or scroll not end decelerating that will be skip page
//


#import <UIKit/UIKit.h>

@class JTImagePage;

/**
 *  image page data source 
 *  @param imagePage 
 *  @return a datasource array that contain the image or url
 */
typedef NSArray * (^ImagePageDataSource)(JTImagePage *imagePage);

typedef void (^ImagePageDelegate)(NSUInteger index);

typedef NS_ENUM(NSUInteger, JTImagePageControlPosition) {
    JTImagePageControlPositionBottomRight,
    JTImagePageControlPositionBottomLeft,
    JTImagePageControlPositionBottomCenter,
};

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionNone,
};

@interface JTImagePage : UIScrollView

@property (nonatomic, assign) JTImagePageControlPosition controlPosition;

@property(nonatomic) NSInteger numberOfPages;          // default is 0

@property(nonatomic) NSInteger currentPage;

@property (nonatomic, copy) ImagePageDataSource dataSource;

@property (nonatomic, copy) ImagePageDelegate pageDelegate;

@property (nonatomic, assign) ScrollDirection direction;

@property (nonatomic, assign) BOOL infinite;

- (void)reloadData;

@end
