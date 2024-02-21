//
//  MyTaskHome.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/21/24.
//

import SwiftUI

struct MyTaskHome: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME!") {
                    MyTask2()
                }
            }
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MyTaskHome_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskHome()
    }
}
