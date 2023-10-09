//
//  App+DI.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 09..
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            ScanDocumentViewModel()
        }
        .scope(.application)
    }
}
