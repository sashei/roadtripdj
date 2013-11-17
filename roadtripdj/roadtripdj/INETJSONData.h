//
//  INETData.h
//
//
//
//

#import <UIKit/UIKit.h>

@interface INETJSONData : NSObject <NSURLConnectionDataDelegate>

@property NSURLConnection *connection;
@property NSMutableArray *webArray;

@property id target;
@property SEL action;

- (id)initWithURL:(NSURL *)url andTarget:(id)target andAction:(SEL)action;

- (void)requestDataWithURLFromString:(NSString *)url;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
