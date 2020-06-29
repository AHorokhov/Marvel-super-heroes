//
//  LoadingOverlay.m
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/23/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

#import "LoadingOverlay.h"


@interface LoadingOverlay()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation LoadingOverlay

#pragma mark - Public
#pragma mark -

+ (LoadingOverlay *)showLoadingOverlayInView:(UIView *)view
                               backgroundColor:(UIColor *)backgroundColor
                                      animated:(BOOL)animated {
    return [self showLoadingOverlayInView:view backgroundColor:backgroundColor spinnerStyle:UIActivityIndicatorViewStyleWhite animated:animated];
}

+ (LoadingOverlay *)showLoadingOverlayInView:(UIView *)view
                               backgroundColor:(UIColor *)backgroundColor
                                  spinnerStyle:(UIActivityIndicatorViewStyle)spinnerStyle
                                      animated:(BOOL)animated {
    return [self showLoadingOverlayInView:view backgroundColor:backgroundColor spinnerStyle:spinnerStyle text:@"" animated:animated];
}

+ (LoadingOverlay *)showLoadingOverlayInView:(UIView *)view
                               backgroundColor:(UIColor *)backgroundColor
                                  spinnerStyle:(UIActivityIndicatorViewStyle)spinnerStyle
                                          text:(NSString *)text
                                      animated:(BOOL)animated {
    LoadingOverlay *loadingOverlay = [[LoadingOverlay alloc] initWithSize:view.bounds.size activityIndicatorStyle:spinnerStyle];
    loadingOverlay.backgroundColor = backgroundColor ?: UIColor.clearColor;
    loadingOverlay.textLabel.text = text;
    loadingOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:loadingOverlay];
    
    // Add constraints.
    NSDictionary *views = @{ @"loadingOverlay": loadingOverlay };
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[loadingOverlay]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[loadingOverlay]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [view addConstraints:[horizontalConstraints arrayByAddingObjectsFromArray:verticalConstraints]];
    
    [loadingOverlay showAnimated:animated];
    return loadingOverlay;
}

+ (void)hideAllLoadingOverlaysInView:(UIView *)view animated:(BOOL)animated {
    NSArray *loadingOverlaysArrays = [LoadingOverlay allLoadingOverlaysInView:view];
    for (LoadingOverlay *loadingOverlay in loadingOverlaysArrays) {
        [loadingOverlay hideAnimated:animated];
    }
}

- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        // Disappearance animation.
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundColor = [UIColor clearColor];
            self->_activityIndicator.transform = CGAffineTransformMakeScale(0.1, 0.1);
            // 0.02 prevents the loadingOverlay from passing through touches during the animation.
            self.alpha = 0.02f;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self finish];
            });
        }];
    }
    else {
        [self finish];
    }
}





#pragma mark - Private
#pragma mark -

- (id)initWithSize:(CGSize)size activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self = [super initWithFrame:frame];
    if (self) {
        // Transparent background.
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeCenter;
        
        // Add activity indicator.
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorStyle];
        [self addSubview:self.activityIndicator];
        self.activityIndicator.center = self.center;
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        // Add text label.
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
        self.textLabel.text = @"";
        self.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f];
        self.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self addSubview:self.textLabel];
        
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.textLabel.topAnchor constraintEqualToAnchor:self.activityIndicator.bottomAnchor constant:10.0].active = YES;
        [self.textLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20.0].active = YES;
        [self.textLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20.0].active = YES;
        
        // Make invisible for now.
        self.alpha = 0.0f;
    }
    
    return self;
}

+ (id)loadingOverlayForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (LoadingOverlay *)subview;
        }
    }
    return nil;
}

+ (NSArray *)allLoadingOverlaysInView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}





# pragma mark - Internal show & hide operations

- (void)showAnimated:(BOOL)animated {
    [self setNeedsDisplay];
    
    if (animated) {
        // Scale image view down before the animation.
        _activityIndicator.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        // Appearance animation.
        [UIView animateWithDuration:0.4f animations:^{
            self->_activityIndicator.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.alpha = 1.0f;
        }];
    }
    else {
        self.alpha = 1;
    }
    
    [self.activityIndicator startAnimating];
}

- (void)finish {
    self.alpha = 0;
    [self.activityIndicator stopAnimating];
    
    _activityIndicator = nil;
    [self removeFromSuperview];
}

@end

