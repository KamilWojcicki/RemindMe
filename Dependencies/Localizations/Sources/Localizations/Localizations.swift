import Foundation

enum Constants: String {
    case languageKey = "language-key"
    case appleLanguages = "AppleLanguages"
}

public enum SupportedLanguage: String {
    case english = "english"
    case polish = "polish"
}

extension String {
    public var localized: String {
        NSLocalizedString(self, bundle: .module, value: self, comment: "")
    }
}

public class LanguageSetting: ObservableObject {
    
    public init() { 
        setupInitialLocale()
    }
    
    public var locale: Locale = .current {
        didSet {
            
        }
    }
    
    private func setupInitialLocale() {
        if let language = UserDefaults.standard.string(forKey: Constants.languageKey.rawValue), let value = SupportedLanguage(rawValue: language) {
            setLocale(language: value)
        } else {
            guard let languages = UserDefaults.standard.array(forKey: Constants.appleLanguages.rawValue), let currentLanguage = languages.first as? String else { return }
            if currentLanguage.contains("pl") {
                setLocale(language: .polish)
            } else {
                setLocale(language: .english)
            }
        }
    }
    
    public func setLocale(language: SupportedLanguage) {
        switch language {
        case .english:
            locale = Locale(identifier: "en")
            UserDefaults.standard.setValue(SupportedLanguage.english.rawValue, forKey: Constants.languageKey.rawValue)
            UserDefaults.standard.synchronize()
        case .polish:
            locale = Locale(identifier: "pl")
            UserDefaults.standard.setValue(SupportedLanguage.polish.rawValue, forKey: Constants.languageKey.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
