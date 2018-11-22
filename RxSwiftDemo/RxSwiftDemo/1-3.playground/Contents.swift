//: Playground - noun: a place where people can play

import Cocoa
import RxSwift

enum CustomError: Error {
    case A
}

// MARK: PublishSubject

// PublishSubject: 起始为空，仅向订阅者发送新元素。
let publishSubject = PublishSubject<String>()

// 订阅前的元素不发送
publishSubject.onNext("0")

let sub1 = publishSubject.subscribe(onNext: { element in
    print(element)
})

publishSubject.on(.next("1"))
publishSubject.onNext("2")

let sub2 = publishSubject.subscribe { event in
    if let element = event.element {
        print("sub2 - \(element)")
    }
}

// PublishSubject 发送元素，所有订阅者均可收到
publishSubject.onNext("3")

// 当订阅者被处置，则不再收到
sub1.dispose()
publishSubject.onNext("4")

// 当 PublishSubject 完成/出错后，不再发送元素
publishSubject.onCompleted()
publishSubject.onNext("5")

print("---")

// MARK: BehaviorSubject

let disposeBag = DisposeBag()

// BehaviorSubject: 有初始值，将向新订阅者重发之前最新的元素。
let behaviorSubject = BehaviorSubject(value: "0")

// 重发之前最新的元素，即初始值
behaviorSubject.subscribe {
    print("1 - \($0)")
    }.disposed(by: disposeBag)

// 重发之前最新的元素
behaviorSubject.onNext("1")
behaviorSubject.subscribe {
    print("2 - \($0)")
    }.disposed(by: disposeBag)

// Error
behaviorSubject.onError(CustomError.A)
behaviorSubject.subscribe {
    print("3 - \($0)")
    }.disposed(by: disposeBag)

print("---")

// MARK: ReplaySubject

// ReplaySubject: 以缓冲区大小初始化，维持不超过一个缓冲区大小的元素，并向新订阅者重发。
// 缓冲区在内存中存放，因此不可过大
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1")
replaySubject.onNext("2")
replaySubject.onNext("3")

// 缓冲区大小为 2，因此新订阅者只收到了最新的 2 个元素
replaySubject.subscribe {
    print("1 - \($0)")
    }.disposed(by: disposeBag)

// Error: 不占用缓冲区大小
replaySubject.onError(CustomError.A)
// ReplaySubject 没必要显式处置
replaySubject.dispose()
replaySubject.subscribe {
    print("2 - \($0)")
    }.disposed(by: disposeBag)

print("---")

// MARK: Variables

// Variables: 包装 BehaviorSubject，保留其当前值作为状态，并将最新/初始值重发给新的订阅者。
let variable = Variable("Initial Value")

// 更改初始值（同 onNext）
variable.value = "0"

// asObservable(): 访问内部的 BehaviorSubject
variable.asObservable().subscribe {
    print("1 - \($0)")
    }.disposed(by: disposeBag)

variable.value = "1"

// Variables 可以保证不发送 Error，将会自动（不可手动）发送 Completed。

print("---")

// Example:

enum UserSession {
    case logIn
    case logOut
}

enum LoginError: Error {
    case invalidInfo
}

let bag = DisposeBag()
let session = Variable(UserSession.logOut)

func logInWith(_ username: String, and password: String, completion: (Error?) -> ()) {
    guard username == "maimieng.com",
    password == "123456" else {
        completion(LoginError.invalidInfo)
        return
    }
    
    session.value = .logIn
}

func logOut() {
    session.value = .logOut
}

func doSthWithUserLoggedIn() {
    guard session.value == .logIn else {
        print("Permission refused!")
        return
    }
    
    print("Do something...")
}

session.asObservable().subscribe(onNext: { session in
    print(session)
}).disposed(by: bag)

for i in 0..<2 {
    let password = i % 2 == 0 ? "root" : "123456"
    
    logInWith("maimieng.com", and: password, completion: { error in
        guard let error = error else { return }
        
        print(error.localizedDescription)
    })
    
    doSthWithUserLoggedIn()
}
