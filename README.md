SSRestClient
============

Simple Rest Client and JSON response handler reusable classes.

Instruction To add in your project files :

1. Copy "SSRestClient" folder and paste it inside your project folder.
2. Add "SSRestClient" folder in your project file.
3. Then start using with below example.

Example : 

- (void)demoServiceCall {
    SSRestManager *restManager = [[SSRestManager alloc] init];
    [restManager getJsonResponseFromBaseUrl:@"http:/example.com" query:@"/?count=30" onCompletion:^(NSDictionary *json) {
        NSLog(@"%@",json);
    } onError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



