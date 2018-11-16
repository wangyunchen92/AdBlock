//
//  MeasurNetTools.m
//  
//
//  Created by jordan on 16/7/25.
//  Copyright © 2016年 MD313. All rights reserved.
//
#define start1 -0.33
#define urlString @"https://storage.360buyimg.com/jdmobile/JDMALL-PC2.apk"//100M

#import "MeasurNetTools.h"

@interface MeasurNetTools ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>
{
    measureBlock   infoBlock;
    finishMeasureBlock   fmeasureBlock;
    int                           _second;
    int64_t                _connectDataLength;
    int64_t                _oneMinDataLength;
    NSURLConnection *             _connect;
    NSTimer*                      _timer;
}

@property (copy, nonatomic) void (^faildBlock) (NSError *error);
@property (nonatomic, strong)NSURLSessionDownloadTask *task;

@end

@implementation MeasurNetTools

/**
 *  初始化测速方法
 *
 *  @param measureBlock       实时返回测速信息
 *  @param finishMeasureBlock 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock:(measureBlock)measureBlock finishMeasureBlock:(finishMeasureBlock)finishMeasureBlock failedBlock:(void (^) (NSError *error))failedBlock {
    self = [super init];
    if (self) {
        infoBlock = measureBlock;
        fmeasureBlock = finishMeasureBlock;
        _faildBlock = failedBlock;
        _connectDataLength = 0;
        _oneMinDataLength = 0;
    }
    return self;
}

/**
 *  开始测速
 */
-(void)startMeasur {
    [self meausurNet];
}

/**
 *  停止测速，会通过block立即返回测试信息
 */
-(void)stopMeasur {
    [self finishMeasure];
}

-(void)meausurNet {
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeCount target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    NSURL    *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    self.task = [session downloadTaskWithRequest:request];
    
    [_task resume];
//    _connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    [_timer fire];
    _second = 0;

}

-(void)countTime {
    ++_second;
    if (_second == 15/timeCount) {
        [self finishMeasure];
        return;
    }
    float speed = _oneMinDataLength;

    infoBlock(speed);
    
    //清空数据
//    [_oneMinData resetBytesInRange:NSMakeRange(0, _oneMinDatale)];
//    [_oneMinData setLength:0];
    _oneMinDataLength = 0;
}

/**
 * 测速完成
 */
-(void)finishMeasure {
    
    [_timer invalidate];
    _timer = nil;
    if(_second!= 0){
        float finishSpeed = _connectDataLength / _second;
        fmeasureBlock(finishSpeed);
    }
    
    [_connect cancel];
    _connectDataLength = 0;
    _connect = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    _connectDataLength = totalBytesWritten;
    _oneMinDataLength =  _oneMinDataLength + bytesWritten;
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    if (self.faildBlock) {
        self.faildBlock(error);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
     [self finishMeasure];
}

#pragma mark - urlconnect delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.faildBlock) {
        self.faildBlock(error);
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    [_connectData appendData:data];
//    [_oneMinData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [self finishMeasure];
}

- (void)dealloc
{
    if ([_timer isValid]) {
        [self finishMeasure];
    }
}


@end
