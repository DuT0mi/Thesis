//
//  DemoData.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 27..
//

import Foundation

/// A class for the Item in the Page Controlr
final class DemoData: ObservableObject {
    // MARK: - Properties

    @Published var demoItems: [DemoItem]?

    // MARK: - Initialization

    init() {
        demoItems = load(from: "demoData.json")
    }

    // MARK: - Functions

    func load<T>(from filename: String) -> T where T: Decodable {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
