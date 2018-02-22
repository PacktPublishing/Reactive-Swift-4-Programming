
import RxSwift
import RxCocoa

example(for: "catchErrorJustReturn") {
    
    let disposeBag = DisposeBag()
    let pubSubject = PublishSubject<String>()
    
    pubSubject.catchErrorJustReturn("Demon Error")
        .subscribe{ print($0) }
        .disposed(by: disposeBag)
    
    pubSubject.onNext("First element")
    pubSubject.onError(CustomError.test)
}

example(for: "catchError") {
    let disposeBag = DisposeBag()
    let pubSubject = PublishSubject<String>()
    
    let recoverySeq = PublishSubject<String>()
    
    pubSubject.catchError{
        print("Error=", $0)
        return recoverySeq
        }
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    pubSubject.onNext("First element")
    pubSubject.onError(CustomError.test)
    pubSubject.onNext("Second element")
    
    recoverySeq.onNext("Third element")
}

example(for: "retry") {
    let disposeBag = DisposeBag()
    var shouldEmitError = true
    
    let observableSeq = Observable<Int>.create { observer in
        observer.onNext(10)
        observer.onNext(20)
        
        if shouldEmitError{
            observer.onError(CustomError.test)
            shouldEmitError = false
        }
        
        observer.onNext(30)
        observer.onCompleted()
        
        return Disposables.create()
    }
    
    observableSeq.retry()
    .subscribe{ print($0) }
    .disposed(by: disposeBag)
}

example(for: "Driver onErrorJustReturn"){
    
    let disposeBag = DisposeBag()
    let pubSubject = PublishSubject<Int>()
    
    pubSubject.asDriver(onErrorJustReturn: 1000)
        .drive(onNext: {
            print ( $0 )
        })
        .disposed(by: disposeBag)
    
    pubSubject.onNext(10)
    pubSubject.onNext(20)
    
    pubSubject.onError(CustomError.test)
}

example(for: "Driver onErrorDriveWith"){
    
    let disposeBag = DisposeBag()
    let pubSubject = PublishSubject<Int>()
    
    
    
    let recoverySubject = PublishSubject<Int>()
    
    pubSubject.asDriver(onErrorDriveWith: recoverySubject.asDriver(onErrorJustReturn: 1000))
        .drive(onNext: {
            print ( $0 )
        })
        .disposed(by: disposeBag)
    
    pubSubject.onNext(10)
    pubSubject.onNext(20)
    
    pubSubject.onError(CustomError.test)
    
    recoverySubject.onNext(100)
}


print("... Example for: Driver onErrorRecover.....")
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let disposeBag = DisposeBag()
let pubSubject = PublishSubject<Int>()

pubSubject.asDriver{
    print( "Error:", $0 )
    return Driver.just(1000)
    }
    .drive(onNext: {
        print ( $0 )
    })
    .disposed(by: disposeBag)

pubSubject.onNext(10)
pubSubject.onNext(20)

pubSubject.onError(CustomError.test)

