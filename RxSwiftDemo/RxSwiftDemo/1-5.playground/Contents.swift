//: Playground - noun: a place where people can play

import Cocoa
import RxSwift

let disposeBag = DisposeBag()

// MARK: Ignore - 忽略

// ignoreElements()
let subject1 = PublishSubject<String>()
subject1
    .ignoreElements()
    .subscribe { _ in
        print("Not ignored - ignoreElements")
}
    .addDisposableTo(disposeBag)

// .next 事件被全部忽略
subject1.onNext("1")
subject1.onNext("2")
subject1.onNext("3")

// .completed & .error 事件不会被忽略
subject1.onCompleted()

print("---")

// elementAt()
let subject2 = PublishSubject<String>()
subject2
    .elementAt(1)
    .subscribe(onNext: { element in
        print("Not ignored - elementAt - \(element)")
    })
    .addDisposableTo(disposeBag)

// 忽略其他所有元素，只取第 n 个元素
subject2.onNext("0")
subject2.onNext("1")
subject2.onNext("2")
subject2.onCompleted()

print("---")

// filter()
Observable
    .of(1, 2, 3, 4, 5)
    .filter { value in
        value % 2 == 0
}
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// MARK: Skip - 跳过

// skip(): 跳过前 n 个元素
Observable
    .of(1, 2, 3, 4, 5)
    .skip(2)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// skipWhile(): 跳过元素直到满足条件
Observable
    .of(2, 2, 3, 4, 5)
    .skipWhile {
        $0 % 2 == 0
    }
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// skipUntil()
let subject3 = PublishSubject<String>()
let trigger1 = PublishSubject<String>()

subject3
    .skipUntil(trigger1)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

// 跳过元素直到触发被观察者发出 .next 事件
subject3.onNext("1")
trigger1.onNext("---")
subject3.onNext("2")

print("---")

// MARK: Taking - 采取

// take(): 采取前 n 个元素
Observable
    .of(1, 2, 3, 4, 5)
    .take(2)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// takeWhile(): 采取元素直到不满足条件（index）
Observable
    .of(2, 2, 3, 4, 5)
    .takeWhile {
        $0 % 2 == 0
    }
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// takeWhileWithIndex(): 采取元素直到不满足条件（value & index）
Observable
    .of(2, 2, 3, 4, 5)
    .takeWhileWithIndex({ value, index in
        value % 2 == 0 && index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// takeUntil()
let subject4 = PublishSubject<String>()
let trigger2 = PublishSubject<String>()

subject4
    // RxCocoa
//    .takeUntil(self.rx.deallocated)
    .takeUntil(trigger2)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

// 采取元素直到触发被观察者发出 .next 事件
subject4.onNext("1")
trigger2.onNext("---")
subject4.onNext("2")

print("---")

// MARK: Distinct - 区分

// distinctUntilChanged(): 去除连续的重复元素
Observable
    .of(1, 2, 2, 3, 4)
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// distinctUntilChanged: 去除连续两个元素中满足条件的后一个元素
let formatter = NumberFormatter()
formatter.numberStyle = .spellOut

Observable<NSNumber>
    .of(10, 110, 20, 200, 210, 310)
    .distinctUntilChanged { num1, num2 in
        guard let wordsA = formatter.string(from: num1)?.components(separatedBy: " "),
            let wordsB = formatter.string(from: num2)?.components(separatedBy: " ") else {
                return false
        }
        
        var containsMatch = false
        
        for a in wordsA {
            for b in wordsB {
                if a == b {
                    containsMatch = true
                }
            }
        }
        
        return containsMatch
    }
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")
