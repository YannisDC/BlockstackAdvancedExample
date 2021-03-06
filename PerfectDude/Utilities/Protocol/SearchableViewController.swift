//
//  SearchableViewController.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchableViewController {
    var searchQuery: PublishSubject<String> { get }
}
