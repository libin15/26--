//
//  ViewController.m
//  条形码demo
//
//  Created by hdf on 15/6/16.
//  Copyright (c) 2015年 hdf. All rights reserved.
//

#import "MedicationDirayBarCodeViewController.h"
#import "MedicationDirayscanBarCodeController.h"
#import "MedicationDirayScanBarCodeSubView.h"
#import "ThreedZbarViewcontroller.h"

#import "ZBarSDK.h"
#import "ZBarReaderController.h"

#define LABLEWITH 300

#import  <AVFoundation/AVFoundation.h>

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface MedicationDirayBarCodeViewController ()
<
AVCaptureMetadataOutputObjectsDelegate,
ZBarReaderDelegate,ZBarReaderViewDelegate>

@property(nonatomic, strong)UIImageView *iconView;
@property(nonatomic, strong)UIButton    *button;
@property(nonatomic, strong)UILabel      *context;
@property(nonatomic, strong) MedicationDirayScanBarCodeSubView *subView;

@end

#define WIDTH   self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height
#define ICONWANDH  200


@implementation MedicationDirayBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSubViews];
    
}

-(void)addSubViews{

    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-ICONWANDH)/2, 150, ICONWANDH, ICONWANDH)];
    self.iconView.image = [UIImage imageNamed:@"123"];
    [self.view addSubview:self.iconView];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(self.iconView.frame.origin.x+50, CGRectGetMaxY(self.iconView.frame)+20, 100, 50);
    [self.button setTitle:@"扫描条形码" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.button setBackgroundColor:[UIColor cyanColor]];
    [self.button addTarget:self action:@selector(jumpOtherController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    
    self.context = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.button.frame)+20, self.view.frame.size.width-20*2, 50)];
    self.context.text = @"条形码";
    self.context.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:self.context];
    
}


-(void)jumpOtherController{

    if ([self validateCamera]) {
        
   
        ThreedZbarViewcontroller *thread = [[ThreedZbarViewcontroller alloc]init];
        [self.navigationController pushViewController:thread animated:YES];
        
        
        
    }else{
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    
    }

}


-(void)jumpZBarView{

   ZBarReaderViewController *readerView = [[ZBarReaderViewController alloc]init];
//    readerView.readerDelegate = self;
    readerView.showsHelpOnFail=NO;
    readerView.title = @"我是ZBarSDK";
    
    readerView.supportedOrientationsMask = ZBarOrientationMaskAll;//支持界面旋转
    readerView.showsZBarControls = NO;
    
    readerView.cameraMode = ZBarReaderControllerCameraModeSampling;
    readerView.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应界面
    
    ZBarImageScanner *scanner = readerView.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    
   MedicationDirayScanBarCodeSubView *subView = [[MedicationDirayScanBarCodeSubView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width,  screenRect.size.height)];
    subView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.6];
    subView.transparentArea = CGSizeMake(220, 300);
    subView.readView.readerDelegate = self;
    readerView.cameraOverlayView = subView;
    [subView.readView start];


    self.subView = subView;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((screenRect.size.width - LABLEWITH)/2, 60, LABLEWITH, 80)];
    title.text = @"请将你的摄像头对准要扫的二维码";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:20];
    subView.title = title;
    [subView addSubview:title];
    
    [self.navigationController pushViewController:readerView animated:YES];

}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    
    [_subView.timer invalidate];
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //初始化
    ZBarReaderController * read = [ZBarReaderController new];
    //设置代理
    read.readerDelegate = self;
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol * symbol = nil;
    id <NSFastEnumeration> results = [read scanImage:cgImageRef];
    //id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    for (symbol in results)
    {
        break;
    }
    NSString * result;
    if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
        
    {
        result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    else
    {
        result = symbol.data;
    }
    
    NSLog(@"result = %@ ",result);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    self.context.text = result;
    
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




-(BOOL)validateCamera{
    
    return[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


@end
