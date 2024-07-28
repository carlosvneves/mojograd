from memory.unsafe_pointer import UnsafePointer, initialize_pointee_copy, destroy_pointee
@AnyType
@value
struct Value(CollectionElement, Stringable):
    var data: Float64
    var label: StringRef
    var _op: StringRef
    var _children_ptr: UnsafePointer[Value]
    
    
    fn __init__(inout self, data: Float64):
        self.data = data
        self.label = "" 
        self._op = ""
        self._children_ptr= UnsafePointer[Value]()
    
    fn __init__(inout self, data: Float64, label: StringLiteral):
        self.data = data 
        self.label = label
        self._op = ""              
        self._children_ptr = UnsafePointer[Value]()
 
    
    fn __add__(inout self, other:Value) -> Value:
        var newValue = Value(data=self.data + other.data)
        var _children = List[Value](self, other)
        newValue._op = "+"

        newValue._children_ptr = UnsafePointer[Value].alloc(2)
        initialize_pointee_move(newValue._children_ptr.offset(0), self)
        initialize_pointee_move(newValue._children_ptr.offset(1), other)
        
        return newValue 

    fn __mul__(inout self, other:Value) -> Value:
    
        var newValue = Value(data=self.data * other.data)
        newValue._op = "*"

        newValue._children_ptr = UnsafePointer[Value].alloc(2)
        initialize_pointee_move(newValue._children_ptr.offset(0), self)
        initialize_pointee_move(newValue._children_ptr.offset(1), other)
        
        return newValue 

    fn __str__(self)->String:

        var message = "Value(data=" + String(self.data)
    
        if self._op != "" and self.label != "":            
            return  message + ", label=" + self.label + ", _op=" + self._op + ")"
        elif self._op != "" and self.label == "":
            return  message + ", _op=" + self._op +")"
        elif self._op == "" and self.label != "":
            return  message + ", label=" + self.label + ")"
        else:
            return message + ")"
    


fn f(x:Float64) -> Float64:
    return 3*x**2 - 4*x + 5

fn main():
    print("Micrograd - Mojo")
    var y = f(3.)
    print("y = ", y)

    var a = Value(data=2.)

    var b = Value(data=3.)

    var c = a + b 

    print(c)

    var cop= c._op

    print(cop)

    for i in range(2):
        print(c._children_ptr[i])

    # libera a memória
    destroy_pointee(c._children_ptr)



