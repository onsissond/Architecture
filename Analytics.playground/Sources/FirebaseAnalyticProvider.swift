
public typealias Mutator<Event> = (Event) -> Event

public enum FirebaseMutationProvider {
    public static var mutator: Mutator<FIREvent> =
        FirebaseMutationProvider.addKey
}

private extension FirebaseMutationProvider {
    static var addKey: Mutator<FIREvent> = {
        var dic = $0
        dic["test"] = "value"
        return dic
    }
}

public enum FirebaseAnalyticProvider {
    public static func make(
        logEvent: @escaping (FIREvent) -> Void,
        mutator: @escaping Mutator<FIREvent> = FirebaseMutationProvider.mutator
    ) -> LogEvent {
        return {
            guard let firEvent = $0.firebase else {
                return
            }
            logEvent(mutator(firEvent))
        }
    }
}

extension Event {
    var firebase: FIREvent? {
        guard case .firebase(let event) = self else {
            return nil
        }
        return event
    }
}
