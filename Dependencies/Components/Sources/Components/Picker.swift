//
//  Picker.swift
//  Components
//
//  Created by Kamil Wójcicki on 08/10/2024.
//

import Design
import SwiftUI
import ToDoInterface

public struct PickerView: View {
    public enum Variant {
        case titleAndImage(textFieldText: Binding<String>, selectedIcon: Binding<Icon>)
        case time(selection: Binding<Date>, dateComponents: DatePickerComponents)
        case repetition(selectedRepetition: Binding<Repetition>)
        case tag(selectedTag: Binding<Tag>)
        case subToDo(textFieldText: Binding<String>)
        case editSubToDo(textFieldText: Binding<String>)
    }
    
    private let variant: Variant
    private let title: String
    private let action: () -> Void
    
    public init(variant: Variant, title: String, onXmarkAction: @escaping () -> Void) {
        self.variant = variant
        self.title = title
        self.action = onXmarkAction
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                buildText(text: title)
                Spacer()
                Symbols.xmarkCircle
                    .padding()
                    .onTapGesture {
                        action()
                    }
                    .tint(Colors.night)
                    
            }
            
            buildPickerView(for: variant)
        }
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
        case .subToDo(let textFieldText):
            buildSubToDoPicker(text: textFieldText)
        case .editSubToDo(let textFieldText):
            buildSubToDoEditPicker(text: textFieldText)
        }
    }
    
    @ViewBuilder
    private func buildTitleAndImage(textFieldText: Binding<String>, selectedIcon: Binding<Icon>) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(Icon.allIcons, id: \.self) { icon in
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
        
        buildTextField(prompt: "New title...", text: textFieldText)
    }
    
    @ViewBuilder
    private func buildTimePicker(selection: Binding<Date>, dateComponents: DatePickerComponents) -> some View {
        DatePicker("", selection: selection, in: Date()..., displayedComponents: dateComponents)
            .labelsHidden()
            .frame(maxWidth: .infinity, alignment: .center)
            .datePickerStyle(.wheel)
    }
    
    private func buildTagPicker(selectedTag: Binding<Tag>) -> some View {
        buildScrollPicker(selectedValue: selectedTag)
    }
    
    @ViewBuilder
    private func buildSubToDoPicker(text: Binding<String>) -> some View {
        buildTextField(prompt: "SubToDo...", text: text)
    }
    
    @ViewBuilder
    private func buildSubToDoEditPicker(text: Binding<String>) -> some View {
        buildTextField(prompt: "SubToDo...", text: text)
    }
    
    private func buildRepetitionPicker(selectedRepetition: Binding<Repetition>) -> some View {
        buildScrollPicker(selectedValue: selectedRepetition)
    }
    
    private func buildText(text: String) -> some View {
        Text(text)
            .font(.size23DefaultBold)
    }
    
    @ViewBuilder
    private func buildTextField(prompt: String, text: Binding<String>) -> some View {
        SwiftUI.TextField(prompt, text: text)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
        
        Divider()
            .padding(.top, -10)
    }
    
    private func buildScrollPicker<T: CaseIterable & RawRepresentable & Hashable>(selectedValue: Binding<T>) -> some View where T.RawValue == String {
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

#Preview {
    VStack {
        PickerView(variant: .time(selection: .constant(Date()), dateComponents: .date), title: "Time") {}
        
        PickerView(variant: .titleAndImage(textFieldText: .constant(""), selectedIcon: .constant(.birthdayIcon)), title: "") {}
        
        PickerView(variant: .repetition(selectedRepetition: .constant(.daily)), title: "") {}
        
        PickerView(variant: .tag(selectedTag: .constant(.all)), title: "") {}
        
        PickerView(variant: .subToDo(textFieldText: .constant("subtask")), title: "") {}
    }
}
