//
//  CoreDataController.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 04..
//

import CoreData
import UIKit

final class CoreDataController: ObservableObject {
    // MARK: - Types

    private struct Consts {
        struct Name {
            static let coreDataEntity = "ResultModel"
            static let innerEntitiyName = "LocalData"
        }
    }

    typealias TextRecognizerModel = TextRecognizer.RecognizedModel

    // MARK: - Properties

    let container = NSPersistentContainer(name: Consts.Name.coreDataEntity)

    // MARK: - Initialization

    init() {
        setupContainers()
    }

    // MARK: - Functions

    func saveContext(context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch {
                print("LOG | ERROR: \(error)")
            }
        }
    }

    func saveData(context: NSManagedObjectContext, _ refModel: TextRecognizerModel) {
        guard let cgImage = refModel.cgImage, let data = UIImage(cgImage: cgImage).pngData() else { return }

        context.perform {
            let model = LocalData(context: context)

            model.imageData = data
            model.imageText = refModel.resultingText
            model.imageId = UUID(uuidString: refModel.resultingText)

            print("LOG | NEW MODEL HAS ADDED: \(model)")

            self.saveContext(context: context)
        }
    }

    func reset(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<LocalData> = LocalData.fetchRequest()

        do {
            let items = try context.fetch(fetchRequest)

            for item in items {
                context.delete(item)
            }

            self.saveContext(context: context)

        } catch {
            print("LOG | ERROR: \(error)")
        }
    }

    private func setupContainers() {
        container.loadPersistentStores { description, error in
            precondition(error == nil)

            print("LOG | LOADED SUCCESSFULLY | DESCRIPTION: \(description)") // TODO: Logger
        }
    }
}
