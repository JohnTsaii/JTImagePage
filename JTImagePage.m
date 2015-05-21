//
//  JTImagePage.m
//  JTImagePage
//
//  Created by John TSai on 15/5/19.
//  Copyright (c) 2015年 John TSai. All rights reserved.
//

#import "JTImagePage.h"
#import "JTImageView.h"

@interface JTImagePage ()
<UIScrollViewDelegate>{
    @private
    NSArray *_dataArray;
    NSMutableArray *_visibleTileViews;
    NSMutableArray *_recycledTileViews;
}

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation JTImagePage

@synthesize pageControl;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.directionalLockEnabled = YES;
    self.alwaysBounceHorizontal = YES;
    self.delegate = self;
    self.contentSize = [self contentSize];
    
    self.direction = ScrollDirectionNone;
    self.lastContentOffset = 0.0f;
    
    _visibleTileViews = [[NSMutableArray alloc] init];
    _recycledTileViews = [[NSMutableArray alloc] init];
    
    // init page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.numberOfPages = 0;
//    [self addSubview:self.pageControl];
    
    // set control position defalut JTImagePageControlPositionBottomRight
    self.controlPosition = JTImagePageControlPositionBottomRight;
    
    self.infinite = YES;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(320, 100);
}

- (void)reloadData {
    if (self.dataSource)
        _dataArray = [self.dataSource(self) copy];
    
    if (_dataArray.count < 1)
        return;
    
    // set content size
    self.contentSize = [self contentSize];
    // set total number page
    self.numberOfPages = _dataArray.count;
    
    // remove all views
    [_visibleTileViews removeAllObjects];
    
    if (_dataArray.count < 3) {
        
        return;
    }
    
    for (int i = 0; i < 3; i ++) {
        @autoreleasepool {
            JTImageView *imageView = [[JTImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            imageView.image = [_dataArray objectAtIndex:i];
            imageView.index = i;
            imageView.page = i;
            if (i == 0)
                imageView.isVisible = YES;
            else
                imageView.isVisible = NO;
                
            imageView.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:imageView];
            
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                  initWithTarget:self
                                                                  action:@selector(imageTapped:)];
            [singleTapGestureRecognizer setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:singleTapGestureRecognizer];
            [imageView setUserInteractionEnabled:YES];
            
            [_visibleTileViews addObject:imageView];
        }
    }
    
    // add page control constraint
//    [self addPageControlConstraint];
//    self.pageControl.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 5);
    
}

- (CGSize)contentSize
{
    if (self.infinite) {
        return CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame));
    }
    return CGSizeMake(_dataArray.count * CGRectGetWidth(self.frame), self.frame.size.height);
}

- (void)addPageControlConstraint {
    NSDictionary *views = NSDictionaryOfVariableBindings(pageControl);
    
    NSString *format;
    if (_controlPosition == JTImagePageControlPositionBottomCenter)
        format = @"H:|[pageControl]|";
    
    if (_controlPosition == JTImagePageControlPositionBottomLeft)
        format = @"H:|-[pageControl]->=0-|";
    
    if (_controlPosition == JTImagePageControlPositionBottomRight)
        format = @"H:|->=0-[pageControl]-|";
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

#pragma mark -
#pragma mark ImageTapped
- (void)imageTapped:(UITapGestureRecognizer *)sender {
    JTImageView *view = (JTImageView *)[(UIGestureRecognizer *)sender view];
    if (self.pageDelegate)
    self.pageDelegate(view.index);
}

#pragma mark -
#pragma mark SetMethod
- (void)setControlPosition:(JTImagePageControlPosition)controlPosition {
    _controlPosition = controlPosition;
    [self updateConstraints];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    self.pageControl.numberOfPages = numberOfPages;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    long currentPage = lround((float)scrollView.contentOffset.x / scrollView.frame.size.width);
    NSLog(@"currentPage %li",currentPage);
    
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        self.direction = ScrollDirectionLeft;
        
        if (currentPage == 0)
            goto END_FUCTION;
        
        [_visibleTileViews exchangeObjectAtIndex:0 withObjectAtIndex:1];
        [_visibleTileViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
        
        
        JTImageView *imageView1 = [_visibleTileViews objectAtIndex:1];
        imageView1.page = currentPage;
        imageView1.isVisible = YES;
        imageView1.index = (int)currentPage % _dataArray.count;
        
        JTImageView *imageView2 = [_visibleTileViews firstObject];
        imageView2.page = currentPage - 1;
        imageView2.isVisible = NO;
        imageView2.index = ((int)currentPage - 1) % _dataArray.count;
        imageView2.frame = [self changeFrame:imageView2.page];
        [self changeImage:imageView2];
        
        
        JTImageView *imageView3 = [_visibleTileViews lastObject];
        imageView3.page = currentPage + 1;
        imageView3.isVisible = NO;
        imageView3.index = ((int)currentPage + 1) % _dataArray.count;
        imageView3.frame = [self changeFrame:imageView3.page];
        [self changeImage:imageView3];
        
    }
    else if (self.lastContentOffset < scrollView.contentOffset.x) {
        self.direction = ScrollDirectionRight;
        
        if (currentPage == 1)
            goto END_FUCTION;
        
        [_visibleTileViews exchangeObjectAtIndex:2 withObjectAtIndex:1];
        [_visibleTileViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
        
        JTImageView *imageView1 = [_visibleTileViews objectAtIndex:1];
        imageView1.page = currentPage;
        imageView1.isVisible = YES;
        imageView1.index = (int)currentPage % _dataArray.count;
        
        JTImageView *imageView2 = [_visibleTileViews firstObject];
        imageView2.page = currentPage - 1;
        imageView2.isVisible = NO;
        imageView2.index = ((int)currentPage - 1) % _dataArray.count;
        imageView2.frame = [self changeFrame:imageView2.page];
        [self changeImage:imageView2];
        
        JTImageView *imageView3 = [_visibleTileViews lastObject];
        imageView3.page = currentPage + 1;
        imageView3.isVisible = NO;
        imageView3.index = ((int)currentPage + 1) % _dataArray.count;
        imageView3.frame = [self changeFrame:imageView3.page];
        [self changeImage:imageView3];
    }
    else
        self.direction = ScrollDirectionNone;
    
    
END_FUCTION:
    self.lastContentOffset = scrollView.contentOffset.x;
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    long currentPage = lround((float)scrollView.contentOffset.x / scrollView.frame.size.width);
//    NSLog(@"currentPage %li",currentPage);
//    
//    if (self.lastContentOffset > scrollView.contentOffset.x) {
//        self.direction = ScrollDirectionLeft;
//        
//        if (currentPage == 0)
//            goto END_FUCTION;
//        
//        [_visibleTileViews exchangeObjectAtIndex:0 withObjectAtIndex:1];
//        [_visibleTileViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
//        
//        
//        JTImageView *imageView1 = [_visibleTileViews objectAtIndex:1];
//        imageView1.page = currentPage;
//        imageView1.isVisible = YES;
//        imageView1.index = (int)currentPage % _dataArray.count;
//        
//        JTImageView *imageView2 = [_visibleTileViews firstObject];
//        imageView2.page = currentPage - 1;
//        imageView2.isVisible = NO;
//        imageView2.index = ((int)currentPage - 1) % _dataArray.count;
//        imageView2.frame = [self changeFrame:imageView2.page];
//        [self changeImage:imageView2];
//        
//        
//        JTImageView *imageView3 = [_visibleTileViews lastObject];
//        imageView3.page = currentPage + 1;
//        imageView3.isVisible = NO;
//        imageView3.index = ((int)currentPage + 1) % _dataArray.count;
//        imageView3.frame = [self changeFrame:imageView3.page];
//        [self changeImage:imageView3];
//        
//    }
//    else if (self.lastContentOffset < scrollView.contentOffset.x) {
//        self.direction = ScrollDirectionRight;
//        
//        if (currentPage == 1)
//            goto END_FUCTION;
//        
//        [_visibleTileViews exchangeObjectAtIndex:2 withObjectAtIndex:1];
//        [_visibleTileViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
//        
//        JTImageView *imageView1 = [_visibleTileViews objectAtIndex:1];
//        imageView1.page = currentPage;
//        imageView1.isVisible = YES;
//        imageView1.index = (int)currentPage % _dataArray.count;
//        
//        JTImageView *imageView2 = [_visibleTileViews firstObject];
//        imageView2.page = currentPage - 1;
//        imageView2.isVisible = NO;
//        imageView2.index = ((int)currentPage - 1) % _dataArray.count;
//        imageView2.frame = [self changeFrame:imageView2.page];
//        [self changeImage:imageView2];
//        
//        JTImageView *imageView3 = [_visibleTileViews lastObject];
//        imageView3.page = currentPage + 1;
//        imageView3.isVisible = NO;
//        imageView3.index = ((int)currentPage + 1) % _dataArray.count;
//        imageView3.frame = [self changeFrame:imageView3.page];
//        [self changeImage:imageView3];
//    }
//    else
//        self.direction = ScrollDirectionNone;
//    
//    
//END_FUCTION:
//    self.lastContentOffset = scrollView.contentOffset.x;
//}
#pragma mark -
#pragma mark ChangeValue
- (CGRect)changeFrame:(NSUInteger)page {
    return CGRectMake(self.frame.size.width * page, 0, self.frame.size.width, self.frame.size.height);
}

- (void)changeImage:(JTImageView *)imageView {
    imageView.image = [_dataArray objectAtIndex:imageView.index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
