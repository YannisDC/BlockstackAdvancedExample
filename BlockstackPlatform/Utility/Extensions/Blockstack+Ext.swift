//
//  Blockstack+Ext.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 16/11/2018.
//  Copyright © 2018 sergdort. All rights reserved.
//

import Foundation
import RxSwift
import Blockstack

extension Reactive where Base: Blockstack {
    func save(path: String, text: String, encrypt: Bool = false) -> Single<String?> {
        return Single.create { single in
            self.base.putFile(to: path, text: text, encrypt: encrypt) { (publicURL, error)  in
                if let error = error {
                    single(.error(error))
                } else {
                    single(.success(publicURL))
                }
            }
            return Disposables.create()
        }
    }
    
    func save(path: String, bytes: Bytes, encrypt: Bool = false) -> Single<String?> {
        return Single.create { single in
            self.base.putFile(to: path, bytes: bytes, encrypt: encrypt) { (publicURL, error)  in
                if let error = error {
                    single(.error(error))
                } else {
                    single(.success(publicURL))
                }
            }
            return Disposables.create()
        }
    }
    
    func load(path: String, decrypt: Bool) -> Single<Any?> {
        return Single.create { single in
            self.base.getFile(at: path, decrypt: decrypt) { (response, error)  in
                if let error = error {
                    single(.error(error))
                } else {
                    single(.success(response))
                }
            }
            return Disposables.create()
        }
    }

    func signIn(with configuration: Blockstack.Configuration) -> Single<Void> {
        return Single.create { single in
            self.base.signIn(redirectURI: configuration.redirectURI,
                             appDomain: configuration.appDomain,
                             scopes: configuration.scopes) { authResult in
                                switch authResult {
                                case .success(let userData):
                                    single(.success(()))
                                case .cancelled:
//                                        observer.onError(PerfectDudeError.custom(message: "Sign in cancelled"))
                                    print("Sign in cancelled")
                                case .failed(let error):
                                    single(.error(error!))
//                                        observer.onError(PerfectDudeError.custom(message: "Sign in failed, error: \(error)"))
                                }
                                
            }
            return Disposables.create()
        }
    }
    
    func isUserSignedIn() -> Bool {
        return self.base.isUserSignedIn()
    }
    
    func signUserOut() {
        self.base.signUserOut()
    }
    
    func getUserAppFileURL() {
        //getUserAppFileURL(at path: String, username: String, appOrigin: String, zoneFileLookupURL: URL = URL(string: "http://localhost:6270/v1/names/")!, completion: @escaping (URL?) -> ())
    }
    
    
    
    //    func saveImage(path: String, image: UIImage, encrypt: Bool) -> Observable<String?> {
    //        if encrypt {
    //            guard let imageData = image.jpegData(compressionQuality: 0.5)?.bytes else {
    //                return Observable.just(nil)
    //            }
    //            return self.blockstack.rx.save(path: path, bytes: imageData, encrypt: encrypt)
    //        } else {
    //            guard let imageData = image.pngData()?.bytes else {
    //                return Observable.just(nil)
    //            }
    //            return self.blockstack.rx.save(path: path, bytes: imageData, encrypt: encrypt)
    //        }
    //    }
    //
    //    func loadImage(path: String, decrypt: Bool) -> Observable<UIImage?> {
    //        return self.blockstack.rx.load(path: path, decrypt: decrypt).map { (response) -> UIImage? in
    //            let decrypted = response as? DecryptedValue
    //            if let imageBytes = decrypted?.bytes {
    //                let imageData = Data(bytes: imageBytes)
    //                let image = UIImage.init(data: imageData)
    //                return image
    //            }
    //            return nil
    //        }
    //    }
}


extension Blockstack {
    public struct Configuration {
        
        public init(redirectURI: String,
                    appDomain: URL,
                    manifestURI: URL? = nil,
                    scopes: Array<String> = ["store_write"]) {
            self.redirectURI = redirectURI
            self.appDomain = appDomain
            self.scopes = scopes
        }
        
        public var redirectURI: String
        public var appDomain: URL
        public var scopes: Array<String>
        
    }
}

extension PrimitiveSequence where TraitType == SingleTrait {
    public func asMaybe() -> PrimitiveSequence<MaybeTrait, Element> {
        return self.asObservable().asMaybe()
    }
    
    public func asCompletable() -> PrimitiveSequence<CompletableTrait, Never> {
        return self.asObservable().flatMap { _ in Observable<Never>.empty() }.asCompletable()
    }
}

extension PrimitiveSequence where TraitType == CompletableTrait, ElementType == Swift.Never {
    public func asMaybe() -> PrimitiveSequence<MaybeTrait, Element> {
        return self.asObservable().asMaybe()
    }
}
