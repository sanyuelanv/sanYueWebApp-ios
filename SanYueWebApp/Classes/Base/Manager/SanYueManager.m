//
//  SanYueManager.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import "SanYueManager.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"
#import "SanYueCacheItem.h"
#import "NSString+SanYueExtension.h"

typedef void(^haoDanDownProgressBlock)(SanyueLoadStatus type,CGFloat progress);
typedef void(^haoDanDownSuccessHandler)(NSString* url,NSString *date);
typedef void(^haoDanDownErrorHandler)(NSError* error);

@interface SanYueManager()
@property(nonatomic,weak)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *version;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,assign)BOOL needLoad;
@property(nonatomic,assign)BOOL hasLoad;
@property(nonatomic,strong)NSString *pathName;
@property(nonatomic,strong)haoDanDownProgressBlock progressBlock;
@property(nonatomic,strong)haoDanDownSuccessHandler successHandler;
@property(nonatomic,strong)haoDanDownErrorHandler errorHandler;
@end
static NSString* const NAME = @"sanyueWeb";
@implementation SanYueManager
-(instancetype)initWith:(NSString *)url{
    self = [super init];
    _url = url;
    return self;
}
-(void)start:(nullable void (^)(SanyueLoadStatus type,CGFloat progress))ProgressBlock successHandler:(nullable void (^)(NSString * _Nullable url,NSString *date))successHandler errorHandler:(nullable void (^)(NSError * _Nullable error))errorHandler{
    _progressBlock = ProgressBlock;
    _successHandler = successHandler;
    _errorHandler = errorHandler;
    [self checkNeedLoad];
}
-(void)checkNeedLoad{
    NSString *version = @"";
    NSArray *urlArr = [_url componentsSeparatedByString:@"?"];
    if(urlArr.count > 1){ version = urlArr[1]; }
    _version = version;
    NSString *name = [NSString stringWithFormat:@"%lu",(unsigned long)[urlArr[0] hash]];;
    // 判断沙盒中 sanyueWeb 文件夹是否存在
    NSString *cachePath = [NSString getCachePath];
    NSString *pathName = [NSString stringWithFormat:@"%@/%@",NAME,name];
    NSString *webPathName = [NSString stringWithFormat:@"%@/%@",cachePath,pathName];
    //NSLog(@"%@",webPathName);
    _name = webPathName;
    NSString *webCachePathName = [NSString stringWithFormat:@"%@/%@",pathName,@"cache.plist"];
    [NAME createDirIfNotExistsInCache];
    BOOL needLoad = NO;
    BOOL hasPath = [pathName DirIsExists:YES];
    BOOL hasCache = [webCachePathName FileIsExists:YES];
    if (_mustLoad) {
        needLoad = YES;
    }
    else{
        if(hasPath){
            if(hasCache){
                NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",cachePath,webCachePathName]]];
                SanYueCacheItem *item = [[SanYueCacheItem alloc] initWithDict:dict];
                _date = item.date;
                // ? 后参数不一致，删除原来的，重新下载，
                if(![item.cache isEqualToString:version]) {
                    _pathName = pathName;
                    _hasLoad = YES;
                    needLoad = YES;
                }
            }
            else{ needLoad = YES; }
        }
        else{ needLoad = YES; }
    }
    // 如果有文件夹，而且内部有文件，则直接打开
    // 否则就下载 - 解压 - 打开
    _needLoad = needLoad;
    if (_needLoad) {
        //NSLog(@"1---下载");
        [pathName createDirIfNotExistsInCache];
        [self downLoadZip];
    }
    else{
        //NSLog(@"1---直接打开开");
        _successHandler(_name,_date);
    }
    
}
-(void)downLoadZip{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //[_name createDirIfNotExistsInCache];
    NSString *zipPath = [NSString stringWithFormat:@"%@/app.zip",_name];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    __weak typeof(self) weakSelf = self;
    request.timeoutInterval = self.timeoutInterval;
    NSURLSessionDownloadTask *downLoadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        weakSelf.progressBlock(0,downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:zipPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            //weakSelf.errorHandler(error);
            [weakSelf loadError:error];
        }
        else{
            [weakSelf unZip:zipPath];
        }
    }];
    [downLoadTask resume];
}
-(void)unZip:(NSString *)zipPath{
    __weak typeof(self) weakSelf = self;
    if (_hasLoad) {
        [_pathName delIfExists];
    }
    // 开新线程来解压，太大的解压包会导致系统卡停太久认为程序死掉了
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [SSZipArchive unzipFileAtPath:zipPath toDestination:weakSelf.name progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            weakSelf.progressBlock(1,entryNumber / total);
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.errorHandler(error);
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf unZipSuccess];
                });
                
            }
        }];
    });
    
}
-(void)unZipSuccess{
    NSString *date = [NSString getCurrentTimes];
    _date = date;
    NSDictionary *dict = @{
        @"date":[NSString getCurrentTimes],
        @"cache":_version,
    };
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [_name stringByAppendingPathComponent:@"cache.plist"];
    [fm createFileAtPath:plistPath contents:nil attributes:nil];
    [dict writeToFile:plistPath atomically:YES];
    [[NSString stringWithFormat:@"%@/app.zip",_name] delIfExistsForAboustURL];
    
    _successHandler(_name,_date);
}
-(void)loadError:(NSError *)error{
    if (_hasLoad) {
        _successHandler(_name,_date);
    }
    else{
      _errorHandler(error);
    }
}
-(void)cancelTask{
    if (!_manager) {
        [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        _manager = nil;
    }
}
#pragma mark -- 懒加载
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return  _manager;
}
- (void)dealloc{
    if (_manager) {
        [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        _manager = nil;
    }
    
}
@end
