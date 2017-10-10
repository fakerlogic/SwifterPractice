//: Playground - noun: a place where people can play

import UIKit

//: 将protocol的方法声明为 mutating
/// swift中的 protocol 不仅可以被 class 类型实现， 也适用于 struct 和 enum 。
/// 所以， 我们在写协议的时候要考虑是否使用 mutating 来修饰方法， 从而能够修改 struct 和 enum 中的变量
/// 而对于 class 而言， mutating 又是完全透明的，可以当做不存在
protocol Vehicle {
    var numberOfWheels: Int { get }
    var color: UIColor { get set }
    mutating func changeColor()
}

struct MyCar: Vehicle {
    let numberOfWheels: Int = 4
    var color: UIColor = UIColor.blue
    
    mutating func changeColor() {
        color = .red
    }
}

//: Sequence
/// 先定义一个实现了 IteratorProtocol 协议的类型
/// IteratorProtocol 需要指定一个 typealias Element
/// 以及提供一个返回 Element？ 的方法 next()
class ReverseIterator<T>: IteratorProtocol {
    typealias Element = T
    
    var array: [Element]
    var currentIndex = 0
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }
    
    func next() -> Element? {
        if currentIndex < 0 {
            return nil
        } else {
            let element = array[currentIndex]
            currentIndex -= 1
            return element
        }
    }
}

/// 和 IteratorProtocol 很类似，不过换成指定一个 typealias Iterator
/// 以及提供一个返回 Iterator? 的方法 makeIterator()
struct ReverseSequence<T>: Sequence {
    var array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    typealias Iterator = ReverseIterator<T>
    
    func makeIterator() -> Iterator {
        return ReverseIterator(array: self.array)
    }
}

let array = [0, 1, 2, 3, 4, 5]
for i in ReverseSequence(array: array) {
    print("Index \(i) is \(array[i])")
}


//: Tuple
/// 1.交换输入
/// old
func swap1<T>(a: inout T, b: inout T) {
    let temp = a
    a = b
    b = temp
}

/// with tuple
func swap2<T>(a: inout T, b: inout T) {
    (a, b) = (b, a)
}

/// 2.解决返回值只能为一个的情况
/// OC
/// CGRect rect = CGRectMake(0, 0, 100, 100);
/// CGRect small;
/// CGRect large;
/// CGRectDivide(rect, &small, &large, 20, CGRectMinXEdge);

/// Swift with tuple
/// extension CGRect {
///     public func divided(atDistance: CGFloat, from fromEdge: CGRectEdge) -> (slice:  CGRect, remainder: CGRect)
///
///     public func __divided(slice: UnsafeMutablePointer<CGRect>, remainder: UnsafeMutablePointer<CGRect>, atDistance amount: CGFloat, from edge: CGRectEdge)
/// }


//: @autoclosure 和 ??
/// @autoclosure 做的事情就是把一句表达式自动地封装成一个闭包 (closure)

/// 比如说我们有一个方法接收一个闭包,当闭包执行的结果为 true 的时候进行打印:
func logIfTrue(_ predicate: () -> Bool) {
    if predicate() {
        print("true")
    }
}

logIfTrue({return 2 > 1})
logIfTrue({2 > 1})
logIfTrue{2 > 1}
logIfTrue { () -> Bool in
    return 2 > 1
}

/// with @autoclosure
func logIfTrue2(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("true 2")
    }
}
logIfTrue2(2 > 1)
/// swift 会将 2 > 1 这个表达式自动转换成 () -> Bool. 这样我们调用的时候会简单很多

/// swift 中的 ?? 能够快速的对 nil 进行条件判断. 这个操作符可以判断输入并在当左侧的值是非 nil 的 Optional 值时返回其 value，当左侧是 nil 时返回右侧的值，比如：

var level: Int?
var startLevel = 1
var currentLevel = level ?? startLevel

func ??<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T {
    switch optional {
    case .some(let value):
        return value
    case .none:
        return defaultValue()
    }
}

var current = level ?? startLevel
/// 并不支持带有输入参数的写法，也就是说只有形如 () -> T 的参数才能使用这个特性进行简化。另外因为调用者往往很容易忽
/// 视 @autoclosure 这个特性，所以在写接受 @autoclosure 的方法时还请特别小心，如果在容易产生䈚义或者误解的
/// 时候， 还是使用完整的闭包写法会比较好。

/// practice
let flag: Bool = false
let flag2: Bool = true

func &&(lhs: Bool, rhs: @autoclosure () -> Bool) -> Bool {
    return lhs == true ? rhs() : false
}
flag && flag2

func ||(lhs: Bool, rhs: @autoclosure () -> Bool) -> Bool {
    return lhs == false ? rhs() : true
}
flag || flag2




