SSRestClient
============

Simple Rest Client and JSON response handler reusable classes.

Example : 

- (void)demoServiceCall {
    SSRestManager *restManager = [[SSRestManager alloc] init];
    [restManager getJsonResponseFromBaseUrl:@"https://dl.dropboxusercontent.com" query:@"/u/50403261/Rest/sample.json" onCompletion:^(NSDictionary *json) {
        NSLog(@"%@",json);
    } onError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

Instruction To add in your project files :

1. Copy "SSRestClient" folder  and Paster it inside your project folder.
2. Add "SSRestClient" folder in your project file.
3. Then start using with upper example.
