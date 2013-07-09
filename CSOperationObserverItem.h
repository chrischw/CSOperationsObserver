//
//  CSOperationObserverItem.h
//
//  Created by Christian Schwarz on 09.07.13.
//

#import <Foundation/Foundation.h>

static NSString* const kCSOperationObserverItemRelatedIndexPathKey = @"kCSOperationObserverItemRelatedIndexPath";

@interface CSOperationObserverItem : NSObject

@property (nonatomic, strong) NSOperation* operation;
@property (nonatomic, strong) NSMutableDictionary* userInfo;

///Convenience accessor to userInfo variable
@property (nonatomic) NSIndexPath* relatedIndexPath;

@end
