//
//  ViewController.m
//  NetworkRequest
//
//  Created by mob on 2019/1/29.
//  Copyright © 2019年 mob. All rights reserved.
//https://blog.csdn.net/ch_quan/article/details/54943652:NSURLSession学习

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSURLConnectionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@property(nonatomic, strong) NSURL *imageUrl;
@property(nonatomic, strong) NSFileHandle *fileHandle;


@end
long int currentLength = 0;
long int fileLength = 0;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_urlImageView setBackgroundColor:[UIColor redColor]];
    NSURL *imageUrl = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
    self.imageUrl = imageUrl;
}
- (IBAction)onClickNSData:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *imageUrl = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:_imageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_urlImageView.image = [UIImage imageWithData:imageData];
        });
    });
}

- (IBAction)onClickNSURLConnection:(id)sender {
    // block 回调的方式
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:_imageUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        self->_urlImageView.image = [UIImage imageWithData:data];
//    }];
// 代理的方式
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:_imageUrl] delegate:self];
    
}

- (IBAction)onClickNSURLSession:(id)sender {
    
    
/******** get 请求
    //创建一个请求
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:_imageUrl];
    [mutableURLRequest setHTTPMethod:@"GET"];
    [mutableURLRequest setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    [mutableURLRequest setTimeoutInterval:10.0];
    [mutableURLRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    创建一个对话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    configuration.timeoutIntervalForRequest = 10.0;
    configuration.allowsCellularAccess = NO;
//    创建一个任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mutableURLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"get error  is  %@",error);
        }
        else{
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"object is  %@",object);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_urlImageView.image = [UIImage imageWithData:data];
            });
        }
    }];
    [dataTask resume];
    
    *******/
    
/********** potst请求 ***********
    NSURL *stringurl = [NSURL URLWithString:@"http://api.nohttp.net/postBody"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:stringurl];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:10.0];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Content0Encoding"];
    NSDictionary *dictionary = @{@"name":@"yanzhejie",@"pwd":@"123"};
    NSMutableString *mutableString = [[NSMutableString alloc] initWithCapacity:1];
    int pos  = 0;
    for (NSString *key in dictionary.allKeys) {
        [mutableString appendString:[NSString stringWithFormat:@"%@=%@",key,dictionary[key]]];
        if (pos < dictionary.allKeys.count-1) {
            [mutableString stringByAppendingString:@"&"];
        }
         pos++;
    }
    NSData *patametersData = [mutableString dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:patametersData];
//    设置请求报文
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"get error  is  %@",error);
        }
        else{
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"object is  %@",object);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_urlImageView.image = [UIImage imageWithData:data];
            });
        }
    }];
    [task resume];
    
    **********/
    
    /*************文件下载 **********/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_imageUrl];
    [request setTimeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed error is %@",error);
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:location];
                self->_urlImageView.image = [UIImage imageWithData:imageData];
            });
        }
    }];
    [downloadTask resume];
    
}


#pragma mark ------ NSURLConnect 代理
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection fail with error is  %@",error);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    fileLength = response.expectedContentLength;
//    NSString *pathStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    [[NSFileManager defaultManager] createFileAtPath:pathStr contents:nil attributes:nil];
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:pathStr];
//    self.fileHandle = fileHandle;
//    NSLog(@"pathStr is  %@",pathStr);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *pathStr = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/hahah"];
    [[NSFileManager defaultManager] createFileAtPath:pathStr contents:data attributes:nil];
//    [self.fileHandle seekToEndOfFile];
//    [self.fileHandle writeData:data];
    currentLength += data.length;
//    NSProgress *progressImage = [NSProgress pro]
    _urlImageView.image = [UIImage imageWithData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    [_fileHandle closeFile];
//    _fileHandle = nil;
//    currentLength = 0;
//    fileLength = 0;
}

@end
