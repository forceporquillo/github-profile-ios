////
////  UserState.swift
////  gitprofile
////
////  Created by Aljan Porquillo on 9/6/24.
////
//
//import Observation
//
//@Observable final class Store<State, Action> {
//    private(set) var state: State
//    private let reduce: (State, Action) -> State
////    
////    private var task: Task<LoadableViewState<[UserUiModel]>, Error>?
//    
//    init(
//        initialState state: State,
//        reduce: @escaping (State, Action) -> State
//    ) {
//        self.state = state
//        self.reduce = reduce
//    }
//    
//    func send(_ action: Action) {
//        state = reduce(state, action)
//    }
//}
//
//
//struct UserState : Equatable {
//    
//    static func == (lhs: UserState, rhs: UserState) -> Bool {
//        return lhs.viewState == rhs.viewState
//    }
//    
//    var viewState: LoadableViewState<[UserUiModel]> = LoadableViewState.initial
//}
//
//enum UserAction : Equatable {
//    case paginate
//}
//
//let reduce: (UserState, UserAction) -> UserState = { state, action in
//    
//    var newState = state
//  
//    switch action {
//    case .paginate:
//        Task {
//            newState.viewState = await ServiceLocator.domainManager.getUsers()
//        }
//    }
//    
//    return newState
//}
//
//typealias UserStore = Store<UserState, UserAction>
