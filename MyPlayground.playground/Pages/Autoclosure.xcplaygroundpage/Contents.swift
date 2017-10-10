//: [Previous](@previous)
import Foundation
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


//: [Next](@next) - [Table of Contents](table_of_contents)

