//
//  MedicationDirayscanBarCodeController.h
//  条形码demo
//
//  Created by hdf on 15/6/16.
//  Copyright (c) 2015年 hdf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HDFblock)(NSString *url);

@interface MedicationDirayscanBarCodeController : UIViewController

@property(nonatomic ,copy) HDFblock block;

@end
