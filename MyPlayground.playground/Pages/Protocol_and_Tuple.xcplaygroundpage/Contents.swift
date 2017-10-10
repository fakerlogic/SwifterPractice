//: [Previous](@previous)
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
/*:
/// OC
 
 ```oc
 CGRect rect = CGRectMake(0, 0, 100, 100);
 CGRect small;
 CGRect large;
 CGRectDivide(rect, &small, &large, 20, CGRectMinXEdge);
 ```
/// Swift with tuple
 
 ```swift
 extension CGRect {
     public func divided(atDistance: CGFloat, from fromEdge: CGRectEdge) -> (slice:  CGRect, remainder: CGRect)

     public func __divided(slice: UnsafeMutablePointer<CGRect>, remainder: UnsafeMutablePointer<CGRect>, atDistance amount: CGFloat, from edge: CGRectEdge)
 }
 ```
 */
//: [Next](@next) - [Table of Contents](table_of_contents)
