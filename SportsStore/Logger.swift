//
//  Logger.swift
//  SportsStore
//
//  Created by Tim Pryor on 2015-09-20.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//


/*
Prototype pattern creates new objects by copying an existing object (the prototype)
Benefit: hide the code that creates objects from the components that use them
Components don't need to know which class or struct is required to create a new object, 
    don't need to know the details of initializers and don't need to change when subclasses
    are created and instantiated
Pattern can also be used to avoid repeating expensive initialization each time a new object created

Useful when writing a component that needs to create new instances of objects without creating
    a dependency on the class initializer

*/



import Foundation


/*
    Read ops are contained in ordinary blocks and write ops
    are in barrier blocks. 
    When a barrier block reaches the head of the queue, GCD waits until
    all of the read ops that are still in process are completed.
    GCD then executes the barrier block, which modifies the array
    and does not process any subsequent blocks until the barrier block has completed.
    Once the barrier block is complete, the following items in the queue
    are processed as normal and in parallel until the next barrier block comes along
    
    Using a barrier changes a concurrent queue into a serial queue for as long
    as it takes to process the barrier block, after which it returns to being 
    a concurrent queue again.
    Using a GCD barrier makes it easy to create a reader/writer lock.

*/



let productLogger = Logger<Product>(callback: {p in
        println("Change: \(p.name)\(p.stockLevel) items in stock")
    })


final class Logger<T where T: NSObject, T: NSCopying> {
    
    // Doesn't work: static stored properties not yet supported in generic types
   /* static let productLogger = Logger<Product>(callback: {p in
        println("Change: \(p.name)\(p.stockLevel) items in stock")
    }) */
    
    var dataItems:[T] = []
    var callback:(T) -> Void
    var arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_CONCURRENT)
    var callbackQ = dispatch_queue_create("callbackQ", DISPATCH_QUEUE_SERIAL)
    
    private init(callback:T -> Void, protect: Bool = true) {
        self.callback = callback
        if (protect) {
            self.callback = {(item:T) in
                dispatch_sync(self.callbackQ) {
                    callback(item)
                }
            }
        
        }
    }
    
    func logItem(item:T) {
        // adds a special block to the queue that changes its behavior
        // the queue will not start executing the barrier block until
        // all the blocks ahead of it have completed and will not process
        // any subsequent blocks until the barrier itself has completed
        dispatch_barrier_async(arrayQ) {
            self.dataItems.append(item.copy() as! T)
            self.callback(item)
        }
    }
    
    func processItems(callback:T -> Void) {
        // use the dispatch_sync funciont to add a block of work
        // that enumerates the array, waiting until the block has 
        // completed before allowing the method to return
        dispatch_sync(arrayQ,  {() in
            for item in self.dataItems {
                self.callback(item)
            }
        })
    }
    
}
