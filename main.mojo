from collections import Set

@value 
struct Value(Stringable):
    var data: Float64
    var label: Optional[String]
    var _op: Optional[String]   
    var _prev: Optional[List[Value]]

    fn __init__(inout self, data: Float64, label: Optional[String], _op: Optional[String], _children:Optional[List[Value]]):
        self.data = data 
        self.label = label.or_else("")
        self._op = _op.or_else("")
        var _prev = _children.or_else(List[Value]())
        self._prev = _prev


    # fn __init__(inout self, data: Float64, label: String, _children:Optional[List[Value]], _op:String):
    #     self.data = data         
    #     self.label = label 
    #     self._op = _op
    #     self._prev = _children.value()
    ###### "Resolver problema de referência a _prev" ##########
    fn __copyinit__(inout self, other: Self):
        self.data = other.data
        self.label = other.label
        self._op = other._op
        var prev = other._prev.value()
        self._prev = prev

    fn __moveinit__(inout self, owned other: Self):
        self.data = other.data
        self.label = other.label
        self._op = other._op
        var prev = other._prev.value()
        self._prev = prev

    fn __str__(self)->String:
        var op= self._op.or_else("")
        var label = self.label.or_else("")
        if op != "" and label != "":            
            return  "Value(data=" + String(self.data) + ")" + ", label=" + String(label) + ", _op=" + op
        elif op != "" and label == "":
            return  "Value(data=" + String(self.data) + ")" + ", _op=" + op
        elif op == "" and label != "":
            return  "Value(data=" + String(self.data) + ")" + ", label=" + String(label)
        else:
            return "Value(data=" + String(self.data) + ")"
    
    fn __add__(self, other:Value) -> Value:
        var prev = List[Value](self, other)
        var _op: String = str("+")
        return Value(data=self.data + other.data, label=str(""), _children=prev, _op=str("+")) 
        # return Value(data=self.data + other.data, label=None, _op=str("+")) 

    fn __mul__(self, other:Value) -> Value:
        var prev = List[Value](self, other)
        return Value(data=self.data * other.data, label=str(""), _children = prev, _op=str("*")) 
        # return Value(data=self.data * other.data, label=None, _op=str("*")) 


fn f(x:Float64) -> Float64:
    return 3*x**2 - 4*x + 5

fn main():
    print("Micrograd - Mojo")
    var y = f(3.)
    print("y = ", y)

    var a = Value(data=2., label=str("a"), _op=None, _children=None)

    var b = Value(data=3., label=str("b"), _op=None, _children=None)

    var c = a * b 

    print(a)

    print(b)    

    print(c)

    var cop= c._op.or_else("None")

    print(cop)

    

    
