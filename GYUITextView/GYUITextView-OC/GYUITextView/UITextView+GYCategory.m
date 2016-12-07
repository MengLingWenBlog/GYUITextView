//
//  UITextView+GYCategory.m
//  GYUITextView
//
//  Created by ZGY on 16/12/3.
//  Copyright © 2016年 giant. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  16/12/3  下午2:52
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

#import "UITextView+GYCategory.h"
#import <objc/runtime.h>

static const void *GYMaxAutoHeight = &GYMaxAutoHeight;
static const void *GYMinAutoHeight = &GYMinAutoHeight;
static const void *GYIsAutoBool  = &GYIsAutoBool;
@implementation UITextView (GYCategory)

@dynamic placeholder;
@dynamic placeholder_color;
@dynamic placeholder_font;
@dynamic isAutoHeight;
@dynamic maxAutoHeight;

- (void)setPlaceholder:(NSString *)placeholder
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeholder;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.frame = CGRectMake(5, 0, self.frame.size.width - 10,self.frame.size.height);
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.contentMode = UIViewContentModeTop;
    //此处无需设置label字体的大小，否则会导致异常
    //placeHolderLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:placeHolderLabel];
    [placeHolderLabel sizeToFit];

    //UITextView有一个叫做“_placeHolderLabel”的私有变量
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    self.scrollsToTop = NO;
    self.scrollEnabled = NO;
    self.showsVerticalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    
}


-(void)setPlaceholder_font:(UIFont *)placeholder_font
{
    UILabel *lb = (UILabel *)[self valueForKey:@"_placeholderLabel"];
    lb.font = placeholder_font;
}

- (void)setPlaceholder_color:(UIColor *)placeholder_color
{
    UILabel *lb = (UILabel *)[self valueForKey:@"_placeholderLabel"];
    lb.textColor = placeholder_color;
}

- (BOOL)isAutoHeight
{
    return [objc_getAssociatedObject(self, GYIsAutoBool) boolValue];
}

- (void)setIsAutoHeight:(BOOL)isAutoHeight
{
    [self setNeedsLayout];
    objc_setAssociatedObject(self,GYIsAutoBool,@(isAutoHeight),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)maxAutoHeight
{
    return [objc_getAssociatedObject(self, GYMaxAutoHeight) floatValue];
}

- (void)setMaxAutoHeight:(CGFloat)maxAutoHeight
{
    objc_setAssociatedObject(self,GYMaxAutoHeight,@(maxAutoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)minAutoHeight
{
    return [objc_getAssociatedObject(self, GYMinAutoHeight) floatValue];
}

- (void)setMinAutoHeight:(CGFloat)minAutoHeight
{
    objc_setAssociatedObject(self,GYMinAutoHeight,@(minAutoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
//    CGRect textFrame = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width-10,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil];
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (height > self.frame.size.height &&  self.maxAutoHeight > height && self.isAutoHeight) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        return;
    }
//    && self.minAutoHeight != 0
    if (height < self.frame.size.height && self.minAutoHeight < height&& self.isAutoHeight ) {
       self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        return;
    }
    
    if (self.maxAutoHeight != 0) {
        return;
    }
    
    if (height > self.frame.size.height && self.isAutoHeight) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        return;
    }
    
    if (self.minAutoHeight != 0) {
        return;
    }
    
    if (height < self.frame.size.height && self.isAutoHeight) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        return;
    }

}


@end
