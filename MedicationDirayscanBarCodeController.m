//
//  HDFscanBarCodeController.m
//  条形码demo
//
//  Created by hdf on 15/6/16.
//  Copyright (c) 2015年 hdf. All rights reserved.
//

#import "MedicationDirayscanBarCodeController.h"
#import "MedicationDirayScanBarCodeSubView.h"

#import <AVFoundation/AVFoundation.h>

#define LABLEWITH 300

@interface MedicationDirayscanBarCodeController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic)AVCaptureDevice *device;//主要用来获取iphone一些关于相机设备的属性
@property (strong, nonatomic)AVCaptureDeviceInput *input;//这里代表输入设备
@property (strong, nonatomic)AVCaptureMetadataOutput *output;//它代表输出数据管理着输出到一个movie或者图像。
@property (strong, nonatomic)AVCaptureSession *session;//它是input和output的桥梁。它协调着intput到output的数据传输。
@property (strong ,nonatomic)AVCaptureVideoPreviewLayer *preview;//是 CALayer 的子类，可被用于自动显示相机产生的实时图像。

@end




@implementation MedicationDirayscanBarCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self initWithAVFoundation];//初始化AVFoundation
    
}


-(void)initWithAVFoundation{

 
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }

    
    if ([_output.availableMetadataObjectTypes containsObject:
         AVMetadataObjectTypeQRCode]||[_output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code])
    {
            _output.metadataObjectTypes =[NSArray arrayWithObjects:
                                          AVMetadataObjectTypeQRCode,
                                          AVMetadataObjectTypeCode39Code,
                                          AVMetadataObjectTypeCode128Code,
                                          AVMetadataObjectTypeCode39Mod43Code, 
                                          AVMetadataObjectTypeEAN13Code, 
                                          AVMetadataObjectTypeEAN8Code, 
                                          AVMetadataObjectTypeCode93Code, nil]; 
    }
    
//算是相机的视图吧 但是不是View
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    
    [_session startRunning];
    
    [self addBackGroundView];
    

}

-(void)addBackGroundView{


    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    MedicationDirayScanBarCodeSubView*scanView = [[MedicationDirayScanBarCodeSubView alloc]initWithFrame:screenRect];
    scanView.transparentArea = CGSizeMake(300, 300);
    scanView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.6];
    scanView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:scanView];
    
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidht = self.view.frame.size.width;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((screenWidht - LABLEWITH)/2, 70, LABLEWITH, 80)];
    title.text = @"请将你的摄像头对准要扫的二维码";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:20];
    scanView.title = title;
    [scanView addSubview:title];
    
    
    //修正扫描的区域
    
    CGRect cropRect = CGRectMake((screenWidht - scanView.transparentArea.width) / 2,
                                 (screenHeight - scanView.transparentArea.height) / 2,
                                 scanView.transparentArea.width,
                                 scanView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidht,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidht)];
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{


    NSString *stringValue;

    if ([metadataObjects count] >0) {
    
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject=[metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }else{
      
       stringValue = @"条形码错误";
    }

    
    if (self.block) {
        
        self.block(stringValue);
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


@end
