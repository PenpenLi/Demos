//
//  DecryptViewController.m
//  Decrypt
//
//  Created by Xiaobin Li on 6/10/15.
//  Copyright (c) 2015 Xiaobin Li. All rights reserved.
//

#import "DecryptViewController.h"
#include <dlfcn.h>

@interface DecryptViewController ()

- (void)startDecrypt;

@end

@implementation DecryptViewController {
    
    __weak IBOutlet UIImageView *_imgTest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startDecrypt];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startDecrypt {
    NSString *path = _appInfo[@"path"];
    NSString *exe = _appInfo[@"exe"];
    NSString *full = [[NSBundle mainBundle] pathForResource:exe ofType:nil inDirectory:path];
    path = [full stringByDeletingLastPathComponent];
    NSLog(@"exe full path: %@", full);
    NSLog(@"%@ path: %@", _appInfo[@"name"], path);
    if (!full || [@"" isEqualToString:full]) return;
    
    void *handle = dlopen(full.UTF8String, RTLD_LAZY);
    if (!handle) {
        NSLog(@"dlopen error: %@", @(dlerror()));
        return;
    }
    unsigned char *exe_header = dlsym(handle, "_mh_execute_header");
    if (!exe_header) {
        NSLog(@"exe_header is NULL, error: %@", @(dlerror()));
        dlclose(handle);
        return;
    }
    
    __unused const void* (*dec_data)(const void*, int, int*, int*) = (const void* (*)(const void*, int, int*, int*))(exe_header + 0x52d948 - 0x4000 + 1);
//    __unused const void* (*dec_data_real)(int, const void*, int, int*, int*, int) = (const void* (*)(int, const void*, int, int*, int*, int))(exe_header + 0x52d8cc - 0x4000 + 1);
//    __unused int (*dec_real_size)(const void*, int, int*, int*, int) = (int (*)(const void*, int, int*/*, int*, int*/))(exe_header + 0x52d994 - 0x4000 + 1);
//    __unused const void* (*dec_real_buf)(const void*, int, void*) = (const void* (*)(const void*, int, void*))(exe_header + 0x52d834 - 0x4000 + 1);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSFileManager *fm = [NSFileManager defaultManager];
//            NSDirectoryEnumerator *it = [fm enumeratorAtPath:path];
//            NSString *file;
//            while ((file = [it nextObject])) {
//                if ([[file pathExtension] isEqualToString:@"png"]) {
//                    NSLog(@"%@", file);
//                }
//            }
            
            NSString *outDir = [NSTemporaryDirectory() stringByAppendingPathComponent:_appInfo[@"name"]];
            if (![fm fileExistsAtPath:outDir isDirectory:NULL])
            {
                [fm createDirectoryAtPath:outDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            for (NSString *file in [fm contentsOfDirectoryAtPath:path error:nil])
            {
                @autoreleasepool {
                    NSString *outFile = [outDir stringByAppendingPathComponent:file];
                    NSString *full = [path stringByAppendingPathComponent:file];
                    if ([[full pathExtension] isEqualToString:@"png"]) {
                        NSLog(@"%@", full);
                        
                        NSData *enc_data = [NSData dataWithContentsOfFile:full];
                        
//                        char buf[0x144] = { 0 };
                        int width = 0, height = 0;
//                        const void* data = NULL;
                        const void* data = dec_data(enc_data.bytes, enc_data.length, &width, &height);
//                        if (0 == dec_real_size(enc_data.bytes, enc_data.length, &width, &height, 1))
//                        {
//                            NSLog(@"dec_real_size: width=%i, height=%i", width, height);
//                            data = dec_real_buf(enc_data.bytes, enc_data.length, buf);
//                        }
//                        data = dec_data_real(1, enc_data.bytes, enc_data.length, &width, &height, 0);
                        NSLog(@"dec_data return: %p", data);
                        
                        UIImage *img = nil;
                        if (data) {
                            //                        NSData *decData = [NSData dataWithBytes:data length:width*height*4];
                            NSLog(@"dec_data: width=%i, height=%i", width, height);
                            
                            CGDataProviderRef dataRef = CGDataProviderCreateWithData(0, data, width*height*4, 0);
//                            NSData *dataDec = [NSData dataWithBytes:data length:enc_data.length];
//                            [dataDec writeToFile:outFile atomically:YES];
                            
//                            CFDataRef decDataRef = CGDataProviderCopyData(dataRef);
//                            [(__bridge NSData*)decDataRef writeToFile:outFile atomically:YES];
//                            CFRelease(decDataRef);
                            CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
                            CGImageRef imgRef = CGImageCreate(width, height, 8, 32, width*4, colorRef, 3, dataRef, 0, 0, 0);
//                            CGImageRef imgRef = CGImageCreateWithPNGDataProvider(dataRef, NULL, false, kCGRenderingIntentDefault);
                            CFRelease(dataRef);
                            CFRelease(colorRef);
                            img = [UIImage imageWithCGImage:imgRef];
                            CFRelease(imgRef);
//                            [UIImagePNGRepresentation(img) writeToFile:outFile atomically:YES];
                        }
                        else {
                            img = [UIImage imageWithData:enc_data];
                            [enc_data writeToFile:outFile atomically:YES];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _imgTest.image = img;
                        });
                    }
                }
            }
            NSLog(@"!!!!!!!!!! Finished !!!!!!!!");
        }
    });
}

@end
