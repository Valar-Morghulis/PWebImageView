//
//  PWebImageView.h
//  CBSWallet
//
//  Created by yaoyongping on 12-11-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebImage.h"
extern NSString * PW_DEFAULT_EMPTY_IMAGE;//默认图片
extern UIColor * PW_DEFAULT_BACKGROUNDCOLOR;//默认背景


@interface PWebImageView : UIView
{
    id <SDWebImageOperation> _operation;
    UIViewContentMode _contentMode;
    UIActivityIndicatorView *_activityView;
    UIImage * _defaultImage;
    UIImage * _emptyImage;
    UIImageView *_imageView;
    UIViewContentMode _emptyOrDefaultContentMode;
    UIColor * _defaultColor;
}
@property(nonatomic, retain) id <SDWebImageOperation> _operation;

@property(nonatomic,readonly) BOOL _isLoadingImage;
@property(nonatomic,readwrite) UIViewContentMode _contentMode;
@property(nonatomic,readwrite) UIViewContentMode _emptyOrDefaultContentMode;
@property(nonatomic,retain) UIActivityIndicatorView *_activityView;
@property(nonatomic,retain) UIColor * _defaultColor;
@property(nonatomic,retain) UIImage * _defaultImage;
@property(nonatomic,retain) UIImage * _emptyImage;
@property(nonatomic,retain) UIImageView *_imageView;

-(void)loadImage:(NSString *)imageUrl;
-(void)loadImage:(NSString *)imageUrl options:(SDWebImageOptions)options;
-(void)setImage:(UIImage *)img;
-(void)cancelLoad;

@end
