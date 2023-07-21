# 🏦 은행창구 매니저

## 📖 목차
1. [소개](#-소개)
2. [팀원](#-팀원)
3. [타임라인](#-타임라인)
4. [시각화된 프로젝트 구조](#-시각화된-프로젝트-구조)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅](#-트러블-슈팅)
7. [참고 링크](#-참고-링크)
8. [팀 회고](#-팀-회고)

</br>

## 🍀 소개
임의의 수의 고객이 방문하고, 은행창구 매니저가 고객들의 예금, 대출업무를 처리합니다.
* 주요 개념: `LinkedList`, `GCD`, `Queue`, `DispatchQueue`, `DispatchGroup`, `Thread`

</br>

## 👨‍💻 팀원
| idinaloq | EtialMoon |
| :--------: | :--------: |
| <Img src = "https://user-images.githubusercontent.com/109963294/235301015-b81055d2-8618-433c-b680-58b6a38047d9.png" width = "200" height="200"/> |<img src="https://i.imgur.com/hSdYobS.jpg" width="200"> |
|[Github Profile](https://github.com/idinaloq) |[Github Profile](https://github.com/hojun-jo) |

</br>

## ⏰ 타임라인
|날짜|내용|
|:--:|--|
|2023.07.10.| Node 타입 추가<br>SingleLinkedList 타입 추가<br> |
|2023.07.12.| SingleLinkedList 메서드 추가 |
|2023.07.13.| Bank 타입 추가<br>Customer 타입 추가<br>코드 리팩토링<br>BankManager 구현 |
|2023.07.15|enqueueCustomers메서드 네이밍 수정|
|2023.07.17|대출 업무 기능 구현|
|2023.07.17|파일분할<br>work메서드 매개변수 수정<br>processBusiness추상화레벨 수정<br>전반적인 네이밍 수정|
|2023.07.19|numberFormatter타입 파일분할<br>BankingService타입에 CustomStringConvertible 채택|
|2023.07.20|measureStartTime, measureTotalTime메서드가 각각 Date, TimeInterval을 반환하도록 수정|


</br>

## 👀 시각화된 프로젝트 구조

### ℹ️ File Tree
```
BankManagerConsoleApp
├── BankManagerConsoleApp
│   ├── main
│   ├── Node
│   ├── SingleLinkedList
│   ├── Bank
│   ├── BankManager
│   ├── Customer
│   ├── BankingService
│   └── TotalTimeFormatter
└── BankManagerConsoleAppTests
    └── BankManagerConsoleAppTests
```

### 📐 Class Diagram
<p align="center">
<img width="1000" src="https://github.com/idinaloq/testRep/assets/124647187/3c8184ea-a1bd-475f-b833-9668d6a25b94">
</p>

</br>

## 💻 실행 화면 
<img width="500"
src="https://github.com/idinaloq/testRep/assets/124647187/17197f90-e5a0-4893-b98f-77dc2740c5e3">

</br>

## 🧨 트러블 슈팅

1️⃣ **Test Double** <br>

🔒 **문제점** <br>
- 유닛 테스트를 진행하는 과정에서 모듈에 접근 시 접근제어자 때문에 접근이 불가능 한 문제가 있었고, 해결 방법을 다음과 같이 고민해 보았습니다.
    1. 접근제어자 수정: 유닛 테스트의 목적은 프로퍼티, 메서드, 클래스 등을 코드 단위로 테스트하기 위해서 진행하지만, 만약 테스트를위해 접근제어자가 변경된다면 코드가 테스트에 종속되고, 캡슐화에도 문제가 있다고 생각해서 다음 방법을 고민했습니다.
    2. `extension` 사용: 접근제어자 수정을 대체할 방법으로 extension으로 테스트할 코드의 기능을 구현하는 것인데, 캡슐화에 문제가 없지만 테스트를 위해 코드를 작성한다는 부분에서 아쉬움이 있었기 때문에 선택하지 않고 다른 방법을 고민했습니다.
    3. 테스트 더블 사용: 테스트를 위한 객체를 만들어 실제 코드에서 접근제어자 때문에 테스트가 불가능하던 부분을 대신하고, 실제로 동작되어야 하는 코드의 변경 없이 테스트를 할 수 있기 때문에 이 방법을 선택했습니다.

- 하지만 `stub` 객체와 `real` 객체 간의 동일성을 보장할 수 없다는 문제가 있었습니다.

```swift
struct LinkedListStub<Element> {
    var head: Node<Element>?
    var tail: Node<Element>?
...
}
```

```swift
struct LinkedList<Element> {
    private var head: Node<Element>?
    private var tail: Node<Element>?
...
}
```

🔑 **해결방법** 
- `real` 객체에서 `private`인 `firstNode` 프로퍼티를 사용하는 메서드를 통해 테스트를 진행할 수 있도록 했습니다.
```swift
struct SingleLinkedList<Element> {
    ...
    mutating func currentFirstNode() -> Node<Element>? {
        return firstNode
    ...
    }
```

```swift
final class BankManagerConsoleAppTests: XCTestCase {
    ...
    func test_리스트에Node가있는경우_enqueue하면_firstNode는유지된다() {
        let firstInput: Int = 123
        let secondInput: Int = 456

        sut.enqueue(firstInput)
        let previousFirstNode = sut.currentFirstNode()
        sut.enqueue(secondInput)
        let currentFirstNode = sut.currentFirstNode()

        XCTAssert(previousFirstNode === currentFirstNode)
    }
...
}
```


2️⃣ **Linked List** <br>

🔒 **문제점** <br>
- `Bank`타입에서 고객들의 수 만큼 인스턴스를 생성해서 `enqueue`하는 `enqueueCustomers()`메서드를 구현했습니다. 하지만 3번 이상 `enqueue`를 하게 되면 `enqueue`가 되지 않는 현상이 있었습니다. 
- `SingleLinkedList`에서 `tail`을 지우는 것으로 수정하며 문제가 있었습니다.

**이전코드**
```swift
mutating func enqueue(_ data: Element) {
    let node: Node<Element> = Node(data: data)

    guard !isEmpty else {
        firstNode = node

        return
    }

    var nextNode: Node<Element>? = firstNode

    while nextNode?.next != nil {
        nextNode = firstNode?.next
    }

    nextNode?.next = node
}
```

🔑 **해결방법** 
- 처음 코드를 보면, 만약 새로운 노드가 추가 되었을 때 항상 첫 번째와 같은 값을 가지는 노드를 추가하고 있습니다. 이 때문에 잘못된 값이 계속 들어갔기 때문에 다음과 같이 수정했고, 두 차이점을 표현하면 다음과 같습니다.

**수정된 코드**

```swift
mutating func enqueue(_ data: Element) {
    ...
    while nextNode?.next != nil {
        nextNode = nextNode?.next
    }
    ...
}
```

**차이점**
|sequence|nextNode = firstNode?.next|nextNode = nextNode?.next|
|:--:|:--:|:--:|
|초기값|nil|nil|
|enqueue(1)|1 -> nil|1 -> nil|
|enqueue(2)|1 -> 2 -> nil|1 -> 2 -> nil|
|enqueue(3)|1 -> 2 -> 3 -> nil |1 -> 2 -> 3 -> nil|
|enqueue(4)|1 -> 2 -> 3 -> 3 -> ...|1 -> 2 -> 3 -> 4 -> nil|

3️⃣ **메서드의 역할과 매개변수** <br>

🔒 **문제점** <br>
- `GCD`를 활용하기 위해 `processBusiness`메서드 내부에서 프로퍼티를 만들고 이를 `work`메서드에 전달인자로 전달했는데, 이렇게 되면 결국 `BankManager`가 `work`라는 동작을 할 때 `group`과 `semaphore`와 같은 필요없는 정보들을 넘겨주는 문제가 있었습니다.

**이전코드**
```swift
struct BankManager {
    func work(for customer: Customer, group: DispatchGroup, semaphore: DispatchSemaphore) { ... }
}
struct Bank {
    private mutating func processBusiness() {
        var depositBankManagerNumber = 0
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 3)
        let startDate = Date()
}
```

🔑 **해결방법** 
- 다음과 같이 `Bank`타입이 아닌 `BankManager`타입에서 `group`과 `semaphore` 프로퍼티를 만들고 이를 `work`메서드에서 사용하도록 수정을 했습니다.
- 결과적으로 `Dispatch Queue`를 사용하기 위한 프로퍼티들이 `processBusiness`메서드를 실행할 때 마다 계속해서 생성되지 않게 되었기 때문에 `BankManager`가 `work(for: customer)`라는 동작을 할 때 어떤 기능인지에 대해 명확하게 나타낼 수 있게 되었다고 생각합니다.

**수정된 코드**
```swift
 struct BankManager {
    private let group: DispatchGroup = DispatchGroup()
    private let semaphore: DispatchSemaphore
    
    init(semaphore: Int) {
        self.semaphore = DispatchSemaphore(value: semaphore)
    }
     
    func work(for customer: Customer) { ... }
 }
```

4️⃣ **은행원을 나누는 기준** <br>

🔒 **문제점** <br>
- 은행원의 수가 3명이고 2명은 예금, 1명은 대출 업무를 처리해야 합니다. 은행원 1명당 하나의 `BankManager` 객체를 두는 것을 생각했지만 `BankManager`가 업무를 나누는 기준이 불명확했습니다.

**이전코드**
```swift
struct Bank {
    private let bankManagers: [BankManager]
    ...
    private mutating func processBusiness() {
        ...
        while let customer = customerQueue.dequeue() {
            ...
            switch customer.getBankingType() {
            case .deposit:
                bankManagers[depositBankManagerNumber].work(for: customer, group: group, semaphore: semaphore)
                depositBankManagerNumber += 1
            case .loans:
                bankManagers[2].work(for: customer, group: group, semaphore: semaphore)
            case .none:
                print("BankingServiceTypeIsNil")
            }
        }
        ...
    }
    ...
}
```

🔑 **해결방법** 
- 업무별로 `BankManager` 객체를 나누고 각각의 `DispatchSemaphore`를 조절해 스레드 하나를 은행원 한 명으로 볼 수 있도록 했습니다.

**수정된 코드**
```swift
struct Bank {
    private let depositBankManagers: BankManager = BankManager(people: 2)
    private let loansBankManagers: BankManager = BankManager(people: 1)
    ...
    private mutating func processBusiness() {
        let startTime: Date = measureStartTime()
        
        while let customer = customerQueue.dequeue() {
            switch customer.getBankingServiceType() {
            case .deposit:
                depositBankManagers.work(for: customer)
            case .loans:
                loansBankManagers.work(for: customer)
            case .none:
                print("BankingTypeIsNil")
            }
        }
        
        depositBankManagers.finishWork()
        loansBankManagers.finishWork()
        totalTime = measureTotalTime(startTime)
    }
    ...
}
```

</br>

## 📚 참고 링크
<!-- - [🍎Apple Docs: ]()
- [📘stackOverflow: ]() -->
- [🍎Apple Docs: Generics](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/#Naming-Type-Parameters)
- [🍎Apple Docs: CustomStringConvertible](https://developer.apple.com/documentation/swift/customstringconvertible)
- [🍎Apple Docs: DispatchQueue](https://developer.apple.com/documentation/dispatch/dispatchqueue)
- [🍎Apple Docs: DispatchGroup](https://developer.apple.com/documentation/dispatch/dispatchgroup)
- [🍎Apple Docs: DispatchSemaphore](https://developer.apple.com/documentation/dispatch/dispatchsemaphore)
- [📘blog: Linked List](https://supermemi.tistory.com/entry/Linked-list-연결-리스트-란-무엇인가)
- [📘blog: Main Thread와 Background Thread의 이해](https://velog.io/@yongchul/iOSThread의-기본개념)
- [🖥️video: Single Linked List](https://www.youtube.com/watch?v=R9PTBwOzceo)

</br>

## 👥 팀 회고

### 우리팀 잘한 점
- 프로젝트 요구조건에 맞도록 구현을 했고, 메서드와 타입의 추상화를 잘 했다고 생각합니다.
- 깔끔한 코드를 만들기 위해 기능 분리와 추상화 레벨을 맞추는 등 노력했다고 생각합니다.

### 우리팀 개선할 점
- 이번 프로젝트와 우리 팀만의 문제가 아니라고 생각하는데, 짝 프로그래밍에서 드라이버와 네비게이터의 역할이 모호해져 가는 것 같다고 생각합니다.
