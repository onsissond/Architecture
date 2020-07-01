
typealias FBEvent = ()
typealias FIREvent = ()
typealias FunnelEvent = ()

enum Event {
    case facebook(FBEvent)
    case firebase(FIREvent)
    case funnel(FunnelEvent)
}

protocol AnalyticProvider {
    func logEvent(_ event: Event)
}

// Фасад
struct AnalyticsFacade {
    private let _providers: [AnalyticProvider]

    init(providers: AnalyticProvider...) {
        _providers = providers
    }
}

extension AnalyticsFacade: AnalyticProvider {
    func logEvent(_ event: Event) {
        _providers.forEach { $0.logEvent(event) }
    }
}

// Конкретные реализации
struct FIRAnalytics {
    func logEvent(_ event: FIREvent) {}
}
extension FIRAnalytics: AnalyticProvider {
    func logEvent(_ event: Event) {
        guard let firEvent = event.firebase else {
            return
        }
        logEvent(firEvent)
    }
}

// Используем фабрику
enum AnalyticsFactory {
    static func createAnalyticProvider() -> AnalyticProvider {
        let firAnalytics: AnalyticProvider = FIRAnalytics()
        return AnalyticsFacade(providers: firAnalytics)
    }
}

let analytics = AnalyticsFactory.createAnalyticProvider()
analytics.logEvent(.facebook(FBEvent()))

// Один ивент в набор аналитик
extension Event {
    var facebook: FBEvent? {
        guard case .firebase(let event) = self else {
            return nil
        }
        return event
    }

    var firebase: FIREvent? {
        switch self {
        case .firebase(let firEvent):
            return firEvent
        case .funnel(let funnelEvent):
            // Mapping
            return funnelEvent as! FIREvent
        default:
            return nil
        }
    }
}

// Для двух аналитик в именах событий заменить . на _

