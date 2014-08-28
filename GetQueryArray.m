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

#import "GetQueryArray.h" 


@implementation GetQueryArray

-(id)initWithArray:(NSArray*)array {
    self = [super init];
    if (self) {
        @try {
            for (int i0 = 0; i0 < [array count]; i0++)
            {
                if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"user"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setUser:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"pass"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setPass:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"timestamp"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setTimestamp:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"filesArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        GetQueryFileObj* item = [[GetQueryFileObj alloc] initWithArray:arrayXml];
                        [dataArray1  addObject:item];
                    }
                    [self setFilesArray:dataArray1];
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
        [nsString appendString:@"<GetQueryArray>" ];
    if (self.user != nil) {
        [nsString appendFormat:@"<user>%@</user>" , [self user]];
    }
    if (self.pass != nil) {
        [nsString appendFormat:@"<pass>%@</pass>" , [self pass]];
    }
    [nsString appendFormat:@"<timestamp>%d</timestamp>" , [self timestamp]];
    if (self.filesArray != nil) {
        [nsString appendFormat:@"<filesArray>"];
        for(GetQueryFileObj *elm in self.filesArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</filesArray>"];
    }
    if (addNameWrap == YES)
        [nsString appendString:@"</GetQueryArray>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.user = [decoder decodeObjectForKey:@"user"];
        self.pass = [decoder decodeObjectForKey:@"pass"];
        self.timestamp = [decoder decodeInt32ForKey:@"timestamp"];
        self.filesArray = [decoder decodeObjectForKey:@"filesArray"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.user forKey:@"user"];
    [encoder encodeObject:self.pass forKey:@"pass"];
    [encoder encodeInt32:self.timestamp forKey:@"timestamp"];
    [encoder encodeObject:self.filesArray forKey:@"filesArray"];
}
-(id)copyWithZone:(NSZone *)zone {
    GetQueryArray *finalCopy = [[[self class] allocWithZone: zone] init];
    
    NSString *copy1 = [self.user copy];
    finalCopy.user = copy1;
    
    NSString *copy2 = [self.pass copy];
    finalCopy.pass = copy2;
    
    finalCopy.timestamp = self.timestamp;
    
    NSMutableArray *cpy4 = [self.filesArray copy];
    finalCopy.filesArray = cpy4;
    
    return finalCopy;
}

@end
