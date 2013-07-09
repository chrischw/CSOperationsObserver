//
//  CSOperationsObserver.m
//
//  Created by Christian Schwarz on 09.07.13.
//

#import "CSOperationsObserver.h"

@interface CSOperationsObserver ()

@property (nonatomic, strong) NSMutableDictionary* currentObservations;

@property (nonatomic, weak) id<CSOperationsObserverProtocol> delegate;

@end

@implementation CSOperationsObserver

- (id)initWithDelegate:(id<CSOperationsObserverProtocol>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.currentObservations = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public

- (CSOperationObserverItem*)observeOperation:(NSOperation*)operation identifier:(NSString*)identifier userInfo:(NSDictionary*)userInfo
{
    NSParameterAssert([operation isKindOfClass:[NSOperation class]]);
    NSParameterAssert([identifier isKindOfClass:[NSString class]]);
    NSParameterAssert([userInfo isKindOfClass:[NSDictionary class]]);
    
    if ([self hasIdentifier:identifier]) {
        return nil;
    }
    
    for (CSOperationObserverItem* item in self.currentObservations) {
        if ([item.operation isEqual:operation]) {
            return nil;
        }
    }
    
    CSOperationObserverItem* item = [CSOperationObserverItem new];
    item.operation = operation;
    item.userInfo = [userInfo mutableCopy];

    [self.currentObservations setValue:item forKey:identifier];
    
    if ([self.delegate respondsToSelector:@selector(operationsObserver:didStartObservingOperationItem:withIdentifier:)]) {
        [self.delegate operationsObserver:self didStartObservingOperationItem:item withIdentifier:identifier];
    }
    
    [item addObserver:self forKeyPath:@"operation.isCancelled" options:NSKeyValueObservingOptionNew context:NULL];
    [item addObserver:self forKeyPath:@"operation.isFinished" options:NSKeyValueObservingOptionNew context:NULL];

    return item;
}

- (CSOperationObserverItem*)observeOperation:(NSOperation*)operation identifier:(NSString*)identifier
{
    return [self observeOperation:operation identifier:identifier userInfo:@{}];
}

- (CSOperationObserverItem*)observeOperation:(NSOperation*)operation relatedToIndexPath:(NSIndexPath*)indexPath identifier:(NSString*)identifier
{
    NSParameterAssert([indexPath isKindOfClass:[NSIndexPath class]]);
    return [self observeOperation:operation identifier:identifier userInfo:@{kCSOperationObserverItemRelatedIndexPathKey:indexPath}];
}

- (CSOperationObserverItem *)operationItemWithIdentifier:(NSString *)identifier
{
    NSParameterAssert([identifier isKindOfClass:[NSString class]]);
    
    if ([self hasIdentifier:identifier]) {
        CSOperationObserverItem* item = [self.currentObservations valueForKey:identifier];
        return item;
    }
    return nil;
}

- (void)cancelOperationWithIdentifier:(NSString*)identifier
{
    if ([self hasIdentifier:identifier]) {
        CSOperationObserverItem* item = self.currentObservations[identifier];
        [item.operation cancel];
    }
}

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([self.delegate respondsToSelector:@selector(operationsObserver:didObserveCancellationOrFinishingOfOperationItem:withIdentifier:)]) {

        CSOperationObserverItem* item = object;
        NSString* identifier = [[self.currentObservations allKeysForObject:item] lastObject];
        
        if (item.operation.isCancelled || item.operation.isFinished) {

            //Remove KVO observation
            [item removeObserver:self forKeyPath:@"operation.isCancelled"];
            [item removeObserver:self forKeyPath:@"operation.isFinished"];
            //Remove from dict
            [self.currentObservations removeObjectForKey:identifier];
            
            [self.delegate operationsObserver:self didObserveCancellationOrFinishingOfOperationItem:item withIdentifier:identifier];

        }
        
    }
    
}

#pragma mark - internal

- (BOOL)hasIdentifier:(NSString*)identifier
{
    NSParameterAssert([identifier isKindOfClass:[NSString class]]);
    return [[self.currentObservations valueForKey:identifier] isKindOfClass:[CSOperationObserverItem class]];
}




@end
