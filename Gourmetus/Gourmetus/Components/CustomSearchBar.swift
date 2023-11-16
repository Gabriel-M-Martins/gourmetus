//
//  CustomSearchBar.swift
//  Gourmetus
//
//  Created by Thiago Defini on 16/11/23.
//

import Foundation
import SwiftUI

struct CurstomSearchBar: UIViewRepresentable {
    @Binding var text: String
    @State var isAlgo: Bool = true
//    var onCancel: () -> Void
    var isFirstResponder: Bool = false
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isAlgo: Bool
        
        init(text: Binding<String>, isAlgo: Binding<Bool>) {
            _text = text
            _isAlgo = isAlgo
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            isAlgo = false
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isAlgo: $isAlgo)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CurstomSearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.showsCancelButton = true
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<CurstomSearchBar>) {
        uiView.text = text
        
        if isAlgo {
            if isFirstResponder && !uiView.isFirstResponder {
                uiView.becomeFirstResponder()
            }
        }
    }
}

class SearchBarResponder: ObservableObject {
    @Published var isActive: Bool = false
}
