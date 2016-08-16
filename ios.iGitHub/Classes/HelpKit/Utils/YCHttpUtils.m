//
//  YCHttpUtils.m
//  ios_utils
//
//  Created by yangc on 16-4-25.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "YCHttpUtils.h"

@implementation YCHttpUtils

+ (void)sendGet:(NSString *)URLString params:(NSDictionary *)params success:(void (^)(NSHTTPURLResponse *, id))success failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    [self sendGet:URLString headers:nil params:params success:success failure:failure];
}

+ (void)sendGet:(NSString *)URLString
        headers:(NSDictionary *)headers
         params:(NSDictionary *)params
        success:(void (^)(NSHTTPURLResponse *, id))success
        failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (headers.count) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    [manager GET:URLString
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (success) {
                success((NSHTTPURLResponse *) task.response, responseObject);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (failure) {
                failure((NSHTTPURLResponse *) task.response, error);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
}

+ (void)sendPost:(NSString *)URLString params:(NSDictionary *)params success:(void (^)(NSHTTPURLResponse *, id))success failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    [self sendPost:URLString headers:nil params:params success:success failure:failure];
}

+ (void)sendPost:(NSString *)URLString
         headers:(NSDictionary *)headers
          params:(NSDictionary *)params
         success:(void (^)(NSHTTPURLResponse *, id))success
         failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (headers.count) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    [manager POST:URLString
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (success) {
                success((NSHTTPURLResponse *) task.response, responseObject);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (failure) {
                failure((NSHTTPURLResponse *) task.response, error);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
}

+ (void)sendPost:(NSString *)URLString
          params:(NSDictionary *)params
 attachmentArray:(NSArray *)attachmentArray
         success:(void (^)(NSHTTPURLResponse *, id))success
         failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    [self sendPost:URLString headers:nil params:params attachmentArray:attachmentArray success:success failure:failure];
}

+ (void)sendPost:(NSString *)URLString
         headers:(NSDictionary *)headers
          params:(NSDictionary *)params
 attachmentArray:(NSArray *)attachmentArray
         success:(void (^)(NSHTTPURLResponse *, id))success
         failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (headers.count) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    [manager POST:URLString
        parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            for (YCAttachment *attachment in attachmentArray) {
                [formData appendPartWithFileData:attachment.data name:attachment.name fileName:attachment.fileName mimeType:attachment.mimeType];
            }
        }
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (success) {
                success((NSHTTPURLResponse *) task.response, responseObject);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (failure) {
                failure((NSHTTPURLResponse *) task.response, error);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
}

+ (void)download:(NSString *)URLString
             progress:(void (^)(NSProgress *))progress
          destination:(NSURL * (^)(NSURL *, NSHTTPURLResponse *))destination
    completionHandler:(void (^)(NSHTTPURLResponse *, NSURL *, NSError *))completionHandler {
    [self download:URLString headers:nil progress:progress destination:destination completionHandler:completionHandler];
}

+ (void)download:(NSString *)URLString
              headers:(NSDictionary *)headers
             progress:(void (^)(NSProgress *downProgress))progress
          destination:(NSURL * (^)(NSURL *targetPath, NSHTTPURLResponse *response))destination
    completionHandler:(void (^)(NSHTTPURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    if (headers.count) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
        progress:^(NSProgress *downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        }
        destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return destination(targetPath, (NSHTTPURLResponse *) response);
        }
        completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            completionHandler((NSHTTPURLResponse *) response, filePath, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    [downloadTask resume];
}

@end

@implementation YCAttachment

@end
