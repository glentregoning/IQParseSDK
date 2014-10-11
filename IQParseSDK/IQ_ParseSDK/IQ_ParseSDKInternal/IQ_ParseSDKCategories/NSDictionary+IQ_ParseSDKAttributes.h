//
//  NSDictionary+IQ_ParseSDKAttributes.h
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

#import <Foundation/Foundation.h>

@interface NSObject (Serialize)

-(id)parseSDKSerializeAttribute;
-(id)parseSDKDeserializeAttribute;

@end

@interface NSDateFormatter (IQ_ParseSDKAttributes)

@end

@interface NSDictionary (IQ_ParseSDKAttributes)

//Batch operation creation
+(NSDictionary*)batchOperationWithMethod:(NSString*)method path:(NSString*)path body:(NSDictionary*)body;

@end


@interface NSArray (IQ_ParseSDKAttributes)

-(NSDictionary*)addAttribute;

-(NSDictionary*)addUniqueAttribute;

-(NSDictionary*)removeAttribute;

@end


@interface NSString (IQ_ParseSDKAttributes)

-(NSDate*)parseSDKDate;

@end


@interface NSNumber (IQ_ParseSDKAttributes)

//Increment attribute by 1
+(NSDictionary *)incrementAttribute;

//Increment/Decrement Number Attribute
-(NSDictionary *)incrementAttribute;

@end


@interface NSDate (IQ_ParseSDKAttributes)

-(NSDictionary*)serializedAttribute;
-(NSString*)parseSDKString;

@end


@interface NSData (IQ_Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end


@interface NSString (IQ_Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end

