//
//  LoadingOverlay.h
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/23/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface LoadingOverlay : UIView

@property (nonatomic, readonly) BOOL isAnimating;

/** Shows loading overlay in specified view.
 Default style is UIActivityIndicatorViewStyleWhite.
 Default caption text is an empty string.
 
 @param view View where to show loading overlay.
 @param backgroundColor Color of the loading overlay background. Nil = clearColor.
 */
+ (LoadingOverlay *)showLoadingOverlayInView:(UIView *)view
                               backgroundColor:(UIColor *)backgroundColor
                                      animated:(BOOL)animated;

+ (LoadingOverlay *)showLoadingOverlayInView:(UIView *)view
                               backgroundColor:(UIColor *)backgroundColor
                                  spinnerStyle:(UIActivityIndicatorViewStyle)spinnerStyle
                                      animated:(BOOL)animated;

+ (LoadingOverlay *)showLoadingOverlayInView:(UIView *)view
                               backgroundColor:(UIColor *)backgroundColor
                                  spinnerStyle:(UIActivityIndicatorViewStyle)spinnerStyle
                                          text:(NSString *)string
                                      animated:(BOOL)animated;

+ (void)hideAllLoadingOverlaysInView:(nullable UIView *)view animated:(BOOL)animated;
+ (nullable id)loadingOverlayForView:(nullable UIView *)view;

- (void)hideAnimated:(BOOL)animated;

@end
NS_ASSUME_NONNULL_END

