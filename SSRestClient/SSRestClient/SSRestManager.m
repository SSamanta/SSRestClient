//
//  SSRestManager.m
//  SSRestClient
//
//  Created by Susim Samanta on 15/08/13.
//  Copyright (c) 2013 Susim Samanta. All rights reserved.
//

#import "SSRestManager.h"
#import "SSJsonResponseHandler.h"
@interface SSRestManager ()
@end

@implementation SSRestManager

- (void)getHttpResponseWithBaseUrl:(NSString *)url onCompletion:(SSServiceResponseHandler)serviceHandler onError:(SSErrorHandler)errorHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setValue:self.authorizationValue? self.authorizationValue :@"" forHTTPHeaderField:@"Authorization"];
    [request addValue:self.contentType? self.contentType :@"" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:self.httpMethod];
    [request setHTTPBody:[self.httpBody? self.httpBody : @"" dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:(NSURLRequest *)request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            errorHandler (error);
        }else {
            serviceHandler (data,response);
        }
    }];
}

- (void)getServiceResponseWithBaseUrl:(NSString *)baseUrl query:(NSString *)queryString onCompletion:(SSServiceResponseHandler )serviceHandler onError:(SSErrorHandler)errorHandler {
    NSURL *url =  queryString ? [NSURL URLWithString:queryString relativeToURL:[NSURL URLWithString:baseUrl]] : [NSURL URLWithString:baseUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:(NSURLRequest *)request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            errorHandler (error);
        }else {
            serviceHandler (data,response);
        }
    }];
}

-(void)getJsonResponseFromBaseUrl:(NSString *)baseUrl query:(NSString *)queryString onCompletion:(SSJSONResponseHandler)jsonHandler onError:(SSErrorHandler)errorHandler {
    [self getServiceResponseWithBaseUrl:baseUrl query:queryString onCompletion:^(id responseData, NSURLResponse *reponse) {
        SSJsonResponseHandler *jsonResponseHandler = [[SSJsonResponseHandler alloc] init];
        [jsonResponseHandler getJsonResponseFromData:responseData onCompletion:^(NSDictionary *json) {
            jsonHandler(json);
        } onError:^(NSError *error) {
            errorHandler(error);
        }];
    } onError:^(NSError *error) {
        errorHandler (error);
    }];
}
+(void)postFileData:(NSData *)data withBaseURL:(NSString *)baseURL withFileName:(NSString *)fileName fileKey:(NSString *)key onCompletion:(SSServiceResponseHandler)serviceHandler onError:(SSErrorHandler)errorHandler {
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n",key,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            serviceHandler(data,response);
        }else if (connectionError) {
            errorHandler(connectionError);
        }
    }];
}

#pragma mark NSURLSession enable methods
+ (void)fetchJsonDataFromURL:(NSString *)url onCompletion:(SSJSONResponseHandler)jsonHandler onError:(SSErrorHandler)errorHandler{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            errorHandler(error);
        }else {
            SSJsonResponseHandler *jsonResponseHandler = [[SSJsonResponseHandler alloc] init];
            [jsonResponseHandler getJsonResponseFromData:data onCompletion:^(NSDictionary *json) {
                jsonHandler(json);
            } onError:^(NSError *error) {
                errorHandler(error);
            }];
        }
    }] resume];
}

+ (void)fetchDownloadedDataFromURL:(NSString *)url onCompletion:(SSServiceResponseHandler)serviceHandler onError:(SSErrorHandler)errorHandler {
     NSURLSession *session = [NSURLSession sharedSession];
    [[session downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            errorHandler (error);
        }else {
            NSData *data = [NSData dataWithContentsOfURL:location];
            serviceHandler(data,response);
        }
    }] resume];
}
@end
