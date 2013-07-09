//
//  CSOperationsObserver.h
//
//  Created by Christian Schwarz on 09.07.13.
//

#import <Foundation/Foundation.h>
#import "CSOperationObserverItem.h"
@class CSOperationsObserver;

@protocol CSOperationsObserverProtocol <NSObject>

@optional
- (void)operationsObserver:(CSOperationsObserver*)observer didStartObservingOperationItem:(CSOperationObserverItem*)item withIdentifier:(NSString*)identifier;
- (void)operationsObserver:(CSOperationsObserver*)observer didObserveCancellationOrFinishingOfOperationItem:(CSOperationObserverItem*)item withIdentifier:(NSString*)identifier;
@end

@interface CSOperationsObserver : NSObject

- (id)initWithDelegate:(id<CSOperationsObserverProtocol>)delegate;

@property (readonly) id<CSOperationsObserverProtocol> delegate;

///Use this method to register any operation.
///NOTE: CSOperationsObserver is intended to observe an operation only once, do not observe an operation twice or try to observe it with a different identifier.
///@return a reference to the then created observer item or nil if the operation could not be created.
- (CSOperationObserverItem*)observeOperation:(NSOperation*)operation identifier:(NSString*)identifier userInfo:(NSDictionary*)userInfo;

///Convenience method for registering an operation without user info
///@return a reference to the then created observer item or nil if the operation could not be created.
- (CSOperationObserverItem*)observeOperation:(NSOperation*)operation identifier:(NSString*)identifier;

///Convenience method for regsitering an operation that is related to an index path
///@return a reference to the then created observer item or nil if the operation could not be created.
- (CSOperationObserverItem*)observeOperation:(NSOperation*)operation relatedToIndexPath:(NSIndexPath*)indexPath identifier:(NSString*)identifier;

///Retrieve an operation item with the identifier.
///@return the operation item associated with the identifier or nil if there is no operation associated with it.
- (CSOperationObserverItem*)operationItemWithIdentifier:(NSString*)identifier;

///A convenience method to cancel an operation using the identifier. If there is no operation associated with the identifier, this method does nothing.
- (void)cancelOperationWithIdentifier:(NSString*)identifier;

@end
