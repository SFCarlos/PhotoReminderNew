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

#import "GetReturnArray.h" 


@implementation GetReturnArray

-(id)initWithArray:(NSArray*)array {
    self = [super init];
    if (self) {
        @try {
            for (int i0 = 0; i0 < [array count]; i0++)
            {
                if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"globalReturn"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setGlobalReturn:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"timestamp"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setTimestamp:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"categoriesArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        GetCategoryObj* item = [[GetCategoryObj alloc] initWithArray:arrayXml];
                        [dataArray1  addObject:item];
                    }
                    [self setCategoriesArray:dataArray1];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"itemsArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        GetItemObj* item = [[GetItemObj alloc] initWithArray:arrayXml];
                        [dataArray1  addObject:item];
                    }
                    [self setItemsArray:dataArray1];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"filesArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        GetFileObj* item = [[GetFileObj alloc] initWithArray:arrayXml];
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
        [nsString appendString:@"<GetReturnArray>" ];
    [nsString appendFormat:@"<globalReturn>%d</globalReturn>" , [self globalReturn]];
    [nsString appendFormat:@"<timestamp>%d</timestamp>" , [self timestamp]];
    if (self.categoriesArray != nil) {
        [nsString appendFormat:@"<categoriesArray>"];
        for(GetCategoryObj *elm in self.categoriesArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</categoriesArray>"];
    }
    if (self.itemsArray != nil) {
        [nsString appendFormat:@"<itemsArray>"];
        for(GetItemObj *elm in self.itemsArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</itemsArray>"];
    }
    if (self.filesArray != nil) {
        [nsString appendFormat:@"<filesArray>"];
        for(GetFileObj *elm in self.filesArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</filesArray>"];
    }
    if (addNameWrap == YES)
        [nsString appendString:@"</GetReturnArray>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.globalReturn = [decoder decodeInt32ForKey:@"globalReturn"];
        self.timestamp = [decoder decodeInt32ForKey:@"timestamp"];
        self.categoriesArray = [decoder decodeObjectForKey:@"categoriesArray"];
        self.itemsArray = [decoder decodeObjectForKey:@"itemsArray"];
        self.filesArray = [decoder decodeObjectForKey:@"filesArray"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:self.globalReturn forKey:@"globalReturn"];
    [encoder encodeInt32:self.timestamp forKey:@"timestamp"];
    [encoder encodeObject:self.categoriesArray forKey:@"categoriesArray"];
    [encoder encodeObject:self.itemsArray forKey:@"itemsArray"];
    [encoder encodeObject:self.filesArray forKey:@"filesArray"];
}
-(id)copyWithZone:(NSZone *)zone {
    GetReturnArray *finalCopy = [[[self class] allocWithZone: zone] init];
    
    finalCopy.globalReturn = self.globalReturn;
    
    finalCopy.timestamp = self.timestamp;
    
    NSMutableArray *cpy3 = [self.categoriesArray copy];
    finalCopy.categoriesArray = cpy3;
    
    NSMutableArray *cpy4 = [self.itemsArray copy];
    finalCopy.itemsArray = cpy4;
    
    NSMutableArray *cpy5 = [self.filesArray copy];
    finalCopy.filesArray = cpy5;
    
    return finalCopy;
}

@end
