//
//  Router.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Observation
import SwiftUI

@Observable
final class Router {
    var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
