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


@interface ItemObj : NSObject
{
}
@property int clientCategoryID;
@property int serverCategoryID;
@property int clientItemID;
@property int serverItemID;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemAlarm;
@property (nonatomic, copy) NSString *itemRepeat;
@property (nonatomic, copy) NSString *itemNote;
@property int itemStatus;

-(NSString*)toString:(BOOL)addNameWrap;
-(id)initWithArray:(NSArray*)array;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)copyWithZone:(NSZone *)zone;
-(id)initWithCoder:(NSCoder *)decoder;
@end
