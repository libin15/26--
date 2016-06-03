//
//  ThreedZbarViewcontroller.m
//  条形码demo
//
//  Created by hdf on 15/7/16.
//  Copyright (c) 2015年 hdf. All rights reserved.
//

#import "ThreedZbarViewcontroller.h"
#import "zbar.h"
#import "ZBarReaderView.h"
#import "MedicationDirayScanBarCodeSubView.h"

@interface ThreedZbarViewcontroller ()<ZBarReaderViewDelegate>

@property (nonatomic,strong)  ZBarReaderView * readView;
@end

@implementation ThreedZbarViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _readView  = [ZBarReaderView new];
    _readView.frame = self.view.frame;
    _readView.allowsPinchZoom = NO;
    _readView.readerDelegate = self;
    [_readView start];
    [self.view addSubview:_readView];
    
    MedicationDirayScanBarCodeSubView*scanView = [[MedicationDirayScanBarCodeSubView alloc]initWithFrame:self.view.frame];
    scanView.transparentArea = CGSizeMake(300, 300);
    scanView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.6];
    scanView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [_readView addSubview:scanView];
    
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidht = self.view.frame.size.width;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((screenWidht - 300)/2, 70, 300, 80)];
    title.text = @"请将你的摄像头对准要扫的二维码";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:20];
    scanView.title = title;
    [scanView addSubview:title];
    
    
    //修正扫描的区域
//    
//    CGRect cropRect = CGRectMake((screenWidht - scanView.transparentArea.width) / 2,
//                                 (screenHeight - scanView.transparentArea.height) / 2,
//                                 scanView.transparentArea.width,
//                                 scanView.transparentArea.height);
//    
//    CGRect scpent = CGRectMake(cropRect.origin.y / screenHeight,
//                                  cropRect.origin.x / screenWidht,
//                                  cropRect.size.height / screenHeight,
//                                  cropRect.size.width / screenWidht);
//    _readView.scanCrop = scpent;
    


    
    

    
    UIButton * button  = [[UIButton alloc]initWithFrame:CGRectMake(100, 320, 40, 40)];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{

  const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
    
    
    
    
    }else{
    
        NSLog(@"%@", symbolStr);
        [readerView stop];
    
    }



}

-(void)start{

    [_readView start];

}
@end
