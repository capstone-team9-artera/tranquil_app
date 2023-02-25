//
//  MoodModelController.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import Foundation
import Combine
import CoreData

class EntryModelController: ObservableObject {
    
    //MARK: - Properties
    @Published var entries: [Entry] = []
    
    private let context = PersistenceController.preview.container.viewContext
        
    init() {
        loadFromPersistentStore()
    }
    
    
    //MARK: - CRUD Functions
    func createEntry(emotion: Emotion, comment: String?, date: Date) {
        let newEntry = Entry(emotion: emotion, comment: comment, date: date)
        
        //count and stress value here
        let newCount = JournalCount(context: context)
        let newStressValue = NLPValue(context: context)
        newCount.timestamp = date
        newStressValue.id = newEntry.id
        newStressValue.timestamp = date
        
        let model = EmotionSentimentClassifier()
        var calculatedStress = 0.0

        // string parsing
        let trimmedComment = comment?.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\"")))
            .replacingOccurrences(of: "’", with: "")                // this was a pain...need the slanted apostrophe
        let punctuation = CharacterSet(charactersIn: ".;/!?")
        let commentArr = trimmedComment?.components(separatedBy: punctuation).filter({ $0 != ""})
        
        // NLP on each sentence, average our for total calculated stress
        commentArr?.forEach {
            do {
                let prediction = try model.prediction(text: $0)
                switch (prediction.label) {
                case "0":
//                    print("sadness")
                    calculatedStress += 0.5
                case "1":
//                    print("joy")
                    calculatedStress += 0.1
                case "2":
//                    print("love")
                    calculatedStress += 0.1
                case "3":
//                    print("anger")
                    calculatedStress += 0.8
                default:
//                    print("fear")
                    calculatedStress += 0.8
                }
            } catch {
                print(error)
            }
        }
        
        if(trimmedComment == nil) {
            calculatedStress = 0.0
        } else {
            calculatedStress = calculatedStress / Double(commentArr?.count ?? 1)
        }
        
        newStressValue.stressValue = calculatedStress
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        entries.append(newEntry)
        saveToPersistentStore()
    
    }
    
    func deleteEntry(at offset: IndexSet) {
        
        guard let index = Array(offset).first else { return }
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
