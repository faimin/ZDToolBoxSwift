//
//  GloableActor.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/1/6.
//

// MARK: - GloableActor

@available(iOS 13.0, *)
@globalActor
public actor ZDGloableActor: GlobalActor {
    // MARK: Static Properties
    
    public static var shared = ZDGloableActor()
    
    private static let excutor = ZDExecutor()
    
    // MARK: Static Computed Properties
    
    public static var sharedUnownedExecutor: UnownedSerialExecutor {
        excutor.asUnownedSerialExecutor()
    }
}

// MARK: - LMExecutor

@available(iOS 13.0, *)
private final class ZDExecutor: SerialExecutor {
    // MARK: Static Properties
    
    private static let dispatcher = DispatchQueue(label: "com.zd.actor.serial", qos: .utility)
    
    // MARK: Functions
    
    func enqueue(_ job: UnownedJob) {
        ZDExecutor.dispatcher.async {
            job.runSynchronously(on: self.asUnownedSerialExecutor())
        }
    }
    
    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        UnownedSerialExecutor(ordinary: self)
    }
}
