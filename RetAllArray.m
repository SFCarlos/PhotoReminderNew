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

#import "RetAllArray.h" 


@implementation RetAllArray

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
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"categoriesIdsArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        IdsCategories* item = [[IdsCategories alloc] initWithArray:arrayXml];
                        [dataArray1  addObject:item];
                    }
                    [self setCategoriesIdsArray:dataArray1];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"itemsIdsArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        IdsItems* item = [[IdsItems alloc] initWithArray:arrayXml];
                        [dataArray1  addObject:item];
                    }
                    [self setItemsIdsArray:dataArray1];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"filesIdsArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        IdsFiles* item = [[IdsFiles alloc] initWithArray:arrayXml];
                        [dataArray1  addObject:item];
                    }
                    [self setFilesIdsArray:dataArray1];
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
        [nsString appendString:@"<RetAllArray>" ];
    [nsString appendFormat:@"<globalReturn>%d</globalReturn>" , [self globalReturn]];
    [nsString appendFormat:@"<timestamp>%d</timestamp>" , [self timestamp]];
    if (self.categoriesIdsArray != nil) {
        [nsString appendFormat:@"<categoriesIdsArray>"];
        for(IdsCategories *elm in self.categoriesIdsArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</categoriesIdsArray>"];
    }
    if (self.itemsIdsArray != nil) {
        [nsString appendFormat:@"<itemsIdsArray>"];
        for(IdsItems *elm in self.itemsIdsArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</itemsIdsArray>"];
    }
    if (self.filesIdsArray != nil) {
        [nsString appendFormat:@"<filesIdsArray>"];
        for(IdsFiles *elm in self.filesIdsArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</filesIdsArray>"];
    }
    if (addNameWrap == YES)
        [nsString appendString:@"</RetAllArray>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.globalReturn = [decoder decodeInt32ForKey:@"globalReturn"];
        self.timestamp = [decoder decodeInt32ForKey:@"timestamp"];
        self.categoriesIdsArray = [decoder decodeObjectForKey:@"categoriesIdsArray"];
        self.itemsIdsArray = [decoder decodeObjectForKey:@"itemsIdsArray"];
        self.filesIdsArray = [decoder decodeObjectForKey:@"filesIdsArray"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:self.globalReturn forKey:@"globalReturn"];
    [encoder encodeInt32:self.timestamp forKey:@"timestamp"];
    [encoder encodeObject:self.categoriesIdsArray forKey:@"categoriesIdsArray"];
    [encoder encodeObject:self.itemsIdsArray forKey:@"itemsIdsArray"];
    [encoder encodeObject:self.filesIdsArray forKey:@"filesIdsArray"];
}
-(id)copyWithZone:(NSZone *)zone {
    RetAllArray *finalCopy = [[[self class] allocWithZone: zone] init];
    
    finalCopy.globalReturn = self.globalReturn;
    
    finalCopy.timestamp = self.timestamp;
    
    NSMutableArray *cpy3 = [self.categoriesIdsArray copy];
    finalCopy.categoriesIdsArray = cpy3;
    
    NSMutableArray *cpy4 = [self.itemsIdsArray copy];
    finalCopy.itemsIdsArray = cpy4;
    
    NSMutableArray *cpy5 = [self.filesIdsArray copy];
    finalCopy.filesIdsArray = cpy5;
    
    return finalCopy;
}

@end