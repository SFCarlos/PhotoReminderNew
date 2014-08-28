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

#import "GetItemObj.h" 


@implementation GetItemObj

-(id)initWithArray:(NSArray*)array {
    self = [super init];
    if (self) {
        @try {
            for (int i0 = 0; i0 < [array count]; i0++)
            {
                if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"serverCategoryID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setServerCategoryID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"serverItemID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setServerItemID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"itemName"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setItemName:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"itemAlarm"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setItemAlarm:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"itemRepeat"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setItemRepeat:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"itemNote"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setItemNote:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"itemStatus"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setItemStatus:[nodeContentValue intValue]];
                }
            }
        }
        @catch(NSException *ex){
        }
    }
    return self;
}
-(NSString*)toString:(BOOL)addNameWrap {
    NSMutableString *nsString = [NSMutableString string];
    if (addNameWrap == YES)
        [nsString appendString:@"<GetItemObj>" ];
    [nsString appendFormat:@"<serverCategoryID>%d</serverCategoryID>" , [self serverCategoryID]];
    [nsString appendFormat:@"<serverItemID>%d</serverItemID>" , [self serverItemID]];
    if (self.itemName != nil) {
        [nsString appendFormat:@"<itemName>%@</itemName>" , [self itemName]];
    }
    if (self.itemAlarm != nil) {
        [nsString appendFormat:@"<itemAlarm>%@</itemAlarm>" , [self itemAlarm]];
    }
    if (self.itemRepeat != nil) {
        [nsString appendFormat:@"<itemRepeat>%@</itemRepeat>" , [self itemRepeat]];
    }
    if (self.itemNote != nil) {
        [nsString appendFormat:@"<itemNote>%@</itemNote>" , [self itemNote]];
    }
    [nsString appendFormat:@"<itemStatus>%d</itemStatus>" , [self itemStatus]];
    if (addNameWrap == YES)
        [nsString appendString:@"</GetItemObj>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.serverCategoryID = [decoder decodeInt32ForKey:@"serverCategoryID"];
        self.serverItemID = [decoder decodeInt32ForKey:@"serverItemID"];
        self.itemName = [decoder decodeObjectForKey:@"itemName"];
        self.itemAlarm = [decoder decodeObjectForKey:@"itemAlarm"];
        self.itemRepeat = [decoder decodeObjectForKey:@"itemRepeat"];
        self.itemNote = [decoder decodeObjectForKey:@"itemNote"];
        self.itemStatus = [decoder decodeInt32ForKey:@"itemStatus"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:self.serverCategoryID forKey:@"serverCategoryID"];
    [encoder encodeInt32:self.serverItemID forKey:@"serverItemID"];
    [encoder encodeObject:self.itemName forKey:@"itemName"];
    [encoder encodeObject:self.itemAlarm forKey:@"itemAlarm"];
    [encoder encodeObject:self.itemRepeat forKey:@"itemRepeat"];
    [encoder encodeObject:self.itemNote forKey:@"itemNote"];
    [encoder encodeInt32:self.itemStatus forKey:@"itemStatus"];
}
-(id)copyWithZone:(NSZone *)zone {
    GetItemObj *finalCopy = [[[self class] allocWithZone: zone] init];
    
    finalCopy.serverCategoryID = self.serverCategoryID;
    
    finalCopy.serverItemID = self.serverItemID;
    
    NSString *copy3 = [self.itemName copy];
    finalCopy.itemName = copy3;
    
    NSString *copy4 = [self.itemAlarm copy];
    finalCopy.itemAlarm = copy4;
    
    NSString *copy5 = [self.itemRepeat copy];
    finalCopy.itemRepeat = copy5;
    
    NSString *copy6 = [self.itemNote copy];
    finalCopy.itemNote = copy6;
    
    finalCopy.itemStatus = self.itemStatus;
    
    return finalCopy;
}

@end
