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

        register {
            ImageAnalyzer.shared
        }
        .scope(.application)

        register {
            HapticManager.shared
        }
        .scope(.application)

        register {
            TabHosterViewViewModel.shared
        }
        .scope(.application)

        register {
            FrameManager.shared
        }
        .scope(.application)

        register {
            CameraManager.shared
        }
        .scope(.application)

        register {
            SynthesizerManager.shared
        }
        .scope(.application)

        register {
            TabProfileLandingViewModel()
        }
        .scope(.application)

        register {
            TextRecognizer.shared
        }
        .scope(.application)

        register {
            AuthenticationInteractor.shared
        }
        .scope(.application)

        register {
            FireStoreDatabaseInteractor.shared
        }
        .scope(.application)

        register {
            AuthenticationViewModel()
        }
        .scope(.application)
    }
}
