//
//  DDXMLElement+Prefix.h
//  KissXML
//
//  Created by Andrew Mostello on 10/6/16.
//
//

#import "DDXMLElement.h"

@class DDXMLNode;

@interface DDXMLElement (Prefix)

- (nonnull NSDictionary <NSString *, DDXMLNode *> *)existingPrefixesKeyedOnNamespaceURI;

- (void)setPrefixWithNamespaceURI:(nonnull NSString *)namespaceURI;

- (void)setPrefix:(nullable NSString *)prefix localName:(nullable NSString *)localName;
- (void)setLocalName:(nullable NSString *)localName;
- (void)setPrefix:(nullable NSString *)prefix;

- (nullable NSString *)URIFromSelfOrPrefix;

- (nullable DDXMLNode *)attributeForLocalName:(nonnull NSString *)localName URI:(nullable NSString *)URI;

@end
