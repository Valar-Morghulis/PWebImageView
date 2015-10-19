//
//  PWebImageView.m
//  CBSWallet
//
//  Created by yaoyongping on 12-11-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PWebImageView.h"

NSString * PW_DEFAULT_EMPTY_IMAGE = @"defaultEmptyImage.png";

UIColor * PW_DEFAULT_BACKGROUNDCOLOR;

@implementation PWebImageView
@synthesize _activityView;
@synthesize _contentMode;
@synthesize _defaultImage;
@synthesize _emptyImage;
@synthesize _imageView;
@synthesize _isLoadingImage;
@synthesize _delegate;

@synthesize _emptyOrDefaultContentMode;
@synthesize _defaultColor;
@synthesize _operation;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self._defaultColor = PW_DEFAULT_BACKGROUNDCOLOR;
        self._emptyOrDefaultContentMode = UIViewContentModeScaleAspectFit;
        self._contentMode = UIViewContentModeScaleToFill;
        self._emptyImage = [UIImage imageNamed:PW_DEFAULT_EMPTY_IMAGE];
        
		self._imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
		[self addSubview:self._imageView];
        [self setBackgroundColor:PW_DEFAULT_BACKGROUNDCOLOR];
        self._imageView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     
        [self setImage:self._emptyImage];
        
        //指示器
        UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        CGRect activityViewFrame = activityView.frame;
        activityViewFrame.origin.x = (frame.size.width - activityViewFrame.size.width) / 2;
        activityViewFrame.origin.y = (frame.size.height - activityViewFrame.size.height) / 2;
        activityView.frame = activityViewFrame;
        activityView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        activityView.autoresizingMask = TRUE;
        self._activityView = activityView;
        [self addSubview:activityView];
        //
        self.backgroundColor = [UIColor clearColor];
        self._imageView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"custom imageView dealloc");
    
    [self cancelLoad];
    self._defaultColor = 0;
    self._activityView = 0;
    self._defaultImage = 0;
    self._emptyImage = 0;
    self._imageView = 0;
    [super dealloc];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect activityViewFrame = self._activityView.frame;
    activityViewFrame.origin.x = (frame.size.width - activityViewFrame.size.width) / 2;
    activityViewFrame.origin.y = (frame.size.height - activityViewFrame.size.height) / 2;
    self._activityView.frame = activityViewFrame;
    //
    self._imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}
-(void)cancelLoad
{
    if(self._operation)
    {
        [self._operation cancel];
        self._operation = 0;
        [self setImage:self._emptyImage];
        [self jobsAfterDone];
    }
}
-(void)setImage:(UIImage *)img
{
    [self cancelLoad];
    [self setBackgroundColor:[UIColor clearColor]];
	if(img == self._emptyImage || img == self._defaultImage)
    {
        [self._imageView setContentMode:self._emptyOrDefaultContentMode];
        self._imageView.backgroundColor = self._defaultColor;
    }
    else
    {
        [self._imageView setContentMode:self._contentMode];
        self._imageView.backgroundColor = [UIColor clearColor];//背景透明
    }
    self._imageView.image = img;
}

-(BOOL)_isLoadingImage
{
    return self._operation != 0;
}
-(void)loadImage:(NSString *)imageUrl
{
    [self loadImage:imageUrl options:SDWebImageLowPriority];
}
-(void)loadImage:(NSString *)imageUrl options:(SDWebImageOptions)options
{
    [self setImage:self._defaultImage];
    NSLog(@"image URL=%@",imageUrl);
    if(!imageUrl)
    {
        return;
    }
    [self jobsBeforeStart];
    self._operation =  [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:options progress:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        if(!self._operation)
        {
            [self jobsAfterDone];
             [self setImage:self._emptyImage];//
        }
        else
        {
            if(image)
            {
                [self setImage:image];
                if(self._delegate) [self._delegate afterImageLoaded:self image:image];
            }
            else
                [self setImage:self._emptyImage];//
        }
    }];
}
-(void)jobsBeforeStart
{
    [self setImage:self._defaultImage];
    [_activityView startAnimating];
}
-(void)jobsAfterDone
{
    [self._activityView stopAnimating];
}

@end
