//
//  YCScannerView.m
//  ios.iGitHub
//
//  Created by yangc on 16/9/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCScannerView.h"

@interface YCScannerView ()

@property (nonatomic, weak) UIImageView *lineImageView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YCScannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        [self addSubview:lineImageView];
        self.lineImageView = lineImageView;
    }
    return self;
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat x = (self.frame.size.width - kScannerSize.width) * 0.5;
    CGFloat y = (self.frame.size.height - kScannerSize.height) * 0.5;
    self.lineImageView.frame = CGRectMake(x, y, kScannerSize.width, 2);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(ctx, 40 / 255.0, 40 / 255.0, 40 / 255.0, 0.6);
    CGContextFillRect(ctx, rect);

    CGRect scannerRect = CGRectMake((rect.size.width - kScannerSize.width) * 0.5, (rect.size.height - kScannerSize.height) * 0.5, kScannerSize.width, kScannerSize.height);
    CGContextClearRect(ctx, scannerRect);

    CGContextSetRGBStrokeColor(ctx, 255 / 255.0, 255 / 255.0, 255 / 255.0, 1.0);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextAddRect(ctx, scannerRect);
    CGContextStrokePath(ctx);

    [self drawCornerWithContext:ctx scannerRect:scannerRect];
}

- (void)drawCornerWithContext:(CGContextRef)ctx scannerRect:(CGRect)scannerRect {
    CGFloat cornerWidth = 4.0;
    CGFloat cornerLength = 16.0;

    CGContextSetLineWidth(ctx, cornerWidth);
    CGContextSetRGBStrokeColor(ctx, 83 / 255.0, 239 / 255.0, 111 / 255.0, 1.0);

    //左上角
    CGPoint pointATopLeft[] = {CGPointMake(scannerRect.origin.x + cornerWidth * 0.5, scannerRect.origin.y), CGPointMake(scannerRect.origin.x + cornerWidth * 0.5, scannerRect.origin.y + cornerLength)};
    CGPoint pointBTopLeft[] = {CGPointMake(scannerRect.origin.x, scannerRect.origin.y + cornerWidth * 0.5), CGPointMake(scannerRect.origin.x + cornerLength, scannerRect.origin.y + cornerWidth * 0.5)};
    [self drawLineWithContext:ctx pointA:pointATopLeft pointB:pointBTopLeft];

    //左下角
    CGPoint pointABottomLeft[] = {CGPointMake(scannerRect.origin.x + cornerWidth * 0.5, CGRectGetMaxY(scannerRect) - cornerLength),
                                  CGPointMake(scannerRect.origin.x + cornerWidth * 0.5, CGRectGetMaxY(scannerRect))};
    CGPoint pointBBottomLeft[] = {CGPointMake(scannerRect.origin.x, CGRectGetMaxY(scannerRect) - cornerWidth * 0.5),
                                  CGPointMake(scannerRect.origin.x + cornerLength, CGRectGetMaxY(scannerRect) - cornerWidth * 0.5)};
    [self drawLineWithContext:ctx pointA:pointABottomLeft pointB:pointBBottomLeft];

    //右上角
    CGPoint pointATopRight[] = {CGPointMake(CGRectGetMaxX(scannerRect) - cornerLength, scannerRect.origin.y + cornerWidth * 0.5),
                                CGPointMake(CGRectGetMaxX(scannerRect), scannerRect.origin.y + cornerWidth * 0.5)};
    CGPoint pointBTopRight[] = {CGPointMake(CGRectGetMaxX(scannerRect) - cornerWidth * 0.5, scannerRect.origin.y),
                                CGPointMake(CGRectGetMaxX(scannerRect) - cornerWidth * 0.5, scannerRect.origin.y + cornerLength)};
    [self drawLineWithContext:ctx pointA:pointATopRight pointB:pointBTopRight];

    //右下角
    CGPoint pointABottomRight[] = {CGPointMake(CGRectGetMaxX(scannerRect) - cornerWidth * 0.5, CGRectGetMaxY(scannerRect) - cornerLength),
                                   CGPointMake(CGRectGetMaxX(scannerRect) - cornerWidth * 0.5, CGRectGetMaxY(scannerRect))};
    CGPoint pointBBottomRight[] = {CGPointMake(CGRectGetMaxX(scannerRect) - cornerLength, CGRectGetMaxY(scannerRect) - cornerWidth * 0.5),
                                   CGPointMake(CGRectGetMaxX(scannerRect), CGRectGetMaxY(scannerRect) - cornerWidth * 0.5)};
    [self drawLineWithContext:ctx pointA:pointABottomRight pointB:pointBBottomRight];

    CGContextStrokePath(ctx);
}

- (void)drawLineWithContext:(CGContextRef)ctx pointA:(CGPoint[])pointA pointB:(CGPoint[])pointB {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

- (void)playAnimation {
    [UIView animateWithDuration:2.4
        animations:^{
            CGFloat x = (self.frame.size.width - kScannerSize.width) * 0.5;
            CGFloat y = (self.frame.size.height + kScannerSize.height) * 0.5 - 2;
            self.lineImageView.frame = CGRectMake(x, y, kScannerSize.width, 2);
        }
        completion:^(BOOL finished) {
            if (finished) {
                CGFloat x = (self.frame.size.width - kScannerSize.width) * 0.5;
                CGFloat y = (self.frame.size.height - kScannerSize.height) * 0.5;
                self.lineImageView.frame = CGRectMake(x, y, kScannerSize.width, 2);
            }
        }];
}

- (void)startAnimation {
    if (self.timer == nil) {
        [self playAnimation];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(playAnimation) userInfo:nil repeats:YES];
    }
}

- (void)stopAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
