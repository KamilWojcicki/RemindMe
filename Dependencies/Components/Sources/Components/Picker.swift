//
//  Picker.swift
//  Components
//
//  Created by Kamil Wójcicki on 08/10/2024.
//

import Design
import SwiftUI
import ToDoInterface

public struct Picker: View {
    public enum Variant {
        case titleAndImage(textFieldText: Binding<String>, selectedIcon: Binding<Icon>)
        case time(selection: Binding<Date>, dateComponents: DatePickerComponents)
        case repetition(selectedRepetition: Binding<Repetition>)
        case tag(selectedTag: Binding<Tag>)
        case subtask
    }

    private let variant: Variant
    
    public init(variant: Variant) {
        self.variant = variant
    }
    
    public var body: some View {
        buildPickerView(for: variant)
            .padding()
    }
    
    @ViewBuilder
    private func buildPickerView(for variant: Variant) -> some View {
        switch variant {
        case .titleAndImage(let textFieldText, let selectedIcon):
            buildTitleAndImage(textFieldText: textFieldText, selectedIcon: selectedIcon)
        case .time(let selection, let dateComponents):
            buildTimePicker(selection: selection, dateComponents: dateComponents)
        case .repetition(let selectedRepetition):
            buildRepetitionPicker(selectedRepetition: selectedRepetition)
        case .tag(let selectedTag):
            buildTagPicker(selectedTag: selectedTag)
        case .subtask:
            buildSubtaskPicker()
        }
    }
    
    private func buildTitleAndImage(textFieldText: Binding<String>, selectedIcon: Binding<Icon>) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            buildText(text: "Change Image")
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(Icon.allIcons, id: \.self) { icon in
//                        RoundedRectangle(cornerRadius: 10)
//                            .frame(width: 50, height: 50)
                        CircularIcon(icon: icon)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.3)
                            }
                            .onTapGesture {
                                selectedIcon.wrappedValue = icon
                            }
                    }
                }
            }
            .contentMargins(.horizontal, 10)
            .scrollIndicators(.never)
            .scrollTargetBehavior(.paging)
            .padding(.horizontal, -16)
            
            buildText(text: "Change Title")
            
            SwiftUI.TextField("New title...", text: textFieldText)
            
            Divider()
                .padding(.top, -10)
        }
    }
    
    private func buildTimePicker(selection: Binding<Date>, dateComponents: DatePickerComponents) -> some View {
        DatePicker("", selection: selection, in: Date()..., displayedComponents: dateComponents)
            .labelsHidden()
            .frame(maxWidth: .infinity, alignment: .center)
            .datePickerStyle(.wheel)
    }
    
    private func buildTagPicker(selectedTag: Binding<Tag>) -> some View {
        buildScrollPicker(selectedValue: selectedTag, title: "Choose a tag")
    }
    
    private func buildSubtaskPicker() -> some View {
        VStack {
            #warning("This feature is inactive")
        }
    }
    
    private func buildRepetitionPicker(selectedRepetition: Binding<Repetition>) -> some View {
        buildScrollPicker(selectedValue: selectedRepetition, title: "Choose a repetition")
    }
    
    private func buildText(text: String) -> some View {
        Text(text)
            .font(.size23DefaultBold)
    }
    
    private func buildScrollPicker<T: CaseIterable & RawRepresentable & Hashable>(selectedValue: Binding<T>, title: String) -> some View where T.RawValue == String {
        VStack(alignment: .leading) {
            buildText(text: title)
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(Array(T.allCases), id: \.self) { value in
                        Text(value.rawValue)
                            .padding(10)
                            .font(.size15Default)
                            .foregroundStyle(selectedValue.wrappedValue == value ? Colors.ghostWhite : Colors.night)
                            .background(selectedValue.wrappedValue == value ? Colors.blue.opacity(0.75) :    Colors.blue.opacity(0.45))
                            .clipShape(.rect(cornerRadius: 10))
                            .onTapGesture {
                                debugPrint("repetition: \(value.rawValue) is selected")
                                selectedValue.wrappedValue = value
                            }
                    }
                }
            }
            .contentMargins(.horizontal, 10)
            .scrollIndicators(.never)
            .scrollTargetBehavior(.paging)
            .padding(.horizontal, -16)
        }
    }
}

#Preview {
    VStack {
        Picker(variant: .time(selection: .constant(Date()), dateComponents: .date))
        
        Picker(variant: .titleAndImage(textFieldText: .constant(""), selectedIcon: .constant(.birthdayIcon)))
        
        Picker(variant: .repetition(selectedRepetition: .constant(.daily)))
        
        Picker(variant: .tag(selectedTag: .constant(.all)))
    }
    
}
