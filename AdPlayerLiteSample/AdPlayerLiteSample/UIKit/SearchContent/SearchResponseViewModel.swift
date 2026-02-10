//
//  SearchResponseViewModel.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 09.02.2026.
//

import AdPlayerLite
import Foundation

final class SearchResponseViewModel {
    
    private let requestURL = URL(string: "https://feed.avplayer.com/backend/api/playlist/6489d00953fe854a83094682" +
                                 "?AV_TAGID=692049a2ac8cfcfa2a001420" +
                                 "&pid=5ac2203f073ef46a6856c7b0" +
                                 "&cid=69204a279aa7c46b980ccc07" +
                                 "&AV_TEMPID=685557b18d3fb117f40f6245" +
                                 "&AV_PUBLISHERID=5ac2203f073ef46a6856c7b0"
    )!
    
    private(set) var jsonArray: [String: Any]?
    private var task: Task<Void, Never>?
    
    // request results
    var onSuccess: (([String: Any]) -> Void)?
    var onError: ((String) -> Void)?
    
    func load() {
        task?.cancel()
        
        task = Task {
            Task {
                do {
                    let json = try await fetchSearchResponse()
                    guard !Task.isCancelled else { return }
                    
                    await MainActor.run {
                        self.jsonArray = json
                        self.onSuccess?(json)
                    }
                } catch {
                    guard !Task.isCancelled else { return }
                    
                    await MainActor.run {
                        self.onError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
    
    private func fetchSearchResponse() async throws -> [String: Any] {
        let (data, _) = try await URLSession.shared.data(from: requestURL)
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        if let json = jsonObject as? [String: Any] {
            return json
        }
        throw NSError(
            domain: "Unexpected JSON shape",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey:
                    "JSON format issue"
            ]
        )
    }
}
