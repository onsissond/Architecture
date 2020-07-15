public protocol AnalyticProvider {
    func logEvent(_ event: Event)
}

public struct AnalyticsFacade {
    private let _providers: [AnalyticProvider]

    init(providers: AnalyticProvider...) {
        _providers = providers
    }
}

extension AnalyticsFacade: AnalyticProvider {
    public func logEvent(_ event: Event) {
        _providers.forEach { $0.logEvent(event) }
    }
}
