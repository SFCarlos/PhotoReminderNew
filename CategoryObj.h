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


@interface CategoryObj : NSObject
{
}
@property int clientCategoryID;
@property int serverCategoryID;
@property int categoryType;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryColor;
@property int categoryStatus;

-(NSString*)toString:(BOOL)addNameWrap;
-(id)initWithArray:(NSArray*)array;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)copyWithZone:(NSZone *)zone;
-(id)initWithCoder:(NSCoder *)decoder;
@end
