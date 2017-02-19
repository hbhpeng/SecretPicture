//
//  LoadingIndicator.m
//  CloudBook
//
//  Created by fuacici on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoadingIndicator.h"

@interface LoadingIndicator(PrivateMethods)

- (void)initSubviewsInRect:(CGRect ) rect;

@end


@implementation LoadingIndicator
@synthesize instructions;
@synthesize indicator;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self initSubviewsInRect: frame];
        self.mode = LoadingIndicatorModeIndeterminate;
    }
    return self;
}
- (void)awakeFromNib
{
	[super awakeFromNib];
	[self initSubviewsInRect: self.bounds];
}
- (void)initSubviewsInRect:(CGRect ) rect
{
	self.hidden = YES;
    self.backgroundColor = [UIColor clearColor]; //UIColorFromRGB(0xf7f7f7);
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	indicator.center = CGPointMake(self.bounds.size.width/2 - 30,  self.bounds.size.height/2 + self.loadingOffsetY);
    instructions.frame = CGRectMake(0, 0, 180, 50);
    instructions.center = CGPointMake(self.bounds.size.width/2 + 25,self.bounds.size.height/2 + self.loadingOffsetY);
    instructions = [[UILabel alloc]initWithFrame: CGRectMake(140, rect.size.height/2-25+ self.loadingOffsetY, 180, 50)];
    instructions.text = self.loadingText;
	instructions.textColor = [UIColor grayColor];
    instructions.textAlignment = NSTextAlignmentCenter;
	instructions.backgroundColor = [UIColor clearColor];
    instructions.numberOfLines = 0;
	instructions.font = [UIFont systemFontOfSize: 15];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = self.bounds;
    
	[self addSubview: instructions];
	[self addSubview: indicator];
    [self addSubview:_actionButton];
    
    self.mode = LoadingIndicatorModeIndeterminate;
    self.hidden = YES;
	
}

-(void)layoutSubviews{

    //self.center = self.superview.center;
    //NSLog(@"center is %f",self.center.y);
    [self updateIndicators];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.loadingText = nil;
    self.actionText = nil;
}
#pragma mark  -
-(void)setMode:(LoadingIndicatorMode)mode{
    
    if (_mode &&_mode == mode) {
        return;
    }
    _mode = mode;
    
    [self updateIndicators];
}
-(NSString*)loadingText{

    if (_loadingText == nil) {
        _loadingText = @"加载中...";
    }
    
    return _loadingText;
}
-(NSString*)actionText{

    if (_actionText == nil) {
        _actionText =  @"网络加载失败\r\n点击屏幕重新载入";
    }
    
    return _actionText;
}
#pragma mark custom methods
- (void)addActionTarget:(id)target action:(SEL)sel{

    [_actionButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)showLoading
{
	if (self.hidden)
	{
		self.hidden = NO;
	}
	
    [self.superview bringSubviewToFront: self];
    
    if (self.mode == LoadingIndicatorModeIndeterminate) {
        [indicator startAnimating];
    }else if(self.mode == LoadingIndicatorModeAction){
        _actionButton.hidden = NO;
    }else if(self.mode == LoadingIndicatorModeIndicator){
        [indicator   startAnimating];
    }
    
}
- (void)hideLoading
{
    if (self.mode == LoadingIndicatorModeIndeterminate) {
        [indicator stopAnimating];
    }
	
    self.hidden = YES;

}
- (BOOL) isAnimating
{
	return indicator.isAnimating;
}

-(void)updateIndicators{

    if (self.mode == LoadingIndicatorModeIndeterminate) {
        indicator.hidden = NO;
         indicator.center = CGPointMake(self.bounds.size.width/2 - 30,  self.bounds.size.height/2 + self.loadingOffsetY);
        _actionButton.hidden = YES;
        instructions.center = CGPointMake(self.bounds.size.width/2 + 25,self.bounds.size.height/2 + self.loadingOffsetY);
        instructions.text = self.loadingText;
    } if(self.mode == LoadingIndicatorModeAction){
        instructions.text = self.actionText;
        instructions.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2+self.loadingOffsetY);
        indicator.hidden = YES;
        _actionButton.hidden = NO;
    }else if(self.mode == LoadingIndicatorModeIndicator){
    
        instructions.hidden = YES;
        _actionButton.hidden = YES;
        indicator.hidden = NO;
        indicator.center = CGPointMake(self.bounds.size.width/2,  self.bounds.size.height/2+self.loadingOffsetY);
    }
}

@end
