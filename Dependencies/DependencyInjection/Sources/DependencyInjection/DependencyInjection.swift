import Swinject

public typealias Container = Swinject.Container
public typealias ObjectScope = Swinject.ObjectScope

public struct Assemblies {
    public static let sharedContainer = Container()
    
    public static func resolve<T>(
        _ type: T.Type
    ) -> T! {
        sharedContainer.resolve(type)
    }
    
    public static func inject<T>(
        type: T.Type,
        object: @escaping @autoclosure () -> T,
        inObjectScope objectScope: ObjectScope = .weak
    ) {
        sharedContainer.register(type) { _ in
            object()
        }
        .inObjectScope(objectScope)
    }
}

@propertyWrapper
public final class Inject<T> {
    private lazy var value: T = Assemblies.resolve(T.self)
    
    public var wrappedValue: T {
        value
    }
    
    public init() { }
}
