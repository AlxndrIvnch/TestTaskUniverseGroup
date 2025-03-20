//
//  BaseCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 3/20/25.
//

import Foundation
import RxSwift

open class BaseCoordinator<ResultType>: NSObject {

  /// Utility `DisposeBag` used by the subclasses.
  public let disposeBag = DisposeBag()

  /// Unique identifier.
  private let identifier = UUID()

  /// Dictionary of the child coordinators. Every child coordinator should be added
  /// to that dictionary in order to keep it in memory.
  /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
  /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
  public var childCoordinators = [UUID: Any]()

  /// Stores coordinator to the `childCoordinators` dictionary.
  ///
  /// - Parameter coordinator: Child coordinator to store.
  private func store<T>(coordinator: BaseCoordinator<T>) {
    childCoordinators[coordinator.identifier] = coordinator
  }

  /// Release coordinator from the `childCoordinators` dictionary.
  ///
  /// - Parameter coordinator: Coordinator to release.
  public func free<T>(coordinator: BaseCoordinator<T>) {
    childCoordinators[coordinator.identifier] = nil
  }

  /// 1. Stores coordinator in a dictionary of child coordinators.
  /// 2. Calls method `start()` on that coordinator.
  /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
  ///
  /// - Parameter coordinator: Coordinator to start.
  /// - Returns: Result of `start()` method.
  public func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
    store(coordinator: coordinator)
    return coordinator
      .start()
      .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
  }

  /// Starts job of the coordinator.
  ///
  /// - Returns: Result of coordinator job.
  open func start() -> Observable<ResultType> {
    fatalError("Start method should be implemented.")
  }

  deinit { print("\\(self) dealloc") }
}
