//: Playground - noun: a place where people can play

import Cocoa
import RxSwift

let disposeBag = DisposeBag()

// MARK: Concatenate

// startWith()
Observable
    .of(2, 3, 4)
    .startWith(1)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// concat()
Observable
    .concat(Observable.of(1, 2, 3),
            Observable.of(4, 5, 6),
            Observable.of(7, 8, 9))
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

Observable
    .of("A")
    .concat(Observable.of("B"))
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

Observable
    .just(1)
    .concat(Observable.of(2, 3, 4))
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// MARK: Merge

// merge
let left1 = PublishSubject<String>()
let right1 = PublishSubject<String>()

Observable
    .of(left1.asObservable(),
        right1.asObservable())
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

left1.onNext("L-A")
left1.onNext("L-B")
right1.onNext("R-A")
left1.onNext("L-C")
right1.onNext("R-B")

print("---")


// MARK: Combine

// combineLatest
let left2 = PublishSubject<String>()
let right2 = PublishSubject<Int>()

Observable
    .combineLatest(left2, right2) { lastLeft, lastRight in
        "\(lastLeft) \(lastRight)"
    }
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

left2.onNext("L-A")
left2.onNext("L-B")
right2.onNext(1)
left2.onNext("L-C")
right2.onNext(2)

print("---")

Observable
    .combineLatest(left2, right2) { ($0, $1) }
    .filter { !$0.0.isEmpty }

Observable
    .combineLatest(Observable<DateFormatter.Style>.of(.short, .long),
                   Observable.of(Date())) { (dateStyle, date) -> String in
                        let formatter = DateFormatter()
                        formatter.dateStyle = dateStyle

                        return formatter.string(from: date)
    }
   .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

let left3 = PublishSubject<String>()
let right3 = PublishSubject<String>()

Observable
    .combineLatest([left3, right3]) { strings in
        strings.joined(separator: " ")
    }
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

left3.onNext("L-A")
left3.onNext("L-B")
right3.onNext("R-A")
left3.onNext("L-C")
right3.onNext("R-B")

print("---")

// zip()
Observable
    .zip(Observable.of(1, 2, 3),
         Observable.of("A", "B", "C", "D")) { obs1, obs2 in
            "\(obs1) - \(obs2)"
    }
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// MARK: Trigger

// withLatestFrom()
let button1 = PublishSubject<Void>()
let textField1 = PublishSubject<String>()

button1
    .withLatestFrom(textField1)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

textField1.onNext("maimieng.c")
textField1.onNext("maimieng.co")
button1.onNext()
textField1.onNext("maimieng.com")
button1.onNext()
button1.onNext()

print("---")

// withLatestFrom()
let button2 = PublishSubject<Void>()
let textField2 = PublishSubject<String>()

textField2
    .sample(button2)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

textField2.onNext("maimieng.c")
textField2.onNext("maimieng.co")
button2.onNext()
textField2.onNext("maimieng.com")
button2.onNext()
button2.onNext()

print("---")

// MARK: Switch

// amb()
let left4 = PublishSubject<String>()
let right4 = PublishSubject<String>()

left4
    .amb(right4)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

left4.onNext("L-A")
left4.onNext("L-B")
right4.onNext("R-A")
left4.onNext("L-C")
right4.onNext("R-B")

print("---")

// switchLatest()
let one = PublishSubject<String>()
let two = PublishSubject<String>()
let three = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()

source
    .switchLatest()
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

source.onNext(one)
one.onNext("1 - 1")
two.onNext("2 - 1")

source.onNext(two)
two.onNext("2 - 2")
one.onNext("1 - 2")

source.onNext(three)
two.onNext("2 - 3")
one.onNext("1 - 3")
three.onNext("3 - 1")

source.onNext(one)
one.onNext("1 - 4")

print("---")

// MARK: Combine - sequence

// reduce()
Observable
    .of(1, 3, 5, 7, 9)
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")

// scan()
Observable
    .of(1, 3, 5, 7, 9)
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .addDisposableTo(disposeBag)

print("---")
