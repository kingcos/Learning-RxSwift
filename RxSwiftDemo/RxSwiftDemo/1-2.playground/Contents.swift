//: Playground - noun: a place where people can play

import Cocoa
import RxSwift

let one = 1
let two = 2
let three = 3

// MARK: Observable - 被观察者

// Observable<Int>
let obs1: Observable<Int> = Observable<Int>.just(one)

// Observable<Int>: Int 由传入的可变参数类型确定
let obs2 = Observable.of(one, two, three)

// Observable<[Int]>: [Int] 由传入的可变参数类型确定
let obs3 = Observable.of([one, two, three])

// Observable<Int>: Int 由传入的数组元素类型确定
let obs4 = Observable.from([one, two, three])

// Observable<Void>: 空序列，不能利用类型推断，因此需要制定类型 Void
let emptyObs = Observable<Void>.empty()

// Observable<Any>: never 序列，不会终止的序列
let neverObs = Observable<Any>.never()

// Observable<Int>: range 序列
let rangeObs = Observable<Int>.range(start: -5, count: 11)

// MARK: Subscribe - 订阅

// 打印所有事件
obs2.subscribe { print($0) }
print("---")

// 打印含有 element 的事件（只有 .next 含有 element）
obs2.subscribe {
    if let element = $0.element {
        print(element)
    }
}
print("---")

// 只处理 .next 事件
let sub1 = obs2.subscribe(onNext: { element in
    print(element)
})
print("---")

// empty 被观察者序列，只发出 .completed 事件
let sub2 = emptyObs.subscribe { print($0) }
print("---")

// never 被观察者序列
let sub3 = neverObs.subscribe { print($0) }
print("---")

// range 被观察者序列
let sub4 = rangeObs.subscribe { print($0) }
print("---")

// MARK: Dispose - 处置

sub1.dispose()

let disposeBag = DisposeBag()

sub2.disposed(by: disposeBag)
sub3.disposed(by: disposeBag)
sub4.disposed(by: disposeBag)

// create: 通过特定的订阅方法实现来创建一个被观察者序列
Observable<String>.create { observer in
    
    observer.onNext("Event - next")
    observer.onCompleted()
    
    // 空处置者
    return Disposables.create()
    }.subscribe {
        print($0)
    }.disposed(by: disposeBag)
print("---")

// MARK: Deferred

// 返回一个被观察者序列，当新的观察者订阅，调用指定的工厂方法。
var flip = false
let obsFactory = Observable<Int>.deferred {
    flip = !flip
    
    if flip {
        return Observable.of(1, 2, 3)
    } else {
        return Observable.of(4, 5, 6)
    }
}

for _ in 0..<3 {
    obsFactory.subscribe(onNext: { element in
        print(element, separator: "", terminator: " ")
    }).disposed(by: disposeBag)
    
    print("\n---")
}

// MARK: do & debug & never

// do: 在其中可以做一些额外的事情
neverObs.do(onNext: { (element) in
    print("do - \(element)")
}, onError: { (error) in
    print("do - \(error)")
}, onCompleted: {
    print("do - onCompleted")
}, onSubscribe: {
    print("do - onSubscribe")
}, onDispose: {
    print("do - onDispose")
}).subscribe(onNext: { (element) in
    print("element: \(element)")
}, onCompleted: {
    print("onCompleted")
}, onDisposed: {
    print("onDisposed")
}).disposed(by: disposeBag)
print("---")

// debug: 打印接收到的事件的详细信息
neverObs.debug().subscribe(onNext: { (element) in
    print("element: \(element)")
}, onCompleted: {
    print("onCompleted")
}, onDisposed: {
    print("onDisposed")
}).disposed(by: disposeBag)
