import ReactorKit
import RxSwift

final class CounterViewReactor: Reactor {

    enum Action {
        case increase
        case decrease
    }
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    struct State {
        var currentValue: Int
        var isLoading: Bool
    }

    var initialState: State
    init() {
        self.initialState = State(
            currentValue: 0,
            isLoading: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }


    func reduce(state: State, mutation: Mutation) -> State {
      var state = state
      switch mutation {
      case .increaseValue:
        state.currentValue += 1

      case .decreaseValue:
        state.currentValue -= 1

      case let .setLoading(isLoading):
        state.isLoading = isLoading
      }
      return state
    }
    
}
