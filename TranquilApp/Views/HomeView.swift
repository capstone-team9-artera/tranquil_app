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
    
//    init() {
//
//        UINavigationBar.appearance().backgroundColor = .systemRed
//
//         UINavigationBar.appearance().largeTitleTextAttributes = [
//            .foregroundColor: UIColor.white]
//
//    }
//
    var body: some View {
//        NavigationView {
        ZStack(alignment: .bottomTrailing) {
            
            VStack(spacing: 0){
                
//                HStack(alignment: .center) {
//
//
//                    Text("My Entry").font(.title).foregroundColor(.white)
//
//                    Spacer()
//                    NavigationLink(destination: CalendarView(start: Date(), monthsToShow: 1, daysSelectable: true, entryController: entryModelController)) {
//                        Text("Calendar").foregroundColor(.white)
//                    }
//
//
//                }.padding()
//                    .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
//                    .background(Color.red)
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
                Spacer()
                
            }//
            Spacer()
            Button(action: {
                
                self.txt = ""
                self.docID = ""
                self.show.toggle()
                
            }) {
                
                Image(systemName: "plus").resizable().frame(width: 18, height: 18).foregroundColor(.white)
                
            }.padding()
                .background(Color.red)
                .clipShape(Circle())
                .padding()
            
        }
        .sheet(isPresented: self.$show) {
        
            AddEntryView(entryModelController: self.entryModelController)
            
        }.animation(.default).navigationBarTitle("Diary").navigationBarItems(trailing: NavigationLink(destination: CalendarView(start: Date(), monthsToShow: 1, daysSelectable: true, entryController: entryModelController), label: {
            Image(systemName: "calendar")
        })).accentColor(.black)
            
//        }.accentColor(.black)
    }
    
}

class Host : UIHostingController<ContentView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
