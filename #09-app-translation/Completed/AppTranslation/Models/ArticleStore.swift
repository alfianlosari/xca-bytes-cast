import SwiftUI
import Translation

@Observable
@MainActor
class ArticleStore {
    
    var articles: [Article] {
        translatedArticles?.1 ?? sourceArticles
    }
    
    var sourceArticles: [Article] = Article.previewData
    var translatedArticles: (Locale.Language, [Article])?
    
    var configuration: TranslationSession.Configuration?
    var isTranslating: Bool = false
    
    var availableLanguages: [AvailableLanguage] = []
    
    let sourceLang = Locale.Language(identifier: "en")
    var selectedTo: Locale.Language? = Locale.Language(components: .init(languageCode: .japanese, script: nil, region: .japan))
    
    
    var articleDetailLanguage: Locale.Language? {
        guard let translatedLang = translatedArticles?.0, let selectedTo, translatedLang == selectedTo else {
            return sourceLang
        }
        return translatedLang
    }
    
    init() {
        Task { @MainActor in
            let supportedLanguages = await LanguageAvailability().supportedLanguages
                .filter { $0.languageCode?.identifier != "en" }
            self.availableLanguages = supportedLanguages.map { AvailableLanguage(locale: $0 )}.sorted()
        }
    }
    
    func triggerTranslation() {
        if let configurationLangId = configuration?.target?.languageCode?.identifier, configurationLangId != selectedTo?.languageCode?.identifier {
            configuration = .init(source: sourceLang, target: selectedTo)
        } else if configuration == nil {
            configuration = .init(source: sourceLang, target: selectedTo)
        } else {
            configuration?.invalidate()
        }
    }
    
    func translateBatch(using session: TranslationSession) async {
        Task { @MainActor in
            guard let targetLang = session.targetLanguage else { return }
            translatedArticles = nil
            isTranslating = true
            
            let titleRequests = articles.map {
                TranslationSession.Request(sourceText: $0.title)
            }
            
            let descriptionRequests = articles.map {
                TranslationSession.Request(sourceText: $0.descriptionText)
            }
            
            do {
                let titleResponses = try await session.translations(from: titleRequests)
                let descriptionResponses = try await session.translations(from: descriptionRequests)
                
                let translated = articles.enumerated().map { index, article in
                    var article = article
                    article.title = titleResponses[index].targetText
                    article.description = descriptionResponses[index].targetText
                    return article
                }
                self.translatedArticles = (targetLang, translated)
            } catch {
                print(error.localizedDescription)
            }
            
            isTranslating = false

        }
    }
    
    
}
