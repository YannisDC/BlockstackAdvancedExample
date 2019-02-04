//
//  LikesUseCase.swift
//  FirebasePlatform
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase

final class LikesUseCase: Core.LikesUseCase {
    private let scheduler: OperationQueueScheduler
    private let ref: DatabaseReference
    
    public init(reference: DatabaseReference) {
        self.scheduler = OperationQueueScheduler(operationQueue: OperationQueue.init())
        self.ref = reference
    }
    
    func save(like: Like) -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                guard let user = Auth.auth().currentUser else {
                    maybe(.completed)
                    return Disposables.create()
                }
                /*
                 Here you can upload the image and then use a custom encoder that doesn't include the image but adds a filepath of where the image is stored.
 
                do {
                    let jsonData = try JSONEncoder().encode(like)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    print(jsonString)
                } catch { print(error) }
                 */
                // TODO: Map Core struct to Firebase
                self.ref.child("likes").child(user.uid).setValue(["like": like.description]) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                    }
                    maybe(.success(""))
                }
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<Like> {
        return Single.deferred {
            return Single<Like>.create { single in
                single(.success(Like(description: "",
                                     image: nil,
                                     tags: [])))
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func query(uuid: String, username: String) -> Single<Like> {
        return Single.deferred {
            return Single<Like>.create { single in
                single(.success(Like(description: "",
                                     image: nil,
                                     tags: [])))
                return Disposables.create()
            }
            }.subscribeOn(scheduler)
    }
    
    func delete(like: Like) -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func queryAll() -> Observable<[Like]> {
        
        let maybe = Maybe.deferred {
            return Maybe<[Like]>.create { maybe in
                guard let user = Auth.auth().currentUser else {
                    maybe(.completed)
                    return Disposables.create()
                }
                // TODO: Map Core struct to Firebase
                self.ref.child("likes").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let description = value?["like"] as? String ?? ""
                    let like = Like(description: description, image: nil, tags: [])
                    
                    maybe(.success([like]))
                }) { (error) in
                    print(error.localizedDescription)
                    maybe(.completed)
                }
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
        
        return maybe.asObservable()
    }
    
    func queryAll(username: String) -> Observable<[Like]> {
        
        let maybe = Maybe.deferred {
            return Maybe<[Like]>.create { maybe in
                guard let user = Auth.auth().currentUser else {
                    maybe(.completed)
                    return Disposables.create()
                }
                
                
                // TODO: Map Core struct to Firebase
                self.ref.child("likes").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let description = value?["like"] as? String ?? ""
                    let like = Like(description: description, image: nil, tags: [])
                    
                    maybe(.success([like]))
                }) { (error) in
                    print(error.localizedDescription)
                    maybe(.completed)
                }
                return Disposables.create()
            }
            }.subscribeOn(scheduler)
        
        return maybe.asObservable()
    }
}
