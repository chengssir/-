//
//  CustomView.m
//  NSView
//
//  Created by 国帅 on 2019/11/29.
//  Copyright © 2019 asi. All rights reserved.
//

#import "CustomView.h"
@interface CustomView()<NSTextFieldDelegate>

@property (nonatomic , assign) CGFloat MaxX;

@end

@implementation CustomView

// 坐标起始位置
//-(BOOL)isFlipped{
//    return YES;
//}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.pionts = [NSMutableArray new];
}

- (void)drawRect:(NSRect)dirtyRect {
   //画点
    [[NSColor redColor] set];
    CGContextRef myContext = [[NSGraphicsContext currentContext] CGContext];
    CGMutablePathRef path = CGPathCreateMutable();
    for (NSValue *value in self.pionts) {
        CGPoint point = NSMakePoint(value.pointValue.x, value.pointValue.y);
        CGContextFillEllipseInRect(myContext, CGRectMake(point.x-4, point.y-4, 8, 8));
        CGPathAddLineToPoint(path, NULL, point.x,point.y);
    }

    for (int i = 0; i < self.linePionts.count; i++) {
        NSValue *value = self.linePionts[i];
        CGPoint point = NSMakePoint(value.pointValue.x, value.pointValue.y);
        if (i == 0) {
            CGPathMoveToPoint(path, NULL, point.x,point.y);
        }else{
            CGPathAddLineToPoint(path, NULL, point.x,point.y);
        }
    }
    
    CGContextAddPath(myContext, path);
    CGContextStrokePath(myContext);
    CGContextSetFillColorWithColor(myContext, [NSColor redColor].CGColor);
    CGContextFillPath(myContext);
    [super drawRect:dirtyRect];
}

-(void)setLinearFunction{
    CGPoint eventLocation = [self leastSquareMethod1:self.pionts];
    self.linePionts = [NSMutableArray new];
    for (int i = 0; i < self.MaxX + 100; i = i + 5) {
        double y = eventLocation.x * i + eventLocation.y;
        NSValue * pobj = [NSValue valueWithPoint:CGPointMake(i, y)];
        [self.linePionts addObject:pobj];
    }
  [self setNeedsDisplay:YES];

}

//1.鼠标按下事件响应方法
-(void)mouseDown:(NSEvent *)theEvent{

    if ([theEvent clickCount] > 1) {
        //双击相关处理
        return;
    }
    NSPoint eventLocation = [theEvent locationInWindow];
    if (self.MaxX < eventLocation.x) {
        self.MaxX = eventLocation.x;
    }
    NSValue * pobj = [NSValue valueWithPoint:eventLocation];
    [self.pionts addObject:pobj];
    if (self.pionts.count > 1) {
        [self setLinearFunction];
    }else{
        [self setNeedsDisplay:YES];
    }
}


-(CGPoint) leastSquareMethod1:(NSArray *)pointArray {
    double SumX = 0;//X总和
    double SumY = 0;//Y总和
    for (NSValue * value in pointArray) {
        SumX += value.pointValue.x;
        SumY += value.pointValue.y;
    }
    
    // x y的平均值
    double SumXAVG = SumX/pointArray.count;
    double SumYAVG = SumY/pointArray.count;

    double topSum = 0;
    double bottomSum = 0;
    for (NSValue * value in pointArray) {
        topSum += (value.pointValue.x - SumXAVG) * (value.pointValue.y - SumYAVG);
        bottomSum += (value.pointValue.x - SumXAVG) * (value.pointValue.x - SumXAVG);
    }
    
    double a = topSum / bottomSum;
    double b = SumYAVG - a * SumXAVG;
    return CGPointMake(a,b);
}

@end



//-(CGPoint) leastSquareMethod:(NSArray *)pointArray
//{
//    double SumX = 0;//X总和
//    double SumY = 0;//Y总和
//    double SumXY = 0;//XY总和
//    double SumX2 = 0;//X平方总和
//    NSInteger arrayCount = pointArray.count;
//    for(int index = 0;index < arrayCount;index++)
//    {
//        NSValue * value = pointArray[index];
//        CGPoint onePoint = value.pointValue;
//        SumX += onePoint.x;
//        SumX2 += onePoint.x * onePoint.x;
//        SumY += onePoint.y;
//        SumXY += onePoint.x * onePoint.y;
//    }
////    double b = (SumX2 * SumY - SumX*SumXY)/(arrayCount*SumX2 - SumX*SumX);
////    double a = (arrayCount*SumXY - SumX*SumY)/(arrayCount*SumX2 - SumX*SumX);
//    double SumXAVG = SumX/arrayCount;
//    double SumYAVG = SumY/arrayCount;
//    double a = (SumXY - arrayCount * SumXAVG * SumYAVG)/ (SumX2 - SumXAVG * SumXAVG * arrayCount);
//    double b = SumYAVG - a * SumXAVG;
//    return CGPointMake(a,b);
//}
