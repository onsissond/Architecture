import UIKit

typealias Input<Event> = Event
typealias Output<Event> = Event

typealias SetupUI<UI> = (UI) -> Void
typealias ModuleInterface<InputEvent, OutputEvent> = (Input<InputEvent>) -> Output<OutputEvent>
typealias Module<UI, InputEvent, OutputEvent> = (SetupUI<UI>) -> ModuleInterface<InputEvent, OutputEvent>


protocol ModuleFactory {
    associatedtype UI
    associatedtype InputEvent
    associatedtype OutputEvent
    associatedtype Dependencies

    func create(dependencies: Dependencies) -> Module<UI, InputEvent, OutputEvent>
}

struct OrderModuleFactory: ModuleFactory {

    func create(dependencies: Void) -> Module<UIViewController, Void, Void> {
        return { setupUI in
            let vc = UIViewController()
            let interface: ModuleInterface<Void, Void> = { _ in }
            setupUI(vc)
            return interface
        }
    }
}

struct ComingOrderModuleFactory: ModuleFactory {

    func create(dependencies: Void) -> Module<UIView, Void, Void> {
        return { setupUI in
            let vc = UIView()
            let interface: ModuleInterface<Void, Void> = { _ in }
            setupUI(vc)
            return interface
        }
    }
}


// ------------------------------------- //
struct OrderModuleFactoryExample: ModuleFactory {

    struct Dependencies {
        let comingOrderModule: Module<UIView, Void, Void>
    }

    enum Input {
        case doSmth
    }

    enum Output {
        case result
    }

    func create(dependencies: Dependencies) -> Module<UIViewController, Input, Output> {
        return { setupUI in
            let vc = UIViewController()
            // Запуск дочернего модуля
            let comingOrderInterface = dependencies.comingOrderModule({ comingOrderView in
                vc.view.addSubview(comingOrderView)
            })

            let interface: ModuleInterface<Input, Output> = { input in
                switch input {
                case .doSmth:
                    comingOrderInterface(())
                }
                return .result
            }

            setupUI(vc)
            return interface
        }
    }
}
