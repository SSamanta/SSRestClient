# SSRestClient

SSRestClient is a resuable IOS components for network call to ease task of differnt type REST based network call.

  - Easy to use
  - Support different HTTP methods 
  - Using Objective-C

SSRestClient is a lightweight resuable component using Objective C language and NSURLConnection class:
### Version
2.0.0


### Installation
  - Copy "SSRestClient" folder and Paste it inside your project folder.
  - Add "SSRestClient" folder in your project file.

### Development

Sample service call
```sh
 -(void)demoServiceCall { SSRestManager *restManager = [[SSRestManager alloc] init]; 
 ```
 ```sh
 NSString *baseUrlString = @"http://itunes.apple.com";
```
```sh
 NSString *queryString = @"/us/rss/topfreeapplications/limit=100/json";
```
```sh
 [restManager getJsonResponseFromBaseUrl:baseUrlString query:queryString onCompletion:^(NSDictionary *json) { 
  NSLog(@"%@",json); } onError:^(NSError *error) { NSLog(@"%@",error); }]; 
 }

```
License
----

NONE
