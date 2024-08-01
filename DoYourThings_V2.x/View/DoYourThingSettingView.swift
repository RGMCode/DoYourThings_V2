//
//  DoYourThingSettingView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

/*import SwiftUI

struct DoYourThingSettingView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    
    var body: some View {
        List {
            NavigationLink(destination: DoYourThingManageCategoriesView(viewModel: viewModel)) {
                Text("Kategorien verwalten")
            }
            NavigationLink(destination: DoYourThingThemeChoiceView(viewModel: viewModel)) {
                Text("Theme auswählen")
            }
        }
    }
}

#Preview {
    DoYourThingSettingView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
*/


import SwiftUI

struct DoYourThingSettingView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    @State private var showRestartAlert = false

    // List of supported language codes
    let supportedLanguages = ["en", "de", "fr", "es", "it", "pt", "nl", "pl", "no", "sv", "fi", "el", "hr", "ro", "sk", "cs", "ca", "da", "he", "vi", "uk", "ms", "zh-Hans", "zh-Hant", "zh-HK", "th", "id"]

    var body: some View {
        List {
            NavigationLink(destination: DoYourThingManageCategoriesView(viewModel: viewModel)) {
                Text(NSLocalizedString("manageCategories", comment: "Manage Categories"))
            }
            NavigationLink(destination: DoYourThingThemeChoiceView(viewModel: viewModel)) {
                Text(NSLocalizedString("chooseTheme", comment: "Choose Theme"))
            }
            Section(header: Text(NSLocalizedString("language", comment: "Language"))) {
                Picker(NSLocalizedString("selectLanguage", comment: "Select Language"), selection: $selectedLanguage) {
                    ForEach(supportedLanguages, id: \.self) { identifier in
                        Text(Locale(identifier: identifier).localizedString(forLanguageCode: identifier) ?? identifier)
                            .tag(identifier)
                    }
                }
                .onChange(of: selectedLanguage) { oldValue, newValue in
                    changeLanguage(to: newValue)
                }
            }
        }
        .navigationTitle(NSLocalizedString("settings", comment: "Settings"))
        .alert(isPresented: $showRestartAlert) {
            Alert(
                title: Text("Restart Required"),
                message: Text("Please restart the app to apply the new language."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func changeLanguage(to languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        showRestartAlert = true
    }
}

#Preview {
    DoYourThingSettingView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}

