//
//  INETData
//

#import "INETJSONData.h"

@implementation INETJSONData

- (id)initWithURL:(NSURL *)url andTarget:(id)target andAction:(SEL)action
{
    self = [super init];
    if (self) {
        self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
        _target = target;
        _action = action;
    }
    return self;
}

- (void)requestDataWithURLFromString:(NSString *)url
{
    if (self.connection) {
        [self.connection cancel];
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    
    if (self.connection) {
        [self.connection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _webArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error;

    NSMutableArray *o = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if ([o isKindOfClass:[NSArray class]])
        _webArray = o;
    else
        NSLog(@"Data not formatted correctly!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_target performSelector:_action withObject:_webArray];
}

@end
