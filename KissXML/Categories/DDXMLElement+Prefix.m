//
//  DDXMLElement+Prefix.m
//  KissXML
//
//  Created by Andrew Mostello on 10/6/16.
//
//

#import "DDXMLElement+Prefix.h"

#import "DDXMLPrivate.h"

@implementation DDXMLElement (Prefix)

- (NSString *)findPrefixForUri:(NSString *)URI
{
    return [self _recursiveResolvePrefixForURI:URI
                                        atNode:(xmlNodePtr)genericPtr];
}

- (NSDictionary <NSString *, DDXMLNode *> *)existingPrefixesKeyedOnNamespaceURI
{
    NSMutableDictionary *namespaces = [NSMutableDictionary dictionaryWithCapacity:20];
    
    DDXMLElement *currentElementExamined = self;
    
    while (currentElementExamined != nil)
    {
        if ([currentElementExamined isKindOfClass:[DDXMLElement class]])
        {
            for (DDXMLNode *namespace in currentElementExamined.namespaces)
            {
                if (!namespaces[namespace.stringValue]) {
                    namespaces[namespace.stringValue] = namespace;
                }
            }
        }
        
        currentElementExamined = (DDXMLElement *)currentElementExamined.parent;
    }
    
    return [namespaces copy];
}

- (NSString *)prefixWithPrefixIndex:(int)prefixIndex
{
    return [NSString stringWithFormat:@"ns%i", prefixIndex];
}

- (void)setPrefixWithNamespaceURI:(NSString *)namespaceURI
{
    if ([namespaceURI length] > 0)
    {
        NSString *prefix = [self findPrefixForUri:namespaceURI];
        
        if (!prefix)
        {
            int prefixIndex = 0;
            
            while ([self _recursiveResolveNamespaceForPrefix:[self prefixWithPrefixIndex:prefixIndex] atNode:(xmlNodePtr)genericPtr])
            {
                prefixIndex++;
            }
            
            DDXMLNode *namespace = [DDXMLNode namespaceWithName:[self prefixWithPrefixIndex:prefixIndex]
                                                    stringValue:namespaceURI];
            
            DDXMLElement *element = self;
            
            if ([self.parent isKindOfClass:[DDXMLElement class]])
                element = (DDXMLElement *)self.parent;
            
            [element addNamespace:namespace];
            
            prefix = namespace.name;
        }
        
        if ([prefix length] > 0) {
            self.name = [NSString stringWithFormat:@"%@:%@", prefix, self.name];
        }
    }
}

- (void)setPrefix:(NSString *)prefix localName:(NSString *)localName
{
    if (![prefix length]) {
        self.name = [NSString string];
    } else {
        self.name = [NSString stringWithFormat:@"%@:", prefix];
    }
    
    if ([localName length] > 0) {
        self.name = [self.name stringByAppendingString:localName];
    }
}

- (void)setLocalName:(NSString *)localName
{
    [self setPrefix:self.prefix localName:localName];
}

- (void)setPrefix:(NSString *)prefix
{
    [self setPrefix:prefix localName:self.localName];
}

- (NSString *)URIFromSelfOrPrefix
{
    if (self.URI) {
        return self.URI;
    }
    
    return [[self resolveNamespaceForName:self.name] stringValue];
}

- (DDXMLNode *)attributeForLocalName:(NSString *)localName URI:(NSString *)URI
{
    NSString *name = [localName copy];
    
    if (URI.length > 0)
    {
        NSString *prefix = [self findPrefixForUri:URI];
        
        if (prefix.length) {
            name = [NSString stringWithFormat:@"%@:%@", prefix, localName];
        }
    }
    
    return [self attributeForName:name];
}

@end
