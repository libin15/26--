//
//  HDFScanBarCodeSubView.m
//  条形码demo
//
//  Created by hdf on 15/6/17.
//  Copyright (c) 2015年 hdf. All rights reserved.
//

#import "MedicationDirayScanBarCodeSubView.h"


#define LINESPACC 5

static NSTimeInterval HDFLinerimateDuration = 0.02;

@implementation MedicationDirayScanBarCodeSubView
{
    UIImageView *line;
    CGFloat lineY;
    
    BOOL upOrdown;
    int  num;
}


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {


        num = 1;
        upOrdown = NO;
    }

    return self;

}


-(void)layoutSubviews{ //重新加载子视图

    [super layoutSubviews];
    
    if (!line) {
        
        [self initLine];
        
        //加入时间方法
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:HDFLinerimateDuration  target:self selector:@selector(showLine) userInfo:nil repeats:YES];
        
        _timer = timer;
        [timer fire];
        
    }
}


-(void)initLine{ //初始化线条

    line = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2 - self.transparentArea.width / 2, CGRectGetMaxY(self.title.frame), self.transparentArea.width, 2)];
    line.image = [UIImage imageNamed:@"qr_scan_line"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:line];
    
    lineY = line.frame.origin.y;
}


-(void)showLine{ //线条上下滚动

    if (upOrdown == NO) {
        num ++;
        line.frame = CGRectMake(50, lineY+LINESPACC+2*num, 220, 2);
        if (2*num == self.transparentArea.height-4*LINESPACC) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        line.frame = CGRectMake(50,  lineY+LINESPACC+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }

}


-(void)drawRect:(CGRect)rect{

    CGSize screenSize = [UIScreen mainScreen].bounds.size; //整个视图
    CGRect screenDrawRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    //中间清空的按钮
    
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width/2 -self.transparentArea.width/2, CGRectGetMaxY(self.title.frame)+20, self.transparentArea.width, self.transparentArea.height);
    
    _readView.frame = clearDrawRect;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [self addScreenFillRect:ctx rect:screenDrawRect];//整体的视图
    
    [self addCenterClearRect:ctx rect:clearDrawRect]; //中间的透明视图
    
    [self addWithRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];

}


-(void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect{

    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);
}


-(void)addCenterClearRect:(CGContextRef)ctx rect:(CGRect)rect{

    
    CGContextClearRect(ctx, rect);

}

-(void)addWithRect:(CGContextRef)ctx rect:(CGRect)rect{

    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);

}

//四个角

-(void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{

    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}


@end
