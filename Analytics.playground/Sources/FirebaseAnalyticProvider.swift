
public struct FirebaseAnalyticProvider {
    private let _firebase: (FIREvent) -> Void = { _ in }
    private let _mutator: Mutator<FIREvent>

    init(mutator: @escaping Mutator<FIREvent> = FirebaseMutationProvider.mutate) {
        _mutator = mutator
    }
}

extension FirebaseAnalyticProvider: AnalyticProvider {
    public func logEvent(_ event: Event) {
        guard let firEvent = event.firebase else {
            return
        }
        _firebase(_mutator(firEvent))
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


typealias LogEvent = (Event) -> Void
typealias Mutator<Event> = (Event) -> Event

enum FirebaseMutationProvider {
    static var mutate: Mutator<FIREvent> = { $0 }
}

public enum FirebaseAnalytic {
    static func make(
        firebase: @escaping (FIREvent) -> Void,
        mutator: @escaping Mutator<FIREvent>
    ) -> LogEvent {
        return {
            guard let firEvent = $0.firebase else {
                return
            }
            firebase(mutator(firEvent))
        }
    }
}
