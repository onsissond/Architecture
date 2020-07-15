
public enum FunnelAnalyticProvider {
    public static func make(
        logEvent: @escaping (FunnelEvent) -> Void
    ) -> LogEvent {
        return {
            guard let firEvent = $0.funnel else {
                return
            }
            logEvent(firEvent)
        }
    }
}

extension Event {
    var funnel: FunnelEvent? {
        guard case .funnel(let event) = self else {
            return nil
        }
        return event
    }
}
