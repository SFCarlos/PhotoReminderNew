//
//  HTAutocompleteManager.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTAutocompleteManager.h"
#import "DatabaseHelper.h"
static HTAutocompleteManager *sharedManager;

@implementation HTAutocompleteManager
+ (HTAutocompleteManager *)sharedManager
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[HTAutocompleteManager alloc] init]; });
    
	return sharedManager;
}
-(NSInteger*)retrieveIDCATFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase
{
    if (textField.autocompleteType == HTAutocompleteTypeEmail)
    {
       DatabaseHelper* dao = [[DatabaseHelper alloc] init];
        static dispatch_once_t onceToken;
        NSInteger * idcat = [self retrieveIDCATFromUserDefaults];
         NSArray *autocompleteArray = [dao getHistoryList:idcat];
        dispatch_once(&onceToken, ^
                      {
                          //autocompleteArray =[dao getHistoryList:idcat] ;
                      });
        
        // Check that text field contains an @
        NSRange atSignRange = [prefix rangeOfString:@"@"];
        if (atSignRange.location == NSNotFound)
        {
            return @"";
        }
        
        // Stop autocomplete if user types dot after domain
        NSString *domainAndTLD = [prefix substringFromIndex:atSignRange.location];
        NSRange rangeOfDot = [domainAndTLD rangeOfString:@"."];
        if (rangeOfDot.location != NSNotFound)
        {
            return @"";
        }
        
        // Check that there aren't two @-signs
        NSArray *textComponents = [prefix componentsSeparatedByString:@"@"];
        if ([textComponents count] > 2)
        {
            return @"";
        }
        
        if ([textComponents count] > 1)
        {
            // If no domain is entered, use the first domain in the list
            if ([(NSString *)textComponents[1] length] == 0)
            {
                return [autocompleteArray objectAtIndex:0];
            }
            
            NSString *textAfterAtSign = textComponents[1];
            
            NSString *stringToLookFor;
            if (ignoreCase)
            {
                stringToLookFor = [textAfterAtSign lowercaseString];
            }
            else
            {
                stringToLookFor = textAfterAtSign;
            }
            
            for (NSString *stringFromReference in autocompleteArray)
            {
                NSString *stringToCompare;
                if (ignoreCase)
                {
                    stringToCompare = [stringFromReference lowercaseString];
                }
                else
                {
                    stringToCompare = stringFromReference;
                }
                
                if ([stringToCompare hasPrefix:stringToLookFor])
                {
                    return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
                }
                
            }
        }
    }
    else if (textField.autocompleteType == HTAutocompleteTypeColor)
    {
        DatabaseHelper* dao = [[DatabaseHelper alloc] init];

        static dispatch_once_t colorOnceToken;
     
        NSInteger * idcat = [self retrieveIDCATFromUserDefaults];
        NSArray *colorAutocompleteArray = [dao getHistoryList:idcat];
        dispatch_once(&colorOnceToken, ^
        {
          /*  colorAutocompleteArray = @[ @"Alfred",
                                        @"Beth",
                                        @"Carlos",
                                        @"Daniel",
                                        @"Ethan",
                                        @"Fred",
                                        @"George",
                                        @"Helen",
                                        @"Inis",
                                        @"Jennifer",
                                        @"Kylie",
                                        @"Liam",
                                        @"Melissa",
                                        @"Noah",
                                        @"Omar",
                                        @"Penelope",
                                        @"Quan",
                                        @"Rachel",
                                        @"Seth",
                                        @"Timothy",
                                        @"Ulga",
                                        @"Vanessa",
                                        @"William",
                                        @"Xao",
                                        @"Yilton",
                                        @"Zander"];
        */});

        NSString *stringToLookFor;
		NSArray *componentsString = [prefix componentsSeparatedByString:@","];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase)
        {
            stringToLookFor = [prefixLastComponent lowercaseString];
        }
        else
        {
            stringToLookFor = prefixLastComponent;
        }
        
        for (NSString *stringFromReference in colorAutocompleteArray)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }
    
    return @"";
}

@end
