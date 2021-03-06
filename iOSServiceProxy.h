//------------------------------------------------------------------------------
// <wsdl2code-generated>
// This code was generated by http://www.wsdl2code.com iPhone version 2.0
// Date Of Creation: 8/27/2014 3:43:10 PM
//
//  Please dont change this code, regeneration will override your changes
//</wsdl2code-generated>
//
//------------------------------------------------------------------------------
//
//This source code was auto-generated by Wsdl2Code Version
//

#import <Foundation/Foundation.h>
#import "xpathquery.h"
#import "iOSService.h"
#import "GetQueryArray.h"
#import "GetReturnArray.h"
#import "inAllArray.h"
#import "RetAllArray.h"
#import "checkSharesRet.h"
#import "shareConfirmRet.h"
#import "categoryShareRet.h"

#ifndef _Wsdl2CodeProxyDelegate
#define _Wsdl2CodeProxyDelegate
@protocol Wsdl2CodeProxyDelegate
//if service recieve an error this method will be called
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method;
//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method;
@end
#endif

@interface iOSServiceProxy : NSObject
@property (nonatomic,assign) id<Wsdl2CodeProxyDelegate> proxyDelegate;
@property (nonatomic,copy)   NSString* url;
@property (nonatomic,retain) iOSService* service;

-(id)initWithUrl:(NSString*)url AndDelegate:(id<Wsdl2CodeProxyDelegate>)delegate;
///Origin Return Type:NSString
-(void)autenticate:(NSString *)user :(NSString *)pass ;
///Origin Return Type:int
-(void)registerUser:(NSString *)user :(NSString *)pass ;
///Origin Return Type:GetReturnArray
-(void)checkUpdates:(GetQueryArray *)name ;
///Origin Return Type:RetAllArray
-(void)syncAll:(inAllArray *)name ;
///Origin Return Type:checkSharesRet
-(void)checkShares:(NSString *)user :(NSString *)pass ;
///Origin Return Type:shareConfirmRet
-(void)shareConfirm:(NSString *)user :(NSString *)pass :(int)serverCategoryID :(int)status ;
///Origin Return Type:categoryShareRet
-(void)categoryShare:(NSString *)user :(NSString *)pass :(int)clientCategoryID :(int)serverCategoryID :(NSString *)firendEmail ;
@end
