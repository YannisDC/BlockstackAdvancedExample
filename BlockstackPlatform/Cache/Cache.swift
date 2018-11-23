//
//  Cache.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 22/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

protocol Identifiable {
    var uuid: String { get set }
}

protocol Cachable: Codable, Identifiable {}

extension Like: Cachable {}

protocol AbstractCache {
    associatedtype T
    func save(object: T) -> Completable
    func save(objects: [T]) -> Completable
    func fetch(withID id: String) -> Maybe<T>
    func fetchObjects() -> Maybe<[T]>
}

final class Cache<T: Cachable>: AbstractCache {
    enum Error: Swift.Error {
        case saveObject(T)
        case saveObjects([T])
        case fetchObject(T.Type)
        case fetchObjects(T.Type)
    }
    enum FileNames {
        static var objectFileName: String {
            return "\(T.self).dat"
        }
        static var objectsFileName: String {
            return "\(T.self)s.dat"
        }
    }
    
    private let path: String
    private let cacheScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "be.yannisdecleene.Cache.queue")
    
    init(path: String) {
        self.path = path
    }
    
    func save(object: T) -> Completable {
        return Completable.create { (observer) -> Disposable in
            guard let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask).first else {
                    observer(.completed)
                    return Disposables.create()
            }
            let path = url.appendingPathComponent(self.path)
                .appendingPathComponent("\(object.uuid)")
                .appendingPathComponent(FileNames.objectFileName)
            
            do {
                try JSONEncoder().encode(object).write(to: path)
                observer(.completed)
            }
            catch {
                observer(.error(Error.saveObject(object)))
            }
            
            return Disposables.create()
            }.subscribeOn(cacheScheduler)
    }
    
    func save(objects: [T]) -> Completable {
        return Completable.create { (observer) -> Disposable in
            guard let directoryURL = self.directoryURL() else {
                observer(.completed)
                return Disposables.create()
            }
            let path = directoryURL
                .appendingPathComponent(FileNames.objectsFileName)
            self.createDirectoryIfNeeded(at: directoryURL)
            do {
                try JSONEncoder().encode(objects).write(to: path)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            
            return Disposables.create()
            }.subscribeOn(cacheScheduler)
    }
    
    func fetch(withID id: String) -> Maybe<T> {
        return Maybe<T>.create { (observer) -> Disposable in
            guard let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask).first else {
                    observer(.completed)
                    return Disposables.create()
            }
            let path = url.appendingPathComponent(self.path)
                .appendingPathComponent("\(id)")
                .appendingPathComponent(FileNames.objectFileName)
            
            do {
                let dataString = try String(contentsOf: path, encoding: .utf8)
                guard let data = dataString.data(using: .utf8) else {
                    observer(.completed)
                    return Disposables.create()
                }
                
                let entity = try JSONDecoder().decode(T.self, from: data)
                observer(MaybeEvent<T>.success(entity))
                return Disposables.create()

            } catch {
                observer(.error(error))
                return Disposables.create()
            }
        }.subscribeOn(cacheScheduler)
    }
    
    func fetchObjects() -> Maybe<[T]> {
        return Maybe<[T]>.create { (observer) -> Disposable in
            guard let directoryURL = self.directoryURL() else {
                observer(.completed)
                return Disposables.create()
            }
            let fileURL = directoryURL
                .appendingPathComponent(FileNames.objectsFileName)
            do {
                let dataString = try String(contentsOf: fileURL, encoding: .utf8)
                guard let data = dataString.data(using: .utf8) else {
                    observer(.completed)
                    return Disposables.create()
                }
                
                let entities = try JSONDecoder().decode([T].self, from: data)
                observer(MaybeEvent.success(entities.map { $0 }))
                return Disposables.create()
                
            } catch {
                observer(.error(error))
                return Disposables.create()
            }
        }.subscribeOn(cacheScheduler)
    }
    
    private func directoryURL() -> URL? {
        return FileManager.default
            .urls(for: .documentDirectory,
                  in: .userDomainMask)
            .first?
            .appendingPathComponent(path)
    }
    
    private func createDirectoryIfNeeded(at url: URL) {
        do {
            try FileManager.default.createDirectory(at: url,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Cache Error createDirectoryIfNeeded \(error)")
        }
    }
}
