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

#import "GetQueryFileObj.h" 


@implementation GetQueryFileObj

-(id)initWithArray:(NSArray*)array {
    self = [super init];
    if (self) {
        @try {
            for (int i0 = 0; i0 < [array count]; i0++)
            {
                if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"serverFileID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setServerFileID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"serverItemID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setServerItemID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"fileTimestamp"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setFileTimestamp:[nodeContentValue intValue]];
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
        [nsString appendString:@"<GetQueryFileObj>" ];
    [nsString appendFormat:@"<serverFileID>%d</serverFileID>" , [self serverFileID]];
    [nsString appendFormat:@"<serverItemID>%d</serverItemID>" , [self serverItemID]];
    [nsString appendFormat:@"<fileTimestamp>%d</fileTimestamp>" , [self fileTimestamp]];
    if (addNameWrap == YES)
        [nsString appendString:@"</GetQueryFileObj>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.serverFileID = [decoder decodeInt32ForKey:@"serverFileID"];
        self.serverItemID = [decoder decodeInt32ForKey:@"serverItemID"];
        self.fileTimestamp = [decoder decodeInt32ForKey:@"fileTimestamp"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:self.serverFileID forKey:@"serverFileID"];
    [encoder encodeInt32:self.serverItemID forKey:@"serverItemID"];
    [encoder encodeInt32:self.fileTimestamp forKey:@"fileTimestamp"];
}
-(id)copyWithZone:(NSZone *)zone {
    GetQueryFileObj *finalCopy = [[[self class] allocWithZone: zone] init];
    
    finalCopy.serverFileID = self.serverFileID;
    
    finalCopy.serverItemID = self.serverItemID;
    
    finalCopy.fileTimestamp = self.fileTimestamp;
    
    return finalCopy;
}

@end
