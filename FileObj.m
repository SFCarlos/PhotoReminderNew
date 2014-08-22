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

#import "FileObj.h" 


@implementation FileObj

-(id)initWithArray:(NSArray*)array {
    self = [super init];
    if (self) {
        @try {
            for (int i0 = 0; i0 < [array count]; i0++)
            {
                if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"clientFileID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setClientFileID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"serverFileID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setServerFileID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"clientItemID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setClientItemID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"serverItemID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setServerItemID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"fileType"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setFileType:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"fileData"]==NSOrderedSame)){
                    NSString* stringData = [[array  objectAtIndex:i0] objectForKey:@"nodeContent"];
                    NSData* nodeContentValue = [NSData dataFromBase64String:stringData];
                    [self setFileData:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"fileStatus"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setFileStatus:[nodeContentValue intValue]];
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
        [nsString appendString:@"<FileObj>" ];
    [nsString appendFormat:@"<clientFileID>%d</clientFileID>" , [self clientFileID]];
    [nsString appendFormat:@"<serverFileID>%d</serverFileID>" , [self serverFileID]];
    [nsString appendFormat:@"<clientItemID>%d</clientItemID>" , [self clientItemID]];
    [nsString appendFormat:@"<serverItemID>%d</serverItemID>" , [self serverItemID]];
    [nsString appendFormat:@"<fileType>%d</fileType>" , [self fileType]];
    if (self.fileData != nil) {
        [nsString appendFormat:@"<fileData>%@</fileData>",[self.fileData base64EncodedString]];
    }
    [nsString appendFormat:@"<fileStatus>%d</fileStatus>" , [self fileStatus]];
    if (addNameWrap == YES)
        [nsString appendString:@"</FileObj>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.clientFileID = [decoder decodeInt32ForKey:@"clientFileID"];
        self.serverFileID = [decoder decodeInt32ForKey:@"serverFileID"];
        self.clientItemID = [decoder decodeInt32ForKey:@"clientItemID"];
        self.serverItemID = [decoder decodeInt32ForKey:@"serverItemID"];
        self.fileType = [decoder decodeInt32ForKey:@"fileType"];
        self.fileData = [decoder decodeObjectForKey:@"fileData"];
        self.fileStatus = [decoder decodeInt32ForKey:@"fileStatus"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:self.clientFileID forKey:@"clientFileID"];
    [encoder encodeInt32:self.serverFileID forKey:@"serverFileID"];
    [encoder encodeInt32:self.clientItemID forKey:@"clientItemID"];
    [encoder encodeInt32:self.serverItemID forKey:@"serverItemID"];
    [encoder encodeInt32:self.fileType forKey:@"fileType"];
    [encoder encodeObject:self.fileData forKey:@"fileData"];
    [encoder encodeInt32:self.fileStatus forKey:@"fileStatus"];
}
-(id)copyWithZone:(NSZone *)zone {
    FileObj *finalCopy = [[[self class] allocWithZone: zone] init];
    
    finalCopy.clientFileID = self.clientFileID;
    
    finalCopy.serverFileID = self.serverFileID;
    
    finalCopy.clientItemID = self.clientItemID;
    
    finalCopy.serverItemID = self.serverItemID;
    
    finalCopy.fileType = self.fileType;
    
    NSData *cpy6 = [self.fileData copy];
    finalCopy.fileData = cpy6;
    
    finalCopy.fileStatus = self.fileStatus;
    
    return finalCopy;
}

@end
