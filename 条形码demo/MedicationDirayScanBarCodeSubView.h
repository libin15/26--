//
//  MedicationDirayScanBarCodeSubView.h
//  条形码demo
//
//  Created by hdf on 15/6/17.
//  Copyright (c) 2015年 hdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderView.h"

@interface MedicationDirayScanBarCodeSubView : UIView 
/**
 设置透明的区域范围
 */
@property (nonatomic, assign) CGSize transparentArea;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ZBarReaderView *readView;

@end
