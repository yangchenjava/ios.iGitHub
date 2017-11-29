//
//  YCScannerViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/9/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <YCHelpKit/SVModalWebViewController.h>
#import <YCHelpKit/UIAlertController+Category.h>

#import "YCScannerView.h"
#import "YCScannerViewController.h"

@interface YCScannerViewController () <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, weak) YCScannerView *scannerView;

@end

@implementation YCScannerViewController

+ (BOOL)isAvailable {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        NSError *error;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (input && !error) {
            return YES;
        }
    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScanner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scannerView startAnimation];
}

- (void)dealloc {
    [self.captureSession stopRunning];
    [self.scannerView stopAnimation];
    YCLog(@"dealloc - YCScanViewController");
}

- (AVCaptureSession *)captureSession {
    if (_captureSession == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // 原点在右上角
        output.rectOfInterest = CGRectMake((YC_ScreenHeight - kScannerSize.height) * 0.5 / YC_ScreenHeight, (YC_ScreenWidth - kScannerSize.width) * 0.5 / YC_ScreenWidth, kScannerSize.height / YC_ScreenHeight, kScannerSize.width / YC_ScreenWidth);

        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        [_captureSession addInput:input];
        [_captureSession addOutput:output];

        // 必须在添加到session之后设置
        output.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode128Code ];
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer {
    if (_captureVideoPreviewLayer == nil) {
        _captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _captureVideoPreviewLayer;
}

- (void)setupScanner {
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.captureVideoPreviewLayer atIndex:0];
    [self.captureSession startRunning];

    YCScannerView *scannerView = [[YCScannerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scannerView];
    self.scannerView = scannerView;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(scanQRCodeFromPhoto)];
}

- (void)scanQRCodeFromPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备不支持访问相册，请在设置->隐私->照片中进行设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count) {
        [self.captureSession stopRunning];
        [self.scannerView stopAnimation];

        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.lastObject;
        YCLog(@"%@", metadataObject.stringValue);
        [self showMessage:metadataObject.stringValue];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];

    [picker dismissViewControllerAnimated:YES completion:^{
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count) {
            [self.captureSession stopRunning];
            [self.scannerView stopAnimation];
            
            CIQRCodeFeature *feature = features.lastObject;
            YCLog(@"%@", feature.messageString);
            [self showMessage:feature.messageString];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该图片不包含二维码" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)showMessage:(NSString *)message {
    [self.navigationController popViewControllerAnimated:YES];
    
    UIViewController *vc;
    if ([message hasPrefix:@"http"]) {
        vc = [[SVModalWebViewController alloc] initWithURL:[NSURL URLWithString:message]];
    } else {
        vc = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert alertActions:nil];
    }
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

@end
