//
//  MoodModelController.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import Foundation
import Combine

class EntryModelController: ObservableObject {
    
    //MARK: - Properties
    @Published var entries: [Entry] = []
        
    init() {
        loadFromPersistentStore()
    }
    
    
    //MARK: - CRUD Functions
    func createEntry(emotion: Emotion, comment: String?, date: Date) {

        let newEntry = Entry(emotion: emotion, comment: comment, date: date)
        
        entries.append(newEntry)
        saveToPersistentStore()
    
    }
    
    func deleteEntry(at offset: IndexSet) {
        
        guard let index = Array(offset).first else { return }
     print("INDEX: \(index)")
        entries.remove(at: index)
        
        saveToPersistentStore()
    }
    
    
    func updateEntryComment(entry: Entry, comment: String) {
        if let index = entries.firstIndex(of: entry) {
            var entry = entries[index]
            entry.comment = comment
            
            entries[index] = entry
            saveToPersistentStore()
        }
    }
    
    // MARK: Save, Load from Persistent
    private var persistentFileURL: URL? {
      let fileManager = FileManager.default
      guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
       
      return documents.appendingPathComponent("entry.plist")
    }
    
    func saveToPersistentStore() {
        
        // Stars -> Data -> Plist
        guard let url = persistentFileURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(entries)
            try data.write(to: url)
        } catch {
            print("Error saving stars data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        
        // Plist -> Data -> Stars
        let fileManager = FileManager.default
        guard let url = persistentFileURL, fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            entries = try decoder.decode([Entry].self, from: data)
        } catch {
            print("error loading stars data: \(error)")
        }
    }
}
