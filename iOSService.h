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

#import <Foundation/Foundation.h>
#import "iOSService_Enums.h"
#import "inAllArray.h"
#import "RetAllArray.h"
#import "GetQueryArray.h"
#import "GetReturnArray.h"


@interface iOSService : NSObject
{
}
@property SoapProtocolVersion soapVersion;
@property BOOL allowAutoRedirect;
@property BOOL enableDecompression;
@property (nonatomic, copy) NSString *userAgent;
@property BOOL unsafeAuthenticatedConnectionSharing;
@property BOOL useDefaultCredentials;
@property (nonatomic, copy) NSString *connectionGroupName;
@property BOOL preAuthenticate;
@property (nonatomic, copy) NSString *url;
@property int timeout;
@property (nonatomic, assign) void(*targetAction)(id target,id sender,NSString* xml);
@property (nonatomic,assign) id actionDelegate;
@property (nonatomic, strong) NSURLConnection *wsConnection;
@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableDictionary *requestHeaders;
@property (nonatomic, copy)   NSString *eventName;

///Origin Return Type:NSString
-(void)autenticate:(NSString *)user :(NSString *)pass ;
///Origin Return Type:int
-(void)registerUser:(NSString *)user :(NSString *)pass ;
///Origin Return Type:RetAllArray
-(void)syncAll:(inAllArray *)name ;
///Origin Return Type:GetReturnArray
-(void)checkUpdates:(GetQueryArray *)name ;
///Origin Return Type:RetAllArray
-(void)categoryShare:(NSString *)user :(NSString *)pass :(int)serverCategoryID :(NSString *)firendEmail ;
-(id) initWithTarget:(id)target  AndAction:(void(*)(id target,id sender ,NSString* xml))action;
-(void) addTarget:(id)target AndAction:(void(*)(id target,id sender ,NSString* xml))action;
@end
