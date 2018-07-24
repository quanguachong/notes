# the notes for notebook-operator

## the probable steps

### main

    1.get config(by clientcmd.BuildConfigFromFlags())
    2.get kubernetes client and notebook client(by NewForConfig)
    3.

### workqueue

    1. Get():Get blocks until it can return an item to be processed. If shutdown = true, the caller should end their goroutine. You must call Done with item when you have finished processing it.

    2. Done():Done marks item as done processing, and if it has been marked as dirty again while it was being processed, it will be re-added to the queue for re-processing.

    3. Forget():Forget indicates that an item is finished being retried.  Doesn't matter whether its for perm failing or for success, we'll stop the rate limiter from tracking it.  This only clears the `rateLimiter`, you still have to call `Done` on the queue.