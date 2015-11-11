//
//  NetworkPool.swift
//  SportsStore
//
//  Created by Tim Pryor on 2015-10-08.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation

final class NetworkPool {
    private let connectionCount = 3
    private var connections = [NetworkConnection]()
    private var semaphore: dispatch_semaphore_t
    private var queue: dispatch_queue_t
    //singleton:
    static let sharedInstance = NetworkPool()
    
    private var itemsCreated = 0
    
    
    
    private init() {
        /*
        for _ in 0..<connectionCount {
            connections.append(NetworkConnection())
            
        }*/
        
        semaphore = dispatch_semaphore_create(connectionCount)
        queue = dispatch_queue_create("networkpoolQ", DISPATCH_QUEUE_SERIAL)
    }
    
    
    // gets a connection from the pool
    private func doGetConnection() -> NetworkConnection {
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        var result: NetworkConnection? = nil
        dispatch_sync(queue) {
            
            // lazily create NetworkConnection objects
            if (self.connections.count > 0) {
                result = self.connections.removeAtIndex(0)
            } else if (self.itemsCreated < self.connectionCount) {
                result = NetworkConnection()
                self.itemsCreated++
            }
        }
        return result!
    }
    
    private func doReturnConnection(conn:NetworkConnection) {
        dispatch_async(queue){
            self.connections.append(conn)
            dispatch_semaphore_signal(self.semaphore)
    
        }

    }
    
    class func getConnection() -> NetworkConnection {
        return sharedInstance.doGetConnection()
    }
    
    class func returnConnection(conn: NetworkConnection) {
        sharedInstance.doReturnConnection(conn)
    }
    
    
}