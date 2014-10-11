//
//  NSDictionary+IQ_ParseSDKAttributes.m
// https://github.com/hackiftekhar/IQParseSDK
// Copyright (c) 2013-14 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "NSDictionary+IQ_ParseSDKAttributes.h"
#import "IQPFHTTPServiceConstants.h"

@implementation NSObject (Serialize)

-(id)parseSDKSerializeAttribute
{
    //Handle NSDate
    if ([self isKindOfClass:[NSDate class]])
    {
        NSDate *date = (NSDate*)self;
        return [date serializedAttribute];
    }
    //Handle NSData
    else if ([self isKindOfClass:[NSData class]])
    {
        NSData *data = (NSData*)self;
        return [data base64EncodedString];
    }
    //Handle IQ_PFFile
    else if ([self isKindOfClass:[IQ_PFFile class]])
    {
        IQ_PFFile *file = (IQ_PFFile*)self;
        return [file coreSerializedAttribute];
    }
    //Handle IQ_PFObject Pointers
    else if ([self isKindOfClass:[IQ_PFObject class]])
    {
        IQ_PFObject *object = (IQ_PFObject*)self;
        return [object coreSerializedAttribute];
    }
    //Handle IQ_PFGeoPoint Pointers
    else if ([self isKindOfClass:[IQ_PFGeoPoint class]])
    {
        IQ_PFGeoPoint *geoPoint = (IQ_PFGeoPoint*)self;
        return [geoPoint coreSerializedAttribute];
    }
    //Handle IQ_PFRelation Pointers
    else if ([self isKindOfClass:[IQ_PFRelation class]])
    {
        IQ_PFRelation *relation = (IQ_PFRelation*)self;
        return [relation coreSerializedAttribute];
    }
    else
    {
        return self;
    }
}

-(id)parseSDKDeserializeAttribute
{
    if ([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *attribute = (NSDictionary*)self;
        //Handle NSDate
        if ([[attribute objectForKey:kParse__TypeKey] isEqualToString:kParseDateKey])
        {
            NSString *stringDate = [attribute objectForKey:kParseISOKey];
            return [stringDate parseSDKDate];
        }
        //Handle NSData
        else if ([[attribute objectForKey:kParse__TypeKey] isEqualToString:kParseBytesKey])
        {
            NSString *stringBase64 = [attribute objectForKey:kParseBase64Key];
            return [stringBase64 base64DecodedData];
        }
        //Handle IQ_PFFile
        else if ([[attribute objectForKey:kParse__TypeKey] isEqualToString:kParseFileKey])
        {
            IQ_PFFile *file = [[IQ_PFFile alloc] init];
            [file serializeAttributes:attribute];
            return file;
        }
        //Handle IQ_PFObject Pointers
        else if ([[attribute objectForKey:kParse__TypeKey] isEqualToString:kParsePointerKey])
        {
            IQ_PFObject *object = [IQ_PFObject objectWithoutDataWithClassName:[attribute objectForKey:kParseClassNameKey] objectId:[attribute objectForKey:kParseObjectIdKey]];
            return object;
        }
        //Handle IQ_PFGeoPoint Pointers
        else if ([[attribute objectForKey:kParse__TypeKey] isEqualToString:kParseGeoPointKey])
        {
            IQ_PFGeoPoint *geoPoint = [IQ_PFGeoPoint geoPointWithLatitude:[[attribute objectForKey:kParseLatitudeKey] doubleValue] longitude:[[attribute objectForKey:kParseLongitudeKey] doubleValue]];
            return geoPoint;
        }
        //Handle IQ_PFRelation Pointers
        else if ([[attribute objectForKey:kParse__TypeKey] isEqualToString:kParseRelationKey])
        {
            IQ_PFRelation *relation = [[IQ_PFRelation alloc] init];
            relation.targetClass = [attribute objectForKey:kParseClassNameKey];
            return relation;
        }
    }
    else
    {
        return self;
    }
}

@end

@implementation NSDateFormatter (IQ_ParseSDKAttributes)

+ (NSDateFormatter *)parseSDKDateFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = dictionary[@"iso"];
    
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dictionary[@"iso"] = formatter;
    }
    return formatter;
}

@end


@implementation NSDictionary (IQ_ParseSDKAttributes)

//Batch operation creation
+(NSDictionary*)batchOperationWithMethod:(NSString*)method path:(NSString*)path body:(NSDictionary*)body
{
    return @{kParseMethodKey: method, kParsePathKey: path, kParseBodyKey:body};
}

@end


@implementation NSArray (IQ_ParseSDKAttributes)

-(NSDictionary*)addAttribute
{
    return @{kParse__OpKey:@"Add",      kParseObjectsKey:self};
}

-(NSDictionary*)addUniqueAttribute
{
    return @{kParse__OpKey:@"AddUnique",kParseObjectsKey:self};
}

-(NSDictionary*)removeAttribute
{
    return @{kParse__OpKey:@"Remove",   kParseObjectsKey:self};
}

@end


@implementation NSString (IQ_ParseSDKAttributes)

-(NSDate*)parseSDKDate
{
    return [[NSDateFormatter parseSDKDateFormatter] dateFromString:self];
}

@end


@implementation NSNumber (IQ_ParseSDKAttributes)

+(NSDictionary *)incrementAttribute
{
    return [@1 incrementAttribute];
}

-(NSDictionary *)incrementAttribute;
{
    return @{kParse__OpKey:@"Increment",@"amount":self};
}

@end


@implementation NSDate (IQ_ParseSDKAttributes)

-(NSDictionary*)serializedAttribute
{
    return @{kParse__TypeKey: kParseDateKey,kParseISOKey:[self parseSDKString]};
}

-(NSString*)parseSDKString
{
    return [[NSDateFormatter parseSDKDateFormatter] stringFromDate:self];
}

@end


@implementation NSData (IQ_Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (![string length]) return nil;
    
    NSData *decoded = nil;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
        decoded = [[self alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
    }
    else
        
#endif
        
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    return [decoded length]? decoded: nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    if (![self length]) return nil;
    
    NSString *encoded = nil;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        encoded = [self base64Encoding];
    }
    else
#pragma GCC diagnostic pop
#endif
        
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    
    return result;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}

@end


@implementation NSString (IQ_Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
    return [NSString stringWithBase64EncodedString:self];
}

- (NSData *)base64DecodedData
{
    return [NSData dataWithBase64EncodedString:self];
}

@end

