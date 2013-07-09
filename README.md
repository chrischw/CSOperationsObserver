#CSOperationsObserver

CSOperationsObserver is a little helper class that wraps KVO code for 
registering changes of the state of NSOperations.

##Example usage:

- You get an NSOperation from your networking code. Your controller has a property `operationsObserver`

  ```objc
  id relatedData = [...]
	AFHTTPRequestOperation* operation = [...]
	[self.operationsObserver observeOperation:operation
		 						  identifier:@"myJob"
								    userInfo:@{@"relatedData":relatedData}];
  [operation start];
	```
  
- In the same controller, you implement methods from the `<CSOperationObserverProtocol>`

  ```objc
  - (void)operationsObserver:(CSOperationsObserver*)observer
      didObserveCancellationOrFinishingOfOperationItem:(CSOperationObserverItem*)item
              withIdentifier:(NSString*)identifier
  {
	  //Do whatever you want
	  if ([identifier isEqualToString:@"myJob"]) {
		  id relatedData = item.userInfo[@"relatedData"];
		  [...]
	  }
  }
  ```

##License

Do whatever you want with the code. Anyhow, an attribution like the following would be nice:

*This app uses CSOperationsObserver (https://github.com/chrischw/CSOperationObserver)*
