//
//  DocumentPickerView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import SwiftUI
import UIKit
import VisionKit

struct DocumentPickerView: UIViewControllerRepresentable {
    // MARK: - Type

    typealias Model = TextRecognizer.RecognizedModel

    // MARK: - Properties

    let willStart: (() -> Void)?
    let didFinish: (([Model]) -> Void)?

    // MARK: - Functions

    func makeCoordinator() -> Coordinator {
        Coordinator(documentView: self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let documentVC = VNDocumentCameraViewController()
        documentVC.delegate = context.coordinator

        return documentVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        // MARK: - Properties

        private var documentView: DocumentPickerView

        // MARK: - Initalization

        init(documentView: DocumentPickerView) {
            self.documentView = documentView
        }

        // MARK: - VNDocumentCameraViewControllerDelegate functions

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            TextRecognizer.shared.scan = scan
            TextRecognizer.shared.request(willStart: documentView.willStart, didFinish: documentView.didFinish)
        }
    }
}
