
#import <Kiwi/Kiwi.h>


SPEC_BEGIN(SIAContextualCallToActionScrollHandlerSpec)

#warning - breaks ui tests, disabled now so will go to seperate bundle

describe(@"SIAContextualCallToActionScrollHandler", ^{
    __block UIView *viewToHide;
    __block UIView *viewToShow;
    __block UIView *viewToShowSuperView;
    __block UIScrollView *scrollView;
    __block UIView *superview;
//    __block SIAContextualCallToActionScrollHandler *_subject;
    
    beforeAll(^{
        superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
        [[[UIApplication sharedApplication] keyWindow] addSubview:superview];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
        scrollView.backgroundColor = [UIColor greenColor];
        
        viewToHide = [[UIView alloc] initWithFrame:CGRectMake(0, 390, 320, 50)];
        viewToHide.backgroundColor = [UIColor blueColor];
        
        viewToShowSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 450, 320, 300)];
        viewToShowSuperView.backgroundColor = [UIColor purpleColor];
        
        viewToShow = [[UIView alloc] initWithFrame:CGRectMake(0, 250, 320, 50)];
        viewToShow.backgroundColor = [UIColor whiteColor];
        
        [superview addSubview:scrollView];
        [superview addSubview:viewToHide];
        
        [scrollView addSubview:viewToShowSuperView];
        [viewToShowSuperView addSubview:viewToShow];
        
//        _subject = [[SIAContextualCallToActionScrollHandler alloc] initScrollView:scrollView
//                                                                       viewToHide:viewToHide
//                                                           viewToHideNewSuperView:viewToShowSuperView
//                                                                       viewToShow:viewToShow
//                                                                     commonParent:superview
//                                                         heightConstraintToShrink:nil];
    });
    
    context(@"first animation", ^{
        it(@"should have 0 alpha when scroll offset is 0 or smaller", ^{
            scrollView.contentOffset = CGPointMake(0, 0);
            [[theValue(viewToHide.alpha) should] equal:1 withDelta:.1];
            
            scrollView.contentOffset = CGPointMake(0, -100);
            [[theValue(viewToHide.alpha) should] equal:1 withDelta:.1];
        });
        
        it(@"should change view alpha when its overlaid by the view to show", ^{
            scrollView.contentOffset = CGPointMake(0, 0);
            [[theValue(viewToHide.alpha) should] equal:1 withDelta:.1];
            
            scrollView.contentOffset = CGPointMake(0, 30);
            [[theValue(viewToHide.alpha) should] equal:.6 withDelta:.1];
        });
        
        it(@"should change view alpha to zero when hidden", ^{
            scrollView.contentOffset = CGPointMake(0, 50);
            [[theValue(viewToHide.alpha) should] equal:.2 withDelta:.1];
            
            scrollView.contentOffset = CGPointMake(0, 60);
            [[theValue(viewToHide.alpha) should] equal:0 withDelta:.1];
            
            scrollView.contentOffset = CGPointMake(0, 150);
            [[theValue(viewToHide.alpha) should] equal:0 withDelta:.1];
        });
        
    });
    
    it(@"should change view alpha to zero when hidden", ^{
        scrollView.contentOffset = CGPointMake(0, 280);
        [[theValue(viewToHide.alpha) should] equal:.4 withDelta:.1];
        
        scrollView.contentOffset = CGPointMake(0, 300);
        [[theValue(viewToHide.alpha) should] equal:.8 withDelta:.1];
        
        scrollView.contentOffset = CGPointMake(0, 320);
        [[theValue(viewToHide.alpha) should] equal:1 withDelta:.1];
        
        scrollView.contentOffset = CGPointMake(0, 330);
        [[theValue(viewToHide.alpha) should] equal:1 withDelta:.1];
        
        scrollView.contentOffset = CGPointMake(0, 360);
        [[theValue(viewToHide.alpha) should] equal:1 withDelta:.1];
        
        [[theValue(viewToHide.hidden) should] beYes];
        [[theValue(viewToShow.hidden) should] beNo];
    });
    
});

SPEC_END
