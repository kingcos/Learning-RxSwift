//: Playground - noun: a place where people can play

import Cocoa
import RxSwift

let disposeBag = DisposeBag()

// MARK: Elements

// toArray()
Observable
    .of(1, 2, 3)
    .toArray()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---")

// map()
Observable
    .of(1, 2, 3)
    .map {
        $0 * 2
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---")

// mapWithIndex()
Observable
    .of(1, 2, 3, 4, 5)
    .enumerated()
    .map({ index, element in
        index < 4 ? element * 2 : element
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---")

// MARK: Observables

struct Student {
    var score: Variable<Int>
}

// flatMap()
let stuA = Student(score: Variable(80))
let stuB = Student(score: Variable(90))

let studentSubject1 = PublishSubject<Student>()

studentSubject1
    .asObservable()
    .flatMap {
        $0.score.asObservable()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

studentSubject1.onNext(stuA)
stuA.score.value = 85
studentSubject1.onNext(stuB)
stuA.score.value = 95
stuB.score.value = 100

print("---")

// flatMapLatest()
let stuC = Student(score: Variable(80))
let stuD = Student(score: Variable(90))

let studentSubject2 = PublishSubject<Student>()

studentSubject2
    .asObservable()
    .flatMapLatest {
        $0.score.asObservable()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

studentSubject2.onNext(stuC)
stuC.score.value = 85
studentSubject2.onNext(stuD)
// 最后一个被观察者 stuD 起作用，而 stuC 不再被观察
stuC.score.value = 95
stuD.score.value = 100

print("---")
