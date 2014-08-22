//------------------------------------------------------------------------------
// <wsdl2code-generated>
// This code was generated by http://www.wsdl2code.com iPhone version 2.0
// Date Of Creation: 8/19/2014 12:22:56 PM
//
//  Please dont change this code, regeneration will override your changes
//</wsdl2code-generated>
//
//------------------------------------------------------------------------------
//
//This source code was auto-generated by Wsdl2Code Version
//
#import "iOSServiceProxy.h"

@implementation iOSServiceProxy

-(id)initWithUrl:(NSString*)url AndDelegate:(id<Wsdl2CodeProxyDelegate>)delegate{
    self = [super init];
    if (self != nil){
        self.service = [[iOSService alloc] init];
        [self.service setUrl:url];
        [self setUrl:url];
        [self setProxyDelegate:delegate];
    }
    return self;
}

///Origin Return Type:NSString
-(void)autenticate:(NSString *)user :(NSString *)pass {
    [self.service addTarget:self AndAction:&autenticateTarget];
    [self.service autenticate:user :pass ];
}

void autenticateTarget(iOSServiceProxy* target, id sender, NSString* xml){
    @try{
        NSString *xmldata = [xml stringByReplacingOccurrencesOfString:@"xmlns=\"urn:iOSService\"" withString:@""];
        NSData *data = [xmldata dataUsingEncoding:NSUTF8StringEncoding];
        XPathQuery *xpathQuery = [[XPathQuery alloc] init];
        NSString * query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/*/*"];
        NSArray *arrayOfWSData = [xpathQuery newXMLXPathQueryResult:data andQuery:query];
        if([arrayOfWSData count] == 0 ){
            NSException *exception = [NSException exceptionWithName:@"Wsdl2Code" reason: @"Response is nil" userInfo: nil];
            if (target.proxyDelegate != nil){
                [target.proxyDelegate proxyRecievedError:exception InMethod:@"autenticate"];
                return;
            }
        }
        NSString *nodeContentValue = [[NSString alloc] initWithString:[[arrayOfWSData objectAtIndex:0] objectForKey:@"nodeContent"]];
        NSString* result = nil;
        if (nodeContentValue !=nil){
            result = [[NSString alloc] initWithString:nodeContentValue];
        }
         if (target.proxyDelegate != nil){
            [target.proxyDelegate proxydidFinishLoadingData:result InMethod:@"autenticate"];
            return;
        }
    }
    @catch(NSException *ex){
        if (target.proxyDelegate != nil){
            [target.proxyDelegate proxyRecievedError:ex InMethod:@"autenticate"];
            return;
        }
    }
}

///Origin Return Type:int
-(void)registerUser:(NSString *)user :(NSString *)pass {
    [self.service addTarget:self AndAction:&registerUserTarget];
    [self.service registerUser:user :pass ];
}

void registerUserTarget(iOSServiceProxy* target, id sender, NSString* xml){
    @try{
        NSString *xmldata = [xml stringByReplacingOccurrencesOfString:@"xmlns=\"urn:iOSService\"" withString:@""];
        NSData *data = [xmldata dataUsingEncoding:NSUTF8StringEncoding];
        XPathQuery *xpathQuery = [[XPathQuery alloc] init];
        NSString * query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/*/*"];
        NSArray *arrayOfWSData = [xpathQuery newXMLXPathQueryResult:data andQuery:query];
        if([arrayOfWSData count] == 0 ){
            NSException *exception = [NSException exceptionWithName:@"Wsdl2Code" reason: @"Response is nil" userInfo: nil];
            if (target.proxyDelegate != nil){
                [target.proxyDelegate proxyRecievedError:exception InMethod:@"registerUser"];
                return;
            }
        }
        NSString *nodeContentValue = [[NSString alloc] initWithString:[[arrayOfWSData objectAtIndex:0] objectForKey:@"nodeContent"]];
        NSNumber* result = nil;
        result = [NSNumber numberWithInt:[nodeContentValue intValue]];
         if (target.proxyDelegate != nil){
            [target.proxyDelegate proxydidFinishLoadingData:result InMethod:@"registerUser"];
            return;
        }
    }
    @catch(NSException *ex){
        if (target.proxyDelegate != nil){
            [target.proxyDelegate proxyRecievedError:ex InMethod:@"registerUser"];
            return;
        }
    }
}

///Origin Return Type:RetAllArray
-(void)syncAll:(inAllArray *)name {
    [self.service addTarget:self AndAction:&syncAllTarget];
    [self.service syncAll:name ];
}

void syncAllTarget(iOSServiceProxy* target, id sender, NSString* xml){
    @try{
        NSString *xmldata = [xml stringByReplacingOccurrencesOfString:@"xmlns=\"urn:iOSService\"" withString:@""];
        NSData *data = [xmldata dataUsingEncoding:NSUTF8StringEncoding];
        XPathQuery *xpathQuery = [[XPathQuery alloc] init];
        NSString * query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/*/*"];
        NSArray *arrayOfWSData = [xpathQuery newXMLXPathQueryResult:data andQuery:query];
        if([arrayOfWSData count] == 0 ){
            NSException *exception = [NSException exceptionWithName:@"Wsdl2Code" reason: @"Response is nil" userInfo: nil];
            if (target.proxyDelegate != nil){
                [target.proxyDelegate proxyRecievedError:exception InMethod:@"syncAll"];
                return;
            }
        }
        NSArray* array0 = [[arrayOfWSData objectAtIndex:0] objectForKey:@"nodeChildArray"];
        RetAllArray* result = [[RetAllArray alloc]initWithArray:array0];
         if (target.proxyDelegate != nil){
            [target.proxyDelegate proxydidFinishLoadingData:result InMethod:@"syncAll"];
            return;
        }
    }
    @catch(NSException *ex){
        if (target.proxyDelegate != nil){
            [target.proxyDelegate proxyRecievedError:ex InMethod:@"syncAll"];
            return;
        }
    }
}

///Origin Return Type:GetReturnArray
-(void)checkUpdates:(GetQueryArray *)name {
    [self.service addTarget:self AndAction:&checkUpdatesTarget];
    [self.service checkUpdates:name ];
}

void checkUpdatesTarget(iOSServiceProxy* target, id sender, NSString* xml){
    @try{
        NSString *xmldata = [xml stringByReplacingOccurrencesOfString:@"xmlns=\"urn:iOSService\"" withString:@""];
        NSData *data = [xmldata dataUsingEncoding:NSUTF8StringEncoding];
        XPathQuery *xpathQuery = [[XPathQuery alloc] init];
        NSString * query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/*/*"];
        NSArray *arrayOfWSData = [xpathQuery newXMLXPathQueryResult:data andQuery:query];
        if([arrayOfWSData count] == 0 ){
            NSException *exception = [NSException exceptionWithName:@"Wsdl2Code" reason: @"Response is nil" userInfo: nil];
            if (target.proxyDelegate != nil){
                [target.proxyDelegate proxyRecievedError:exception InMethod:@"checkUpdates"];
                return;
            }
        }
        NSArray* array1 = [[arrayOfWSData objectAtIndex:0] objectForKey:@"nodeChildArray"];
        GetReturnArray* result = [[GetReturnArray alloc]initWithArray:array1];
         if (target.proxyDelegate != nil){
            [target.proxyDelegate proxydidFinishLoadingData:result InMethod:@"checkUpdates"];
            return;
        }
    }
    @catch(NSException *ex){
        if (target.proxyDelegate != nil){
            [target.proxyDelegate proxyRecievedError:ex InMethod:@"checkUpdates"];
            return;
        }
    }
}

///Origin Return Type:RetAllArray
-(void)categoryShare:(NSString *)user :(NSString *)pass :(int)serverCategoryID :(NSString *)firendEmail {
    [self.service addTarget:self AndAction:&categoryShareTarget];
    [self.service categoryShare:user :pass :serverCategoryID :firendEmail ];
}

void categoryShareTarget(iOSServiceProxy* target, id sender, NSString* xml){
    @try{
        NSString *xmldata = [xml stringByReplacingOccurrencesOfString:@"xmlns=\"urn:iOSService\"" withString:@""];
        NSData *data = [xmldata dataUsingEncoding:NSUTF8StringEncoding];
        XPathQuery *xpathQuery = [[XPathQuery alloc] init];
        NSString * query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/*/*"];
        NSArray *arrayOfWSData = [xpathQuery newXMLXPathQueryResult:data andQuery:query];
        if([arrayOfWSData count] == 0 ){
            NSException *exception = [NSException exceptionWithName:@"Wsdl2Code" reason: @"Response is nil" userInfo: nil];
            if (target.proxyDelegate != nil){
                [target.proxyDelegate proxyRecievedError:exception InMethod:@"categoryShare"];
                return;
            }
        }
        NSArray* array2 = [[arrayOfWSData objectAtIndex:0] objectForKey:@"nodeChildArray"];
        RetAllArray* result = [[RetAllArray alloc]initWithArray:array2];
         if (target.proxyDelegate != nil){
            [target.proxyDelegate proxydidFinishLoadingData:result InMethod:@"categoryShare"];
            return;
        }
    }
    @catch(NSException *ex){
        if (target.proxyDelegate != nil){
            [target.proxyDelegate proxyRecievedError:ex InMethod:@"categoryShare"];
            return;
        }
    }
}
@end
