//
//  FloatingDatePicker.swift
//  NASAApp
//
//  Created by Erick Daniel Padilla on 19/06/24.
//

import SwiftUI

struct FloatingDatePicker: View {
    @Binding var date: Date
    
    @State private var showingPopover = false
    
    var dateRange: ClosedRange<Date> {
        let startDate = Calendar.autoupdatingCurrent.date(from: DateComponents(year: 1995, month: 6, day: 16))!
        return startDate...Date.now
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: togglePicker) {
                Text(date, style: .date)
            }
            .tint(.accentColor)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Material.regular, in: Capsule())
            .shadow(radius: 16)
            DatePicker("Selected date", selection: $date, in: dateRange, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.horizontal)
                .background(Material.regular, in: RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 16)
                .padding(.horizontal)
                .opacity(showingPopover ? 1 : 0)
            Spacer()
        }
        .onChange(of: date) { _, _ in
            hidePicker()
        }
//        .onTapGesture {
//            hidePicker()
//        }
    }
    
    func togglePicker() {
        withAnimation {
            showingPopover.toggle()
        }
    }
    
    func hidePicker() {
        withAnimation {
            showingPopover = false
        }
    }
}

#Preview {
    FloatingDatePicker(date: .constant(.now))
    .background {
        Image("NasaPicture")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}
