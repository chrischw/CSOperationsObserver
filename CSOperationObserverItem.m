//
//  CSOperationObserverItem.m
//
//  Created by Christian Schwarz on 09.07.13.
//

#import "CSOperationObserverItem.h"

@implementation CSOperationObserverItem
@dynamic relatedIndexPath;

- (NSMutableDictionary *)userInfo
{
    if (!_userInfo) {
        _userInfo = [NSMutableDictionary dictionary];
    }
    return _userInfo;
}

- (NSIndexPath *)relatedIndexPath
{
    return [self.userInfo valueForKey:kCSOperationObserverItemRelatedIndexPathKey];
}

- (void)setRelatedIndexPath:(NSIndexPath *)relatedIndexPath
{
    [self.userInfo setValue:relatedIndexPath forKey:kCSOperationObserverItemRelatedIndexPathKey];
}

@end
