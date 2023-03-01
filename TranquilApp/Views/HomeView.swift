//
//  HomeView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import Foundation

import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var entryModelController = EntryModelController()
    @State var show = false
    @State var txt = ""
    @State var docID = ""
    @State var remove = false
    
    var body: some View {
//        NavigationView {
        ZStack(alignment: .bottomTrailing) {
            
            VStack(spacing: 0){
                List {
                    ForEach(self.entryModelController.entries, id: \.id) { entry in
                        
                        EntryRowView(entryModelController: EntryModelController(), entry: entry)
                     
                    }.onDelete { (index) in
                        
                        self.entryModelController.deleteEntry(at: index)
                    }
                    .toolbar {
                                   EditButton()
                               }
                }.onAppear {
                    //Removes extra cells that are not being used.
                    UITableView.appearance().tableFooterView = UIView()
                    //MARK: Disable selection.
                
                    UITableView.appearance().allowsSelection = true
                    UITableViewCell.appearance().selectionStyle = .none
                     UITableView.appearance().showsVerticalScrollIndicator = false
                    
                    
                }
                Spacer().background(BACKGROUND_COLOR)
                
            }
//            Spacer()
            Button(action: {
                
                self.txt = ""
                self.docID = ""
                self.show.toggle()
                
            }) {
                
                Image(systemName: "plus").resizable().frame(width: 18, height: 18).foregroundColor(BACKGROUND_COLOR)
                
            }.padding()
                .background(SECONDARY_TEXT_COLOR)
                .clipShape(Circle())
                .padding()
            
        }
        .sheet(isPresented: self.$show) {
        
            AddEntryView(entryModelController: self.entryModelController)
            
        }.background(BACKGROUND_COLOR)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
