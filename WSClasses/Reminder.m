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

#import "Reminder.h" 


@implementation Reminder

-(id)initWithArray:(NSArray*)array {
    self = [super init];
    if (self) {
        @try {
            for (int i0 = 0; i0 < [array count]; i0++)
            {
                if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"ReminderID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setReminderID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"categoryID"]==NSOrderedSame)){
                    NSString *nodeContentValue = [[NSString alloc]initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    [self setCategoryID:[nodeContentValue intValue]];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"EventName"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setEventName:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"EventAlarm"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setEventAlarm:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"EventNote"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setEventNote:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"EventRecurring"]==NSOrderedSame)){
                    NSString* nodeContentValue = [[NSString alloc] initWithString:[[array objectAtIndex:i0] objectForKey:@"nodeContent"]];
                    if (nodeContentValue !=nil)
                        [self setEventRecurring:nodeContentValue];
                }
                else if ( ([[array objectAtIndex:i0] objectForKey:@"nodeContent"] !=nil) &&  ([[[array objectAtIndex:i0]objectForKey:@"nodeName"]caseInsensitiveCompare:@"reminderPhoto"]==NSOrderedSame)){
                    NSString* stringData = [[array  objectAtIndex:i0] objectForKey:@"nodeContent"];
                    NSData* nodeContentValue = [NSData dataFromBase64String:stringData];
                    [self setReminderPhoto:nodeContentValue];
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
        [nsString appendString:@"<Reminder>" ];
    [nsString appendFormat:@"<ReminderID>%d</ReminderID>" , [self reminderID]];
    [nsString appendFormat:@"<categoryID>%d</categoryID>" , [self categoryID]];
    if (self.eventName != nil) {
        [nsString appendFormat:@"<EventName>%@</EventName>" , [self eventName]];
    }
    if (self.eventAlarm != nil) {
        [nsString appendFormat:@"<EventAlarm>%@</EventAlarm>" , [self eventAlarm]];
    }
    if (self.eventNote != nil) {
        [nsString appendFormat:@"<EventNote>%@</EventNote>" , [self eventNote]];
    }
    if (self.eventRecurring != nil) {
        [nsString appendFormat:@"<EventRecurring>%@</EventRecurring>" , [self eventRecurring]];
    }
    if (self.reminderPhoto != nil) {
        [nsString appendFormat:@"<reminderPhoto>%@</reminderPhoto>",[self.reminderPhoto base64EncodedString]];
    }
    if (addNameWrap == YES)
        [nsString appendString:@"</Reminder>" ];
    return nsString;
}
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.reminderID = [decoder decodeInt32ForKey:@"reminderID"];
        self.categoryID = [decoder decodeInt32ForKey:@"categoryID"];
        self.eventName = [decoder decodeObjectForKey:@"eventName"];
        self.eventAlarm = [decoder decodeObjectForKey:@"eventAlarm"];
        self.eventNote = [decoder decodeObjectForKey:@"eventNote"];
        self.eventRecurring = [decoder decodeObjectForKey:@"eventRecurring"];
        self.reminderPhoto = [decoder decodeObjectForKey:@"reminderPhoto"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:self.reminderID forKey:@"reminderID"];
    [encoder encodeInt32:self.categoryID forKey:@"categoryID"];
    [encoder encodeObject:self.eventName forKey:@"eventName"];
    [encoder encodeObject:self.eventAlarm forKey:@"eventAlarm"];
    [encoder encodeObject:self.eventNote forKey:@"eventNote"];
    [encoder encodeObject:self.eventRecurring forKey:@"eventRecurring"];
    [encoder encodeObject:self.reminderPhoto forKey:@"reminderPhoto"];
}
-(id)copyWithZone:(NSZone *)zone {
    Reminder *finalCopy = [[[self class] allocWithZone: zone] init];
    
    finalCopy.reminderID = self.reminderID;
    
    finalCopy.categoryID = self.categoryID;
    
    NSString *copy3 = [self.eventName copy];
    finalCopy.eventName = copy3;
    
    finalCopy.eventAlarm = self.eventAlarm;
    
    NSString *copy5 = [self.eventNote copy];
    finalCopy.eventNote = copy5;
    
    NSString *copy6 = [self.eventRecurring copy];
    finalCopy.eventRecurring = copy6;
    
    NSData *cpy7 = [self.reminderPhoto copy];
    finalCopy.reminderPhoto = cpy7;
    
    return finalCopy;
}

@end
