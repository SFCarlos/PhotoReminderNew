//------------------------------------------------------------------------------
// <wsdl2code-generated>
// This code was generated by http://www.wsdl2code.com iPhone version 2.0
// Date Of Creation: 5/23/2014 4:12:21 PM
//
//  Please dont change this code, regeneration will override your changes
//</wsdl2code-generated>
//
//------------------------------------------------------------------------------
//
//This source code was auto-generated by Wsdl2Code Version
//

#import "GroupCategory.h" 


@implementation GroupCategory

-(id)initWithArray:(NSArray*)array {
    self = [super init];
    if (self) {
        @try {
            for (int i0 = 0; i0 < [array count]; i0++)
            {
                if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"categoryID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setCategoryID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"categoryName"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setCategoryName:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"categoryColorPic"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setCategoryColorPic:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeChildArray"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"RemindersArray"]==NSOrderedSame)){
                    NSArray* array1= [[array objectAtIndex:i0] objectForKey:@"nodeChildArray"];
                    NSMutableArray* dataArray1= [[NSMutableArray alloc]init];
                    for (int i1=0; i1<[array1 count];i1++)
                    {
                        NSArray* arrayXml = [[array1  objectAtIndex:i1] objectForKey:@"nodeChildArray"];
                        Reminder* item = [[Reminder alloc] initWithArray:arrayXml];
                        [dataArray1  addObject:item];
                    }
                    [self setRemindersArray:dataArray1];
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
        [nsString appendString:@"<GroupCategory>" ];
    [nsString appendFormat:@"<categoryID>%d</categoryID>" , [self categoryID]];
    if (self.categoryName != nil) {
        [nsString appendFormat:@"<categoryName>%@</categoryName>" , [self categoryName]];
    }
    if (self.categoryColorPic != nil) {
        [nsString appendFormat:@"<categoryColorPic>%@</categoryColorPic>" , [self categoryColorPic]];
    }
    if (self.remindersArray != nil) {
        [nsString appendFormat:@"<RemindersArray>"];
        for(Reminder *elm in self.remindersArray){
            [nsString appendFormat:@"%@", [elm toString:YES]];
        }
        [nsString appendFormat:@"</RemindersArray>"];
    }
    if (addNameWrap == YES)
        [nsString appendString:@"</GroupCategory>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.categoryID = [decoder decodeInt32ForKey:@"categoryID"];
        self.categoryName = [decoder decodeObjectForKey:@"categoryName"];
        self.categoryColorPic = [decoder decodeObjectForKey:@"categoryColorPic"];
        self.remindersArray = [decoder decodeObjectForKey:@"remindersArray"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:self.categoryID forKey:@"categoryID"];
    [encoder encodeObject:self.categoryName forKey:@"categoryName"];
    [encoder encodeObject:self.categoryColorPic forKey:@"categoryColorPic"];
    [encoder encodeObject:self.remindersArray forKey:@"remindersArray"];
}
-(id)copyWithZone:(NSZone *)zone {
    GroupCategory *finalCopy = [[[self class] allocWithZone: zone] init];
    
    finalCopy.categoryID = self.categoryID;
    
    NSString *copy2 = [self.categoryName copy];
    finalCopy.categoryName = copy2;
    
    NSString *copy3 = [self.categoryColorPic copy];
    finalCopy.categoryColorPic = copy3;
    
    NSMutableArray *cpy4 = [self.remindersArray copy];
    finalCopy.remindersArray = cpy4;
    
    return finalCopy;
}

@end