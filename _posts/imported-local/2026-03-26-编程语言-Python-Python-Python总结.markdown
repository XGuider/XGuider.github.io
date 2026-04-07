---
layout: "post"
title: "Python总结"
subtitle: "编程语言 / Python / Python"
date: "2026-03-26 14:05:45"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Python
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/02-Python/Python/Python总结.md`

# 基础知识

# 1、数据结构常用模块

## 一、collections 模块

***from collections import Counter***

### 计数器（Counter）

dict(Counter(str/list))---**获取元素个数并返回字典，按照k排序**

Counter（str）返回按k值排好序的元素--''.join(Counter(str).elements())

Counter（str）.update(str2)--做加法

Counter（str）.subtract(str2)--做减法

most_common()-返回最常见的模块

### 双端队列（deque）--线程安全，0（1）的算法复杂度

***添加:***

appendleft(x) ， 将x添加到deque的左侧

append（x）右侧添加元素

具有list的相关属性（clear、count）

pop（）--移除和返回deque中最右侧的元素

popleft()--移除和返回deque中最左侧的元素

remove(value)--- 移除第一次出现的value

### 默认字典（defaultdict）

**d = defaultdict(int)  defaultdict可以用于计数**

重写了missing（key）--

default_factory（）---

defaultdict(list)--新建一个空的key-list字典与key_value不同

===>e.setdefault(k,[]).append(v)

### 有序字典（orderedDict）

与普通的dict()类似，

可以在其中使用sorted（）进行排序，

返回的字典OrderedDict(sorted(d.items(),key = lambda t:t[0]))

## 二、heapq模块--优先队列

创建:

```python
nums = [2, 3, 5, 1, 54, 23, 132]
heap = []
for num in nums:
    heapq.heappush(heap, num)  # 加入堆
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
nums = [2, 3, 5, 1, 54, 23, 132]
heapq.heapify(nums)
```
heapq.heappop() 函数弹出堆中最小值
删除堆中最小元素并加入一个元素，可以使用heapq.heaprepalce()

```python
返回最大最小值
import heapq
nums = [1, 3, 4, 5, 2]
print(heapq.nlargest(3, nums))
print(heapq.nsmallest(3, nums))
"""
输出：
[5, 4, 3]
[1, 2, 3]
"""
```


```python
合并两个不同的数组
import heapq
num1 = [32, 3, 5, 34, 54, 23, 132]
num2 = [23, 2, 12, 656, 324, 23, 54]
num1 = sorted(num1)
num2 = sorted(num2)
res = heapq.merge(num1, num2)
print(list(res))
```
## 三、bisect模块

```python
bisect.bisect_left(a,2)
```
insort模块--插入数据，仍保持原数据--insort（list,3）
**bisect_left 和 bisect_right 函数，用入处理将会插入重复数值的情况，返回将会插入的位置。**

**bisect_left(seq, x) x存在时返回x左侧的位置；bisect_right(seq, x) x存在时返回x右侧的位置；**

insort_left 和 insort_right 会进行实际的插入。insort_left(seq, x) x存在时插入在左侧插入；insort_right(seq, x) x存在时在右侧插入

## 四、Dict()：查找快，空间换时间

创建:{}/dict(([k1,v1],[k2,v2]))/{}.fromkeys((k1,k2),v)

访问:dict.keys()/values()/items()

判断:in/not in

清除:dic.clear()/del dic/dict.pop(key)/popitem

## 五、Set(）--无value值的字典

```python
s2={2,3,5}
```
并集:set1 | set2
交集:set1&set2

差补:set1-set2--包含在set1中且不在set2中

对称差分:两个集合的差别项set^set2

## 六、List():顺序查找，占用内存少

## 七、元组（tuple）--不可变的列表

## 八：内置函数

sorted（排序函数）：按照数组的大小，对Index排序

```python
Bindex=sorted(range(len(B)),key=lambda k:B[k])
```
sort与上面的类似，不过需要指定某个函数
```python
 def takeSecond(elem):
    return elem[1]
# 列表
random = [(2, 2), (3, 4), (4, 1), (1, 3)]
# 指定第二个元素排序
random.sort(key=takeSecond)
or random.sort(key=lambda x:x[1]
```
filter（过滤器）
```python
filter(lambda x: x%2,array)，使用对array的元素进行入参
filter 的使用
def is_sqr(x):
    return math.sqrt(x) % 1 == 0
newlist = list(filter(is_sqr, range(1, 101)))#
```
# 2、浅拷贝/深拷贝:

```plain
c=copy.copy(a)#对象拷贝，浅拷贝-->引用
d=copy.deepcopy(a)#对象拷贝，深拷贝--->创建新的空间，然后赋值
```
# 3、python垃圾回收机制

**引用计数：**Python在内存中存储每个对象的引用计数，如果计数变成0，该对象就会消失，分配给该对象的内存就会释放出来

**标记-清除：**一些容器对象，比如list、dict、tuple，instance等可能会出现引用----（从程序站和寄存器的引用出发遍历，对象之间通过引用（指针）连在一起，构成一个有向图，对象构成这个有向图的节点，而引用关系构成这个有向图的边）

**分代回收：**Python把内存根据对象存活时间划分为三代，对象创建之后，垃圾回收器会分配它们所属的代。每个对象都会被分配一个代，而被分配更年轻的代是被优先处理的，因此越晚创建的对象越容易被回收。根据年纪分不同的区域。

# **4、协程：**

1、由于python保证线程安全而采用的独立线程运行的限制，一个时刻运行一个线程。则采用GIL----------Global Interpreter Lock（全局解释锁机制）

2、比进程和线程更加的高级，不需要面临内核态和用户态的切换问题，导致浪费时间

3、Python 虚拟机按以下方式执行：a、设置 GIL；b、切换到一个线程去运行；c、运行指定数量的字节码指令或者线程主动让出控制(可以调用 time.sleep(0))；d、把线程设置为睡眠状态；e、解锁 GIL；d、再次重复以上所有步骤。

# **5、反射机制：**

 getattr:--根据字符串的形式去某个模块中寻找东西（获取方法）                                                                              hasattr:--根据字符串的形式去某个模块中判断东西是否存在                                                                                      setattr:--根据字符串的形式去某个模块中设置东西

delattr:--根据字符串的形式去某个模块中删除东西

# **6、魔幻函数：**

**三元表达式:**res='zuo' if x > y else 'you'

***args，**kwargs：**不确定需要传入多少个参数时使用，

*表示传入的是一个列表或者是一个元组。

**传入是一个赋值的字典或者一个等式

**下划线的各作用:**_

_name_：一种约定，**Python内部**的名字，用来与用户自定义的名字区分开，防止冲突

_name：一种约定，用来指定变量私有，只有类对象和子类对象能访问

__name：解释器用_classname__name来代替这个名字用以区别和其他类相同的命名，私有成员，只有类访问，不能被子类访问。同时也是防止被重写

**With操作：**

* 上下文管理协议（Context Management Protocol）：包含方法 `__enter__()`和`__exit__()`，支持该协议的对象要实现这两个方法。

* 上下文管理器（Context Manager）：支持上下文管理协议的对象，这种对象实现了`__enter__()`和`__exit__()`方法。上下文管理器定义执行`with`语句时要建立的运行时上下文，负责执行`with`语句块上下文中的进入与退出操作。通常使用`with`语句调用上下文管理器，也可以通过直接调用其方法来使用。

```python
 1 with EXPR as VAR:
3     BLOCK
1 class With_work(object):
 2     def __enter__(self):
 3         """进入with语句的时候被调用"""
 4         print('enter called')
 5         return "xxt"
 6 
 7     def __exit__(self, exc_type, exc_val, exc_tb):
 8         """离开with的时候被with调用"""
 9         print('exit called')
10 
11 
12 with With_work() as f:
13     print(f)
14     print('hello with')
++++++++++++++++++++++++++++++++++++++++
1 '''
2 enter called
3 xxt
4 hello with
5 exit called
6 
7 '''
```
1. 执行EXPR，生成上下文管理器context_manager；

2. 获取上下文管理器的`__exit()__`方法，并保存起来用于之后的调用；

3. 调用上下文管理器的`__enter__()`方法；如果使用了`as`子句，则将`__enter__()`方法的返回值赋值给`as`子句中的VAR；

4. 执行BLOCK中的表达式；

5. 不管是否执行过程中是否发生了异常，执行上下文管理器的`__exit__()`方法，`__exit__()`方法负责执行“清理”工作，如释放资源等。如果执行过程中没有出现异常，或者语句体中执行了语句`break/continue/return`，则以`None`作为参数调用`__exit__(None, None, None)`；如果执行过程中出现异常，则使用`sys.exc_info`得到的异常信息为参数调用`__exit__(exc_type, exc_value, exc_traceback)`；

6. 出现异常时，如果`__exit__(type, value, traceback)`返回False，则会重新抛出异常，让`with`之外的语句逻辑来处理异常，这也是通用做法；如果返回True，则忽略异常，不再对异常进行处理。


# 7、pandas取dataframe特定行/列

```python
from pandas import DataFrame
import pandas as pd
df=DataFrame(np.arange(12).reshape((3,4)),index=['one','two','thr'],columns=list('abcd'))

df = pd.DataFrame({"id": [25,53,15,47,52,54,45,9], "sex": list('mfmfmfmf'), 'score': [1.2, 2.3, 3.4, 4.5,6.4,5.7,5.6,4.3],"name":['daisy','tony','peter','tommy','ana','david','ken','jim']})

df['a']#取a列
df[['a','b']]#取a、b列
#ix可以用数字索引，也可以用index和column索引
df.ix[0]#取第0行
df.ix[0:2,'a':'c']#取第0、1行，abc列
也可以被用于替换操作
#df.ix[df['sex']=='f','sex']=0
#df.ix[df['sex']=='m','sex']=1
#loc只能通过index和columns来取，不能用数字
df.loc['one','a']#one行，a列
df.loc['one':'two',['a','c']]#one到two行，ac列
#iloc只能用数字索引，不能用索引名
df.iloc[0:2,0:2]#0、1行，0、1列
df.iloc[[0,2],[1,2,3]]#第0、2行，1、2、3列
#iat取某个单值,只能数字索引
df.iat[1,1]#第1行，1列
#at取某个单值,只能index和columns索引
df.at['one','a']#one行，a列
```
# 8、append()、extend()、concatenate()拼接函数

```python
import numpy as np
a=np.array([1,2,5])
b=np.array([10,12,15])
a_list=list(a)
b_list=list(b)
#只适用于简单的一维数组，对于大量数据的拼接一般不建议使用。
a_list.extend(b_list)
#对于参数规定，要么一个数组和一个数值；要么两个数组，不能三个及以上数组直接append拼接
np.append(a,10)
np.append(a,b)
#concatenate()比append()效率更高，适合大规模的数据拼接，能够一次完成多个数组的拼接.注：一般axis = 0，就是对该轴向的数组进行操作，操作方向是另外一个轴，即axis=1。

a=np.array([[1,2,3],[4,5,6]])
b=np.array([[11,21,31],[7,8,9]])
np.concatenate((a,b),axis=0)
'''
array([[ 1,  2,  3],
       [ 4,  5,  6],
       [11, 21, 31],
       [ 7,  8,  9]])
'''
np.concatenate((a,b),axis=1)  #axis=1表示对应行的数组进行拼接
'''
array([[ 1,  2,  3, 11, 21, 31],
       [ 4,  5,  6,  7,  8,  9]])
'''
```
# 9、叠加（stack,vstack,hstack,dstack）

```python
a = np.array([[1,2,3,4], [5,6,7,8]])
arrays = np.asarray([a, a , a])
np.stack(arrays, axis=1)
#也就是对第二维进行打包，取出第二维的元素[1,2,3,4]、[1,2,3,4]、[1,2,3,4]，打包，[[1,2,3,4],[1,2,3,4],[1,2,3,4]]，对其余的也做类似处理
array([[[1, 2, 3, 4],
        [1, 2, 3, 4],
        [1, 2, 3, 4]],
       [[5, 6, 7, 8],
        [5, 6, 7, 8],
        [5, 6, 7, 8]]])
tup=(a,b)
np.hstack(tup) = np.concatenate(tup, axis=1)
np.dstack(tup) = np.concatenate(tup, axis=2)
np.column_stack((a,b))函数将一维的数组堆叠为二维数组，方向为列
np.row_stack((a,b))函数将一维的数组堆叠为二维数组，方向为行
np.row_stack([np.array([1, 2, 3]), np.array([4, 5, 6])])
array([[1, 2, 3],
       [4, 5, 6]])
```
# 10、生成随机数

```python
import numpy as np
# 参数意思分别 是从a 中以概率P，随机选择3个, p没有指定的时候相当于是一致的分布#0-4
a1 = np.random.choice(a=5, size=3, replace=False, p=None)
# 非一致的分布，会以多少的概率提出来
a2 = np.random.choice(a=5, size=3, replace=False, p=[0.2, 0.1, 0.3, 0.4, 0.0])
a = np.random.random(4)#生成一个浮点数组
#array([ 0.0945377 ,  0.52199916,  0.62490646,  0.21260126])

```
# 11、清空list的几种方法

```python
lists = [1, 2, 1, 1, 5]
lists.clear()
#========================================
lists = [1, 2, 1, 1, 5]
lists = []
#========================================
lists = [1, 2, 1, 1, 5]
lists *= 0
#========================================
lists = [1, 2, 1, 1, 5]
del lists[:]
#========================================
first = []
last = []
lists_more = [1, 2, 3, 4, 5, 6]
for i in lists_more:
    first.append(i)
    last.append(first)
    first.clear()
print(last)
>>>[]
#========================================
first = []
last = []
lists_more = [1, 2, 3, 4, 5, 6]

for i in lists_more:
    first.append(i)
    last.append(first)
    first = []

print(last)
>>>[[1], [2], [3], [4], [5], [6]]
```
# 12、快速构建ndarray 对象

```python
import numpy as np
#构造一个长度为shape的未初始化数组，这个数组的元素可能是内存位置上存在的任何数值

ndarray = np.empty(shape=(2, 3), dtype=int)
print(ndarray)
"""
[[139639713229752 139639713229752 139639683772968]
 [       48942272 139639683773136 139639683772968]]
""""
#========================================
>>> np.zeros((5,), dtype=np.int)
array([0, 0, 0, 0, 0])
#========================================
# 构造一个2x3的数组，其中元素全部都为 7
ndarray = np.full((2, 3), 7)
print(ndarray)
"""
[[7 7 7]
 [7 7 7]]
#========================================
import numpy as np
n1 = np.linspace(-5, 5, 5)
print(n1)
# [-5. - 2.5  0.   2.5  5.]
n2 = np.linspace(-5, 5, 5, False)#endpoint 决定是否包括端点stop，默认为true，即包括stop点。
print(n2)
# [-5. - 3. - 1.  1.  3.]
```
# 13、yield、生成器和迭代器

yield可以看做“return”，返回某值，是程序中断。同样，也是生成器（generator）的一部分（带yield的函数才是真正的迭代器）。

```python
def foo():
    print("starting...")
    while True:
        res = yield 4
        print("res:",res)
g = foo()
print(next(g))
print("*"*20)
print(next(g))

1.程序开始执行以后，因为foo函数中有yield关键字，所以foo函数并不会真的执行，而是先得到一个生成器g(相当于一个对象)
2.直到调用next方法，foo函数正式开始执行，先执行foo函数中的print方法，然后进入while循环
3.程序遇到yield关键字，然后把yield想想成return,return了一个4之后，程序停止，并没有执行赋值给res操作，此时next(g)语句执行完成，所以输出的前两行（第一个是while上面的print的结果,第二个是return出的结果）是执行print(next(g))的结果，
4.程序执行print("*"*20)，输出20个*
5.又开始执行下面的print(next(g)),这个时候和上面那个差不多，不过不同的是，这个时候是从刚才那个next程序停止的地方开始执行的，也就是要执行res的赋值操作，这时候要注意，这个时候赋值操作的右边是没有值的（因为刚才那个是return出去了，并没有给赋值操作的左边传参数），所以这个时候res赋值是None,所以接着下面的输出就是res:None,
6.程序会继续在while里执行，又一次碰到yield,这个时候同样return 出4，然后程序停止，print函数输出的4就是这次return出的4.
```
yield组合成生成器进行实现，也可以用xrange(1000)（python2中）这个生成器实现yield组合。避免生成全部的数据以占用空间。
eg：for n in range(1000):生成器

a=n

迭代器：

迭代器是一个可以记住遍历的位置的对象。

迭代器对象从集合的第一个元素开始访问，直到所有的元素被访问完结束。迭代器只能往前不会后退。

迭代器有两个基本的方法：**iter()** 和 **next()**。

字符串，列表或元组对象都可用于创建迭代器：

```python
>>> list=[1,2,3,4]
>>> it = iter(list)    # 创建迭代器对象
>>> print (next(it))   # 输出迭代器的下一个元素
1
>>> print (next(it))
2
#========================================
class MyNumbers:
  def __iter__(self):
    self.a = 1
    return self
 
  def __next__(self):
    x = self.a
    self.a += 1
    return x
myclass = MyNumbers()
myiter = iter(myclass) 
print(next(myiter))......1。。。。。。。。。。
```
生成器:生成器是一个返回迭代器的函数，只能用于迭代操作，更简单点理解生成器就是一个迭代器
```python
import sys
def fibonacci(n): # 生成器函数 - 斐波那契
    a, b, counter = 0, 1, 0
    while True:
        if (counter > n): 
            return
        yield a
        a, b = b, a + b
        counter += 1
f = fibonacci(10) # f 是一个迭代器，由生成器返回生成
while True:
    try:
        print (next(f), end=" ")
    except StopIteration:
        sys.exit()
```
# 14、hasattr() 函数和getattr() 函数

**hasattr()** 函数用于判断对象是否包含对应的属性。   **hasattr(object, name)**

```python
class Coordinate:
    x = 10
    y = -5
    z = 0
point1 = Coordinate() 
print(hasattr(point1, 'x'))---->True
```
**getattr()** 函数用于返回一个对象属性值。     **getattr(object, name[, default])**
```python
>>>class A(object):
...     bar = 1
>>> a = A()
>>> getattr(a, 'bar')        # 获取属性 bar 值
1
>>> getattr(a, 'bar2')       # 属性 bar2 不存在，触发异常
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'A' object has no attribute 'bar2'
>>> getattr(a, 'bar2', 3)    # 属性 bar2 不存在，但设置了默认值
3
```
# 15、@classmethod与@staticmethod区别

在Python中有3种方式定义类方法分别是常规方式、@classmethod修饰方式、@staticmethod修饰方式。

接下来分别对3种不同方式的定义举例说明。

**普通方法:** 其实就是需要操作一些实例独有的属性，**是实例**而不是类。**第一个参数一般是隐式地将实例传递给self参数**。

**@staticmethod:** 静态方法其实就是一个普通的函数，可以使用类名直接调用，很多人不太明白的是为什么不直接把静态方法放在类外调用呢，毕竟效果一样，但是从代码逻辑从属来说，静态方法是一种组织或风格特征。如果**这个方法实现的功能与类比较相关的**话，放到了类里面更合适。

**@classmethod**: **类方法可以通过类或者实例对象调用**。一般情况下是作用于类相关的操作。**第一个参数不是类的实例对象，而必须是类对象**，在Python中这个参数常被写作**cls，因为全称class是保留字**。而被@classmethod修饰的函数内可调用类属性，但不能调用实例属性。对类作出的任何改变会对它的所有实例对象产生影响。

```python
class People():
    count = 0
    def __init__(self, name, gender):
        self.name = name
        self.gender = gender
        People.count += 1
    
    @classmethod
    def person(cls):
        return cls.count
    
p1 = People('Anders', 'Male')
p2 = People('Mary', 'Female')
p3 = People('James', 'Male')

print(f'People has {People.person()} little person objects.')

# 输出内容：
# People has 3 little person objects.
```
# 16、反转list的三种方法

现有a = [1,2,3,4,5],现需要进行对a进行反转


方法1：list(reversed(a))--reversed(a)返回的是迭代器，所以前面加个list转换为list

方法2：sorted(a,reverse=True)

方法3：a[: :-1]  其中[::-1]代表从后向前取值，每次步进值为1

# 17、descriptor新式类和经典类

python在2.2版本中引入了descriptor功能，也正是基于这个功能实现了新式类(new-styel class)的对象模型，

同时解决了之前版本中经典类(classic class)系统中出现的多重继承中的MRO(Method Resolution Order)的问题，

同时引入了一些新的概念，比如classmethod, staticmethod, super,Property等，这些新功能都是基于descriptor

而实现的。**新式类与经典类**

```python
#新式类
class C(object):
    pass
#经典类
class B:
    pass
```
# ![图片](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAABH8AAAFvCAYAAADTxWe+AAAgAElEQVR4Aeyd5ZscRRuvIUhw14RA8IQE9xDkxd2CE9wlOEFegr3YAYJDcHd3J+Q/q3Pdda5nTk2np2dWsjs7e3/oq3enq7qqq+4u+fVTT6222mqrJQ/LQAZkQAZkQAZkQAZkQAZkQAZkQAZkQAYGj4H/83/+D7rP4D2Yz2SdyoAMyIAMyIAMyIAMyIAMyIAMyIAMyMBqSfFH4UurLxmQARmQARmQARmQARmQARmQARmQgQFmQPFngCtXdVOFWwZkQAZkQAZkQAZkQAZkQAZkQAZkIIs/G220Udp1113THnvskY/NN9+8J8VvrbXWStttt10rHn+vueaaPcUljUiPtDfccMOe4o0HtBtvvHHabbfdWvmNfHOeOXNmWmeddfo272NZXltssUVtGVFO06ZNS2ussUZP5bTlllu27rPzzjunDTbYoKd4Tc86derUtP3227fuG3VIWk3xul3bZJNN0qxZs/J9d99998T/3eL083Xew1122aVVTtRpP+fXvNmJyYAMyIAMyIAMyIAMyIAMyEB3BrL4s99++6XHHnssvfLKK/n4z3/+09OEb9NNN01XX311K96VV16ZEEp6KfhjjjmmFe/RRx9Ne++9d0/xern3aIc54IAD0lNPPdXKb5QT59tuuy3NmDGjb/M+2mXRdL+TTjqptowop4ULF6b11luvp3Iq7/PAAw9kIaIp3V6ubbvttummm25aKX8nn3xyT3nqlMa8efPS0qVL832feeaZdOihh47ofp3SGavf586dmx566KFWOR1//PET+nnGqtxMp3tnYxlZRjIgAzIgAzIgAzIgAzIwfgxk8WfOnDnpjjvuSO+88076999/07333psOOeSQ1M0qAqHn/PPPT88//3z68ccf84Tx1FNPTTvttFPXCSOT5kceeSR9/PHH6fvvv0833HBD2nffffvSAmivvfZKd999d3r44YcTQtUnn3ySVqxYkY8XX3wxW01NZoi32WabdNhhh6UHH3ww/fPPP+nNN9/MZUV5UT6//PJLZuTEE0/MllKdygqBZv78+Vl8iPvcfPPN2RKlU5xef99qq63SJZdckl566aWcn6i/yy+/vCurTWnA+6+//ppZ+PnnnxPCVVP4sbyGFR5WSYiXvVokYeG2aNGiXIfLly9PiG+8q1tvvXXfPNdYlqFpjV/nZNlb9jIgAzIgAzIgAzIgAzIwegxk8YclMSzDwnKHSTGT2Ndeey0dfPDBjRO+KVOmZEufww8/PL311lvp999/T19//XWeZHerJKxAEA0WL16cBYMffvghCyssOekWd6yvUz4sf0FAQKBAHAvxQPFntXTUUUel9957L4sqMHDhhRfmsqK8sPD68MMPW2ycd955HesXi7P3338/3+e3337L99lss83S2muv3TFOrywghCCAHHfccemjjz5q1d8giz8s4cLaCYskLHp6KatoCy6++OL0559/5rpAFD7iiCN6it9LGoYZvQbcsrQsZUAGZEAGZEAGZEAGZEAGemEgiz8RcJ999smTRSw3fvrppyxyMCHv5gMIQeScc87JS6OY/GMJxP/48ol7151XX331hHCEAIQ1zaeffprTR3TqVz86iAi33nprSzyYzOIP4g7LgpYsWZL++OOPtGzZsnTdddclLMmivrE6effdd1vldcUVV7SuRZi4D5ZD3Afh8dprrx2V5V6RRpwPPPDALDCFeDdS8QffQeQVkYUlkLNnz17p+SLtsTxTB1g6vf7669mij6WdQ0kfsYi6pE55p7EAOvbYY7Oo13QfBLYjjzwynXvuuW0HFkhN8bxmhyUDMiADMiADMiADMiADMiADq46BNvGHgkaQYSLL5JglYPhrYYLbrRKId/TRR2fLH+KyZGTBggU9xcMCiOVUkSYTzW6CU7f8rKrrij//H8b999+/tVSQusNyDA7Ksu9F/Ikw8MZ9EIiq9ynvOZK/R1v8IS/kNY6R5G0041IXUZ5Y7gxV/InnQtCK9xJRmKWZTflE8H3uuedy2qQfB5ZETfG89v/fK8vCspABGZABGZABGZABGZABGRhtBlYSf0gAC6CrrroqT+xZxoUYg4XH+uuv3ziBw/Hxaaedlp544ok86cMCCOuDbj6AWAKGXxEsar744ou8TAgfRPw2Wg/MEjWsjG688cbaAx9HvaQ1FPGHXdTwAVOXZtVCppo2k/W6ePzGUqpOllHTp09PLK2qi3vRRRc1+typ5qHb/yH+IA6E+FONg6+YE044IeeJfJVWQTgMx2cOvp9Y9oeVCbyUYar3i/8RjOqekd9YhtZpqVhV/Hn11VdXug95Im+RVnlmGRrX69LmnamzcEE8RUSpi3PKKad09MeDAHr6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QAZkQAYGmAHFnwGu3PFWFk1fdVsGZEAGZEAGZEAGZEAGZEAGZEAGxp8BxR/FH9VdGZABGZABGZABGZABGZABGZABGZCBAWZA8WeAK1d1dfzVVevAOpABGZABGZABGZABGZABGZABGRhvBhR/FH9Ud2VABmRABmRABmRABmRABmRABmRABgaYAcWfAa7c8VYWTV91WwZkQAZkQAZkQAZkQAZkQAZkQAbGnwHFH8Uf1V0ZkAEZkAEZkAEZkAEZkAEZkAEZkIEBZkDxZ4ArV3V1/NVV68A6kAEZkAEZkAEZkAEZkAEZkAEZGG8GFH8GRPxZY4010oYbbpg233zzfGywwQZp9dVXT+uuu27rt7hGuDXXXLNN1SXs+uuvv1LYiLPeeuu1hS/BnTp1atp0001r45IWeSvDx9/VPEdanDfbbLPEfSOsZxtLGZABGZABGZABGZABGZABGZABGRgeA4o/AyL+IJZccMEFacmSJfk444wzsvAzf/781m9xbeHChWnrrbduE1bWWmutdPLJJ68UNuIcddRRbeHLF27vvfdOd999d23ciy++OG211Va1cbfYYot04YUX1sa755570r777lsbr0zbv4f34ltulpsMyIAMyIAMyIAMyIAMyIAMTB4GFH8GRPxBYLnxxhvThx9+mH7//ff01FNPpQMOOCBdeumladmyZfl455130s8//5xef/31dOyxx6Ztt922ZZWz9tprp4suuqgVNuJ8+umn6Z9//kmLFy9Ou+++e9pkk01aggzWQDvuuGO68sor06+//pq+/vrrVvxIi/scc8wxbWlNmTIlbbPNNglB6ZVXXkm//PJLevfdd1txuQ/PcPXVV6eddtopWyTZKE2eRsm6tq5lQAZkQAZkQAZkQAZkQAZkYHQZUPwZEPGHJVIzZ85MCxYsSB9//HH67rvv0muvvZaFmT333DNxIMIgtiAAvfXWWwkLIJZ68VKx7Gv69Ok5XITnjACDOPPll1+mpUuXpsMOO6wl/iAG3XfffTk9BKJ77723FR9x6dVXX22lhQVQLB0jr1gpvfnmm+mnn37KYtTxxx/fiosV0fLly9Mnn3ySHnjggTR79uxWmjYAo9sAWJ6WpwzIgAzIgAzIgAzIgAzIgAwMPgOKPwMi/sTLylKpt99+O61YsSIfiDdxbbvttktPPvlk6xrCzUYbbZSvY42z6667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yIAMyIAMyIAMyMB4M6D4o/ijuisDMiADMiADMiADMiADMiADMiADMjDADCj+DHDljreyaPqq2zIgAzIgAzIgAzIgAzIgAzIgAzIw/gwo/ij+qO7KgAzIgAzIgAzIgAzIgAzIgAzIgAwMMAOKPwNcuaqr46+uWgfWgQzIgAzIgAzIgAzIgAzIgAzIwHgzoPij+KO6KwMyIAMyIAMyIAMyIAMyIAMyIAMyMMAMKP4McOWOt7Jo+qrbMiADMiADMiADMiADMiADMiADMjD+DCj+KP6o7sqADMiADMiADMiADMiADMiADMiADAwwA1n82WmnndJFF12UrrnmmnT11VenPffcs6dK32CDDdKxxx6b4xH3mGOOSeutt15Pcffaa69WvAsvvDDNnDmzp3jjoRjusssuaeHCha388qxxnHrqqWnzzTfv27yvyvKaPn16WrBgQassokzqzkceeWSaOnXqpCynVVkH3nv8FXTrwDqQARmQARmQARmQARmQARnodway+HPYYYeld955J/3222/p33//TZdeemnaaKON0lprrdU4Wd9yyy3TPffck37++ef0999/p8ceeywhJK2zzjqN8SiUM888M33//ffpjz/+SF999VU68cQTE2LSGmus0TXuWBcqwsUHH3yQ8xt5XrFiReJ48cUX06677tp3eR6LMkLA4/l//fXXzA3lAT/8Tzlx/PLLL+mff/5JS5YsSdttt11PbIxF3k3DxlkGZEAGZEAGZEAGZEAGZEAGZGCyMJDFn6233jodfvjh6YEHHsiCxptvvpkWLVqUZs2a1ShqIPIgAFxxxRXp008/TV988UV69NFHswVQtwLE0uf4449PzzzzTPr999+ziIDoNG3atMY0u913VVzfdtttEwLQcccdl0WqZ599NpfTZBd/Nttss3TIIYekO++8M9ch5fHXX3+lxYsX57KivK699tr05ZdfZj4eeuihdMQRR/Rd/a4KZrynnYgMyIAMyIAMyIAMyIAMyIAMyEC/MNDm8wcxBuHnu+++S99++2264IIL0owZM7paa+y8887pvvvuS5999lm2ALr//vuzNcwmm2zSONFfffXVcxrvvfdeth56++23syCE2LLmmms2xh2vAiRft956q+JPsRbypJNOSj/99FMuE4Q8lsJF/RxwwAHp3XffbZUXQmFcizNLBXfYYYfMDFZUHDC18cYbrxQ24ni2EZUBGZABGZABGZABGZABGZABGZCB3hhoE3+22mqrtO+++6aHH344W3C8//77Wejo5o9n/fXXzxN2JvY//vhjtvR47rnnulp5IP7gN+Y///lPeumll/ISIcSnWHbWj5Wo+LMyWCMVf3bfffe8fPCFF15IcTz11FPp0EMPVfwpRLZ+fB/M08rvg2VimciADMiADMiADMiADMiADPQbA23iD5lDkDn55JMTS5u+/vrr9OGHH2brnN122y2tvfbajZNxHEXfe++9CdEI3y933XVXwvKjm0NkLIQuvvji9PLLL2cLIPzInHDCCaPqBJrnwh/RvHnzao9uAldU3FDEH5bFsXSuLk2EjW222aZjeeIfpy4ev2EZ08kyCmuZvffeuzYuwt6mm27aMc14xqGeRyr+wAjWXywbiwO/QaUF0VDzZHgbWxmQARmQARmQARmQARmQARmQARn4fwysJP5QMAgI+PJ5+umn059//pkdMuMDqJtwsO6662ZBAz8vTOJ/+OGH7MvnwAMPbBQccPKM/5ijjz46O55m4v/5558ndgEbrYoiDSyKPvnkk9qDJW69pDUU8QdLKvzh1KWJQMZOaZ3SPOOMM2rjca/rr78+bbjhhrVx58yZk5544onauAh6CECd0hzu74o/NqjDZcd4siMDMiADMiADMiADMiADMiADq56BWvGHgkdcwPICB874AGI5FtY5iAvdKmb//fdPt99+exZyWAaGBRAOpbv5AMLZMyIMIgW+Yziffvrp2WKnW5pN17GUOfvss/OSInaf4qFvu+22fCxdujSnhePpXtIaivjD83LPSCvOr732Wt4B68EHH8wCUGkBhI8lxJTHH388LV++PItnEY/fENSWLVuWy2n27NmtumDpHc6XEenYPe2jjz7KjpeJiwCF2EQ9Ui9YD7GbW1OZDeVaKf7g8BnH4ezmxkF+woIMR9B1S7m23377dMkll7SV04033pjmzp07ankcyvMYdtU3PJaxZSwDMiADMiADMiADMiADMiADY8dAR/GHZVIIHfvss08WGxAimNhfd911XSfkWNlMnTo1+wti+RfbwD///PMJ3y5NlRtp4ngah9NsEc7284gITfG6XTvvvPOyBRPPgEXRUUcdlZewsYyNLeYRRUgLYQiLm6b7DUX8iechnfLAAgnLKMoFUaYURI455pgslpAf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BmRg7BhQ/BkQ8QcrmqOOOiotXrw4ffPNN+mdd95JN954Y7r88svTwoUL83HTTTeljz76KH3++efp7rvvTkceeWRC9OGFW3PNNbMVToSNM4LSH3/8kV5++eWEAFRaAE2bNi2dffbZCYHnzz//TM8//3wrrZtvvjmn9dlnnyWEqCOOOKItrfnz56c777wzffrpp+mTTz7JwlOkuXTp0vTXX38lRKpzzjknbbfddrXikQ3F2DUUlrVlLQMyIAMyIAMyIAMyIAMyIAMTlwHFnwERf+IlZLnX22+/nVasWJGPq6++uiWcIKIg1MS1++67r7X8a/XVV0/rrLNO/p8lYXGcddZZ6aeffspxsAI67bTTWvfbe++904svvph+++239O+//6YbbrghWxux3Iy0HnzwwfTjjz/m45ZbbkkbbLBBjks6CFE///xz+vvvv9MLL7yQ9txzz7Tuuusm8oG1UsR79dVX03777ddKM57T88RtdKw7604GZEAGZEAGZEAGZEAGZEAGxpYBxR/FnyysYPlz4oknJgSh8njllVeyFQ6CUVX82XzzzRP+g7Ai4hrWRljz7LPPPgkfRPvvv3864YQT8jF37txsXcQLjn+hOXPmpIsvvjjHYcnY448/nv38YIm08847t+JhIbTFFlso/gwYpzb0Y9vQW96WtwzIgAzIgAzIgAzIgAxMbgYUfwZsUj0cy59NN900zZ49Oz388MNZ6GGpFkIOx5dffpmWL19ea/kTjcdhhx2WXnrppRx+2bJlacGCBVnAQcTZdttts+PpCFueuXbbbbe10sI6CFGIePgkqjqlLuP69+RuuKx/618GZEAGZEAGZEAGZEAGZEAGemdA8UfxJx133HF56RUWOIg9WOSw1IrjuuuuS7/++muj+IMFEEvACH/QQQdlX0PPPfdc4iA+Ik/dS8nyr1122aWV1rnnnpv9/BDviSeeSIccckhtvLp7+VvvL71lZVnJgAzIgAzIgAzIgAzIgAzIwORioE38YZLOhLs8sMQIXy2d4MDZMMt6ynhs4d1p0h/3wb8LO0GV8fib7cnXWmstJ/7DEKaGY/lzySWXtPwA4RCaOog6YikY/nfqln1tvPHGeXv4qD/8/ODvByfQ+AJix6633nornXnmmdmah6Vl3JdlX1j2RDysjtZbb710wAEHpIceeig7isbJNLuPISptsskmrfxE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kAEZkIGJzUCb+HPWWWeln3/+ue145plnulr+zJ49Oy1durQt3o8//phOP/30RgEH8efaa69ti0f6ixcvTptuumljXMGb2OBZf9afDMiADMiADMiADMiADMiADMiADIwNA23iDz56TjrppLbj0EMP7erzB6Fm3rx5bfG4z8yZMxsFHHz+YFVUTXOfffbR588AO5ry5R6bl9tytpxlQAZkQAZkQAZkQAZkQAZkQAZgoE38EQqhkAEZkAEZkAEZkAEZkAEZkAEZkAEZkIHBYkDxRwubRussX/jBeuGtT+tTBmRABmRABmRABmRABmRAvNqHOgAAIABJREFUBiYfA4o/ij+KPzIgAzIgAzIgAzIgAzIgAzIgAzIgAwPMgOLPAFeuau7kU3Otc+tcBmRABmRABmRABmRABmRABmSgyoDij+KP6q4MyIAMyIAMyIAMyIAMyIAMyIAMyMAAM6D4M8CVW1X6/F/1VwZkQAZkQAZkQAZkQAZkQAZkQAYmHwOKP4o/qrsyIAMyIAMyIAMyIAMyIAMyIAMyIAMDzIDizwBXrmru5FNzrXPrXAZkQAZkQAZkQAZkQAZkQAZkoMqA4o/ij+quDMiADMiADMiADMiADMiADMiADMjAADOg+DPAlVtV+vxf9VcGZEAGZEAGZEAGZEAGZEAGZEAGJh8Dij+KP6q7MiADMiADMiADMiADMiADMiADMiADA8xAFn8222yztM8++6SDDjooH9tss01Plb722munXXfdtRVvl112SWuttVZPcbfddttWvL333jttuummPcUbLYVyww03THPmzGnlgWc/4IAD0lZbbdWYj9VXXz3NnDmzFW/WrFlpvfXWa4wzmnmeO3duK+3tttuuY7pbbLFF2m+//Vpho2451+V5ypQp4/Zco1U+3mfyqdfWuXUuAzIgAzIgAzIgAzIgAzIgA90ZyOIPgsDzzz+f3n///Xwcf/zxHUWFslA333zztGjRola8G2+8MW2yySY9xT3ppJNa8ZYuXZqFl/Leq/rv3XffPT388MOtPPDs77zzTjrmmGMa87/mmmumSy65pBXvvvvuy6LJqs4v90e0efTRR1tpL1iwoGNeDzvssPTKK6+0wkbdcl68eHGaMWNGW1yEvMsuu6wVnjBN4tJYPK9pdH+BLSPLSAZkQAZkQAZkQAZkQAZkQAZkoBsDWfxBCLn++uvTsmXL0r///pseeuihdPTRRyesc5pugPXMGWeckZ544on0/fffp9dffz2df/75afbs2Y3xuOeBBx6YRQjEiB9//DHddtttad68eT2LR0356uUawgYizgsvvJD++OOPtGLFivTXX3+ls846qzHviD+33nprDk+cF198MVs/9ZLmcMNgWYRV0g033JC+/PLL9PHHH6f//ve/6fDDD18prwhy/I5489tvv6W333473X333flA7Priiy/SBx98kK644oqExVVYavFciH6EIQ3CXH755WmvvfZqhRlu/o1nQyQDMiADMiADMiADMiADMiADMiAD48dAFn+Y+K+77rpp4cKFWdT4888/swUI1iNNlcMSqKlTp2Zh4o033kh///13+vXXX9NVV13VGI97kibi0e23356WL1+efv/99/TMM8+k3XbbrWvcpjz1eo1lTuuss0465ZRT0nfffdfX4s+0adOyIEcZUVZLlizJwlwIN+UzI9Zg8YOghZCHYIR4xMESvaeffjr9888/ubzvuOOOXAfEpy6x/qH8qYcIQ/1QT2Ua/j1+L6xlb9nLgAzIgAzIgAzIgAzIgAzIgAwMlYEs/kQkfOBg7fHqq6+mX375JVuBII5sueWWjZN//OQQDqsRxB/EB+6zxx57NMZDcGDJ2U033ZQtTbBKwUrlyCOPHDM/Oscee+yQxB9Eo4MPPjgvkWKZ1IknnpiwtokyHM3zGmuskQ499NB0yy23pI8++ih99tlnWSybP39+Ft3KtDbaaKPEs7AM7dtvv80WP9ddd13ad999W3nD2unJJ59sWS0RlnjV+7D0jWuIYlgOcR/8B5Xh/NvGRgZkQAZkQAZkQAZkQAZkQAZkQAYmBgNt4g+VhiBzzTXXZBEHSx6Wgu2///5ZbOBaU8Wy3AiRAsshLFQuvPDCLOJg5dMUD/GIZUxh2fLII49knzRYojTFG+o1rJTWX3/9tuPUU0/tKv6QfyxnqnH5H+shBKFqXurS4jfKEIuduBf3rSsfwuAEGzEsLKMQbnbaaaeV0iLtXoSd6dOnZwsihD2O0vKnmn+WhJUWRCwL7JTXalz/nxgvv/VkPcmADMiADMiADMiADMiADMjA5GBgJfGHisdnzwUXXJBYyoX1Bz59Tj/99K7Lf/ARhNUIPoNYcvTaa69lq5FuS7lYcoZlybXXXputWz799NO8tOmoo46qFTqGAycCDXnDF0559OLzBwumm2++uS1e3INy2nrrrdvyicUOVjgRJs5YRyGgYDkUvyG0sUta9ZkOOeSQdO+992aLKOoAx9rEq1rqRLxexB8EJ3wHnXzyyflo8udT+g5ClMMCCL9MiEKRpufJ0UhYz9azDMiADMiADMiADMiADMiADExsBmrFHyqVyT/LsVhqhP8YfMWwhIht4btVeuzkhSPnr7/+Op1zzjnZRw2WL01x8Unz4IMPpq+++ir7nLnnnnvyTloj9Tmz8cYbp5133jk98MAD2akzy8ti96tIq8nhM0uvXnrppVYcnovwnRw+Y8mDM2kcM7MMLsLef//92aH1xRdf3PqNvOBkeptttsk+d6J8yjDcB2fYca3u3Iv4Uxev228sa4vnRQQ67bTTGvPR7X5en9gNhvVn/cmADMiADMiADMiADMiADMjAxGOgo/jDkissUs4999z04YcfZj8yWMmwTKpbRSNk4Mvnsccey8IRViNsA1/dXrx6H0QerGywhkFw+Pzzz9NTTz2Vujmert6n+j8WRDgxRmjBHw47XbHbGAf+bH766acsxnTa7QshDOGL8FjkPP744y3xpm63L5Z27bDDDtkfENZPTeIPgspbb72V84Fj58i74s/Ee5mi7jxbdzIgAzIgAzIgAzIgAzIgAzIgA/3EwKQQf/A9FAIMlkw4TI5KGKrDZ6x6et3qHTGnFIqee+65hBCFVdCzzz6bt1SPfD3//PNtW8Yr/thQBKOeZUEGZEAGZEAGZEAGZEAGZEAGZGAkDHQUf7B2wc8N1jcs+yIg1i84Ie6WYHXZ14IFC/Kypl6WfeEviKVibDWOXxwsaEa67KtfxB+cLOMQ++qrr85WVWzZrvjjC9ztffK6jMiADMiADMiADMiADMiADMiADIyEgVrxh6VXODJ+8803s8NnrFfw9bLBBhs0Cj/h8Jkt33H4zJbxLKvqxeEzO4oRFsscHD7jn2e0HD73i/jzySef5F3N2BUtnEKzmxfH+eefn9j1LCoT5874PPrggw9yHbDdO0vORsPhM46nOXDezK5ikWZ51uGzDUvJg3/LgwzIgAzIgAzIgAzIgAzIgAxMXAZWEn9iq/fffvstxVbv7MQV25Q3VXbdVu/s5FW3lXl5n7qt3nFgPFpbvfeL+IMzawSyEFx4Pnb/4qB8yy3jCbPJJpu0bfWO/6Ox3Ood8Q6rL4Q8t3qfuC95+a75t/UoAzIgAzIgAzIgAzIgAzIgA5OPgTbxZ86cOenyyy/PFjssUWIJFtuCb7nllrXWIQEM4g2OoLH4YXerV155JV122WXZeXOEqTsjNGHhwq5iWLjgkPmuu+5KRx55ZBZE6uIM57d+EX9it69enwHrIKx9sPphuRhL8O64446EyFZdQsfSOLayv++++7JT63feeSdbUrFUL9LrZUcwdkbDDxL3YYt5nHVjkVXeJ+7nefI1GNa5dS4DMiADMiADMiADMiADMiADE4+BLP5gmYOFzsKFC7MPmj///DNva95tly3EG0SIAw44IL3xxhvZUgjx56qrrmoJDp2gIE0Ei9tvvz0tX748sesVO3J1WyLW6X5Nv7PVPGIWu3khMCGShMXNCSeckJeZcY2D5VeUBcJL3JO8RnjEkTvvvLPlq+fll19Oe+21V+t6adXD9vJY64Rfn6rlT9y/2xnH0QhxlBFlha+g0oKojE9eEN/CYueGG25o5W3XXXdNTz/9dPanxL0QksKfEnWJJRLlTz3gc4kw1E+EKdPx74n3sltn1pkMyIAMyIAMyIAMyIAMyIAMTE4Gsviz++6752U9y5Yty0t8EBqOPvroLDA0gYEocMYZZ6Qnnngiff/99+n111/P4sns2bNbwkmn+GybjkPn999/P2/rftttt6V58+blpU6d4gz3d5ZK4bOI3bYQp9hpK3ztYNXCMzz66KNZWEE4Yat5hJJIj+fBOok4kecQdL755pu8pX3cr/TnQzkiNkXY0udP3LuXM8ITAhtCzpdffpk+/vjjlu+gavzSVw9L97DcibxhmUV+sLJiu/vS5w8C1/HHH5+tt0iDMFiBlWGqafn/5Gw0rHfrXQZkQAZkQAZkQAZkQAZkQAYmFgNZ/DnooIMSW40jxHAgAvRSkQgNixYtasW78cYbexZvYkcw0lu6dGkWN3pJc7hhsOTBsimeMc6IPzhRZnlb/IblC36OIq1DDz00YeET15vO5557bvZxdOmll3YMT5i491DOs2bNyiJVpM8uap3iY7WFkBVhyzMC1owZM9riYvXDUr0IRxiWiXW6v79PrBfd+rK+ZEAGZEAGZEAGZEAGZEAGZGDyMpDFn8022yxbeGCNw7H11lv3NOlHMNhll11yHOKxzCmWPXWDaptttmnFY6lSL1vId7tn03WWNbFtfDxjnLEKwuqFZVTxG/nB2XLcD5ELnzdxvemMYNIprYg3XFEFSyv8MvVyn6Y8Y+mFNVE8H2ecTc+cObN177owZXj/nryNhnVv3cuADMiADMiADMiADMiADMjAxGIgiz9W2sSqNOvL+pIBGZABGZABGZABGZABGZABGZABGeiVAcWf1YSlV1gMJysyIAMyIAMyIAMyIAMyIAMyIAMyMPEYUPxR/Glb/uVLPPFeYuvMOpMBGZABGZABGZABGZABGZABGWhiQPFH8UfxRwZkQAZkQAZkQAZkQAZkQAZkQAZkYIAZUPwZ4MptUv28piosAzIgAzIgAzIgAzIgAzIgAzIgA5ODAcUfxR/VXRmQARmQARmQARmQARmQARmQARmQgQFmQPFngCtXBXdyKLjWs/UsAzIgAzIgAzIgAzIgAzIgAzLQxIDij+KP6q4MyIAMyIAMyIAMyIAMyIAMyIAMyMAAM6D4M8CV26T6eU1VWAZkQAZkQAZkQAZkQAZkQAZkQAYmBwOKP4o/qrsyIAMyIAMyIAMyIAMyIAMyIAMyIAMDzIDizwBXrgru5FBwrWfrWQZkQAZkQAZkQAZkQAZkQAZkoImBNvFnxx13TCeddFLtse+++6apU6fWKoGbbrppmjdvXiverFmzasM1ZaSfr02bNi0dc8wxrecry+jggw9OG2200UA971jXxeabb54OP/zwVvnuuuuufVueG264YTrwwANbeZ07d25ac801+za/1CV5Puigg1p5Dn533nnnUcv32muvnfbaa6+V0oi0dtppp1FLa6z5nOjpbbvttuk///lPq25o5/v1mSZiX7LZZpu19X8wf+KJJ6YddtihsZynTJmS5syZ06oX+5L/P1jbZZddWuVC37Dllls2luV48jxjxox0/PHH5/wed9xxabvttuvbvEY5bb/99q08Rxs9f/78RF8cYSbjeeutt05HHXVUi71+7rc22WSTdOihh7byOnv27L6tu3XWWScxhwjW4jxoc4XJ8M6sscYabf0WY0vGmP367Mwngrd+70v6tQwne77QPvbZZ58WR/vtt19ab7312pivhgnm9thjj7T66qu3he2H8mwTf84666z0yy+/1B733HNPx4EBD/fcc8+14l111VV996AjKWwGA5988knr+coyeuqpp9JoTqJHks+JGpdBwWuvvdYq34svvrhv+WFC97///a+V10WLFqV11123b/MLE0z2H3/88Vaeg9/zzz9/1PK98cYbpzvvvHOlNCKtc889d9TSmqicj1e+mdS9//77rbo588wz+7Yuqn3JlVde2bd5jfpEAH7xxRdb5Qvz33//fTr11FMb877WWmulG264oRWPvqSfJ5vxvGNxvvDCC1vlsmzZsnTAAQc0luVY5KlTGieccEL6+uuvc36/+OKLhADUKWy//M7A9Ntvv22VMcy+8sorWcDvlzyORz4QU955551WuSxYsKBv63L33XdPzzzzTCuv1157bV9OMqhHxNv77ruvldcYFwzaXGE8mB3rNJnk3nTTTa26ZGzZzx+ULrroolZe6Uv233//vn2nx7ouTe//f3BqKgs+St59990tjh544IHEh4IyDmEWL17cChNt3HXXXZcQTMuw/fB3m/hz3nnnpRUrVuSDjD/88MPpiiuuyAcCSFXpigdg8MtLFXEZ0Ma1QTgzIL/gggtyOdBZlc/KoL+fLVUmQvkzsH/vvfda/MBcv+abTo4BV7B+1113dXwv+uUZsExggrJkyZL0448/tvK+cOHCUStnvuzxVSXaiwcffLAtrVUp6PEV++yzz05YTgxFYUe0I89M0rfaaqtRK4t+qffIB233l19+2ar3fhbi9txzz7b29frrr+/7etlmm23SaaedlkXh33//PZfzX3/9lbqJbIg/t912W6teXnjhhVXWlzD4OOSQQxIfeCaCZcqll17aKpcPPvggv9vBc7+daT9+/fXXnN+ff/45fx3stzxW84NwcMkll6SXXnqpVc6IHnyIqYadTP/TH3z22WetMmHc16/Pj6UPgl2MRW6++eYh9X9j9VxYSt944435AwT9EJOoRx55JL8z5J93HdF/rPLTj+lgOXP00UfncVq/W98h/txxxx0t7vjw388fwC+77LJWXvkIhqVSPzIwXnmizaedG6s6hB/aWcZMjJ2G8txYCtJvMU4cSryRhmUOheATbS0GAFjUl/dlPnHkkUcm5oR8BIqwGAiMlfhDO0p7ikV5mbe6vzuKP2SeB6mLVP1t0MWf8nlZ4nPrrbe2KlbxpzfltCzD6t+KPyMvw2qZ1v3PV82PPvqoxe5oij/V9FgGirVcNICrQvxh2QwdCUsyP//88/xe9roEj4n39OnTs8D9xhtvDPQXb8WfsXm/sPj47rvvMvO9ij9M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)

内置的object对象是所有内置，object对象定义了一系列特殊的方法实现所有对象的默认行为。

1. __new__，__init__方法

这两个方法是用来创建object的子类对象，静态方法__new__()用来创建类的实例，然后再调用

__init__()来初始化实例。

2. __delattr__, __getattribute__, __setattr__方法

对象使用这些方法来处理属性的访问

3. __hash__, __repr__, __str__方法

print(someobj)会调用someobj.__str__()， 如果__str__没有定义，则会调用someobj.__repr__()，

__str__()和__repr__()的区别：

* 默认的实现是没有任何作用的

* __repr__的目标是对象信息唯一性

* __str__的目标是对象信息的可读性

* 容器对象的__str__一般使用的是对象元素的__repr__

* 如果重新定义了__repr__，而没有定义__str__，则默认调用__str__时，调用的是__repr__

* 也就是说好的编程习惯是每一个类都需要重写一个__repr__方法，用于提供对象的可读信息，

* 而重写__str__方法是可选的。实现__str__方法，一般是需要更加好看的打印效果，比如你要制作

* 一个报表的时候等。

```python
class CLanguage:
    def __init__(self):
        self.name = "C语言中文网"
        self.add = "http://c.biancheng.net"
    def __repr__(self):
        return "CLanguage[name="+ self.name +",add=" + self.add +"]"
clangs = CLanguage()
print(clangs)
##CLanguage[name=C语言中文网,add=http://c.biancheng.net]
```
可以允许object的子类重载这些方法，或者添加新的方法
# 18、装饰器

Python装饰器看起来类似Java中的注解，然而和注解并不相同，不过同样能够实现面向切面编程。想要理解Python中的装饰器，不得不先理解闭包（closure）这一概念。

闭包：`msg`是一个局部变量，在`print_msg`函数执行之后应该就不会存在了。但是嵌套函数引用了这个变量，将这个局部变量封闭在了嵌套函数中，这样就形成了一个闭包。 

```python
# print_msg是外围函数
def print_msg():
    msg = "I'm closure"
    # printer是嵌套函数
    def printer():
        print(msg)
    return printer

# 这里获得的就是一个闭包
closure = print_msg()
# 输出 I'm closure
closure()
```
**装饰器:**
```python
import functools
def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print('call %s():' % func.__name__)
        print('args = {}'.format(*args))
        return func(*args, **kwargs)
    return wrapper
    
@log
def test(p):
    print(test.__name__ + " param: " + p)
#输出  
#call test():
# args = I'm a param
#test param: I'm a param
test("I'm a param")
与下面代码相同
def test(p):
    print(test.__name__ + " param: " + p)
wrapper = log(test)
wrapper("I'm a param"）
```
**传参的装饰器**
```python
import functools
def log_with_param(text):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            print('call %s():' % func.__name__)
            print('args = {}'.format(*args))
            print('log_param = {}'.format(text))
            return func(*args, **kwargs)
        return wrapper
    return decorator
@log_with_param("param")
def test_with_param(p):
    print(test_with_param.__name__)
```
# 爬虫学习

一、提取网页源码

 取网页源码方法很多，常用的库有：urllib库，requests库等。

```python

def get_html(url):
    headers = {
        'User-Agent':'Mozilla/5.0(Macintosh; Intel Mac OS X 10_11_4)\
        AppleWebKit/537.36(KHTML, like Gecko) Chrome/52 .0.2743. 116 Safari/537.36'
 
    }     #模拟浏览器访问
    response = requests.get(url,headers = headers)       #请求访问网站
    html = response.text       #获取网页源码
    return html  
```
二、筛选内容
  ①使用 XPath ②使用 Beautiful Soup  ③使用 pyquery

```python
import re
reg = r'<a\sclass=".*?"\starget=".*?"\shref=".*?">(.*)</a>'   #正则表达式
reg_ques = re.compile(reg)     #编译一下正则表达式，运行的更快
queslist = reg_ques.findall(get_html('https://www.jianshu.com/'))   #匹配正则表达式

---
```


```python
from bs4 import BeautifulSoup
soup = BeautifulSoup(get_html('https://www.jianshu.com/'), 'lxml')   #初始化BeautifulSoup库,并设置解析器
print(get_html('https://www.jianshu.com/'))
for li in soup.find_all(name='li'):         #遍历父节点
        for a in li.find_all(name='a'):     #遍历子节点
            if a.string==None:
                pass
            else:
                print(a.string)      #输出结果
```
三、获取下载图片
```python
import urllib
import urllib.request
def get_image(url,stuNum):
  try:
    request = urllib.request.Request(url)
    response = urllib.request.urlopen(request)
    get_img = response.read()
    with open(‘D:\stuphoto\’+str(stuNum)+’.jpg’,‘wb’) as fp:
      fp.write(get_img)
      print(‘图片下载完成’)
  except:
    print(‘访问空’)
stuNum =
url = ‘’
for i in range(500):
  stuNum = stuNum+1
get_image(url+str(stuNum)+’.JPG’,stuNum)
```
