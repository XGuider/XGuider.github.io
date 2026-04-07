---
layout: "post"
title: "Newcoder 剑指office"
subtitle: "编程语言 / 算法"
date: "2026-03-26 14:04:24"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 算法
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/05-算法/Newcoder 剑指office.md`

### 数据结 ；/构类题目

 

LinkedList 

   * 003-从尾到头打印链表

   * 014-链表中倒数第k个结点

   * 015-反转链表

   * 016-合并两个或k个有序链表

   * 025-复杂链表的复制

   * 036-两个链表的第一个公共结点

   * 055-链表中环的入口结点

   * 056-删除链表中重复的结点

Tree 

   * 004-重建二叉树

   * 017-树的子结构

   * 018-二叉树的镜像

   * 022-从上往下打印二叉树

   * 023-二叉搜索树的后序遍历序列

   * 024-二叉树中和为某一值的路径

   * **026-二叉搜索树与双向链表**

   * 038-二叉树的深度

   * 039-平衡二叉树

   * 057-二叉树的下一个结点

   * 058-对称的二叉树

   * 059-按之字形顺序打印二叉树

   * 060-把二叉树打印成多行

   * 061-序列化二叉树

   * 062-二叉搜索树的第k个结点

* 

Stack & Queue 

   * 005-用两个栈实现队列

   * 020-包含min函数的栈

   * 021-栈的压入、弹出序列

   * 044-翻转单词顺序列(栈)

   * 064-滑动窗口的最大值(双端队列)

* 

Heap 

   * **029-最小的K个数**

* 

Hash Table 

   * 034-第一个只出现一次的字符

* 

图 

   * 065-矩阵中的路径(BFS)

   * 066-机器人的运动范围(DFS)

* 

 

### 具体算法类题目

 

斐波那契数列 

   * 007-斐波拉契数列

   * 008-跳台阶

   * 009-变态跳台阶

   * 010-矩形覆盖

* 

搜索算法 

   * 001-二维数组查找

   * 006-旋转数组的最小数字（二分查找）

   * 037-数字在排序数组中出现的次数（二分查找）

* 

全排列 

   * 027-字符串的排列

* 

动态规划 

   * 030-连续子数组的最大和

   * 052-正则表达式匹配(我用的暴力)

* 

回溯 

   * 065-矩阵中的路径(BFS)

   * 066-机器人的运动范围(DFS)

* 

排序 

   * 035-数组中的逆序对(归并排序)

   * **029-最小的K个数**(堆排序)

   * **029-最小的K个数**(快速排序)

* 

位运算 

   * 011-二进制中1的个数

   * 012-数值的整数次方

   * 040-数组中只出现一次的数字

* 

* 其他算法 

   * 002-替换空格

   * 013-调整数组顺序使奇数位于偶数前面

   * 028-数组中出现次数超过一半的数字

   * 031-整数中1出现的次数（从1到n整数中1出现的次数）

   * 032-把数组排成最小的数

   * 033-丑数

   * 041-和为S的连续正数序列(滑动窗口思想)

   * 042-和为S的两个数字(双指针思想)

   * 043-左旋转字符串(矩阵翻转)

   * 046-孩子们的游戏-圆圈中最后剩下的数(约瑟夫环)

   * 051-构建乘积数组


67 剪绳子

```java
我的代码：动态规划
Q:接下来，我们就可以开篇的问题了，什么样的题适合用动态规划？
A：一般，动态规划有以下几种分类：
最值型动态规划，比如求最大，最小值是多少
计数型动态规划，比如换硬币，有多少种换法
坐标型动态规划，比如在 m*n 矩阵求最值型，计数型，一般是二维矩阵
区间型动态规划，比如在区间中求最值

其实，根据此题的启发，我们可以换种想法，就是什么样的题适合用暴力递归？
显然就是，可能的情况很多，需要枚举所有种情况。只不过动态规划，只记录子结构中最优的解。
import java.util.Scanner;
public class Solution {
    public int cutRope(int target) {
            int n=target;
            int dp[][] = new int[n + 1][n + 1];//构建一个二维数组
            for (int i = 1; i <= n; i++) {
                for (int j = 1; j <= n; j++) {
                    if (i == 1) {
                        dp[i][j] = j;
                        continue;
                    }
                    if (i > j) {
                        continue;
                    }
                    int max = 0;
//枚举之前的数值
                    for (int z = 1; z <= j - 1; z++) {
                        max = Math.max(dp[i - 1][z] * dp[1][j - z], max);
                    }
                    dp[i][j] = max;
                }
            }
            int max = 0;
            for (int i = 1; i <= n; i++) {
                max = Math.max(max, dp[i][n]);
            }
            return(max);
}}
```


```python
解答：#递归写法
我们先定义函数 f(n)为把绳子剪成若干段之后的各段长度乘积的最大值
class Solution:
 def cutRope(self, number):
     # write code here
     if number < 2:
         return 0
     if number == 2:
         return 1
     if number == 3:
         return 2       
     return self.cutRopeCore(number)
 def cutRopeCore(self, number):
     if number < 4:
         return number
     max_ = 0
     for i in range(1, number/2+1):
         max_ = max(self.cutRopeCore(i) * self.cutRopeCore(number - i), max_)
     return max_
```


67 斐波拉切 0 1 1 2.....

```java
我的：递归
public class Solution {
    public int Fibonacci(int n) {
       if (n==0){return 0;}
       if (n==1){return 1;}
       return Fibonacci(n-1)+Fibonacci(n-2);
    }
}
```


```python
#动态规划
class Solution:
    def Fibonacci(self, n):
        dp=[0 for _ in range(n+1)]
        if n==0:
            return 0
        if n==2:
            return 1
        dp[0]=0
        dp[1]=1
        for i in range(2,n+1):
            dp[i]=dp[i-1]+dp[i-2]
        return dp[n]
```



27 字符串排序《困难》

没写出来，需要记录状态和返回节点数据，这里有点疑问！！！跟进下

```python
源代码：
class Solution:
    def Permutation(self, ss):
        l = []
        if len(ss) <= 1:
            return ss
        n = len(ss)
        for i in range(n):
            for j in self.Permutation(ss[:i]+ss[i+1:]):
                temp = ss[i] + str(j)
                if temp not in l:
                    l.append(temp)
        return l

```
8：跳阶梯
```python
我的:动态规划
class Solution:
    def jumpFloor(self, number):
        dp=[0 for i in range(number+1)]
        if(number==0):
            return 0
        if(number==1 ):
            return 1
        if(number==2):
            return 2
        dp[0],dp[1],dp[2]=0,1,2
        for ii in range(3,number+1):
            dp[ii]=dp[ii-1]+dp[ii-2]
        return dp[number]
```


```python
#记忆性搜索###注意 dp[]的传递（从顶层向下层传递）
class Solution:
    def jumpFloor(self, number):
        dp=[0 for _ in range(number+1)]
        if(number==0):
            return 0
        if(number==1 ):
            return 1
        if(number==2):
            return 2
        dp[0],dp[1],dp[2]=0,1,2
        return self.rec(number,dp)
    def rec(self,n,dp):
        if(dp[n]!=0):return dp[n]
        dp[n] = self.rec(n - 1,dp) + self.rec(n - 2,dp)
        return dp[n]
```
leet code [120. 三角形最小路径和](https://leetcode-cn.com/problems/triangle/)
```python
递归模板：求线路的最小距离，每层返回和的最小值（每层保留层值）
class Solution:
    def minimumTotal(self,nums):
        return self.recurion(0,0,nums,"",0)
    def recurion(self,cen,shen,nums,path,sum):
        #terminate
        if(cen==len(nums)-1):
            path=path+str(nums[cen][shen])+"#"
            sum=sum+nums[cen][shen]
            print(path+"sum"+str(sum))
            return sum
        #process
        path=path+str(nums[cen][shen])+"-->"##打印出所经历的路径
        sum=sum+nums[cen][shen]
        #drill down
        left_value=self.recurion(cen+1,shen,nums,path,sum)
        right_value=self.recurion(cen + 1, shen+1, nums,path,sum)
        #clear state
        return min(left_value,right_value)
```


```java
###动态归话##子结构最优解
class Solution {
    public int minimumTotal(List<List<Integer>> triangle) {
        int n = triangle.size();
        int[][] f = new int[n][n];
        f[0][0] = triangle.get(0).get(0);
        for (int i = 1; i < n; ++i) {
            f[i][0] = f[i - 1][0] + triangle.get(i).get(0);
            for (int j = 1; j < i; ++j) {
                f[i][j] = Math.min(f[i - 1][j - 1], f[i - 1][j]) + triangle.get(i).get(j);
            }
            f[i][i] = f[i - 1][i - 1] + triangle.get(i).get(i);
        }
        int minTotal = f[n - 1][0];
        for (int i = 1; i < n; ++i) {
            minTotal = Math.min(minTotal, f[n - 1][i]);
        }
        return minTotal;
    }
}
```


### 1、二维数组的查询

```python
1、使用二分查找
public class Solution {
    public boolean Find(int target, int [][] array) {
        if (array.length==0 | array[0].length==0){return false;}
                for (int i=0;i<array.length;i++){
            if (target>array[i][array[0].length-1])
                continue;
            //当前行，使用二分查找
            int start=0;
            int end=array[i].length-1;
            while (start<=end){
                int mid=start+(end-start)/2;
                if (target==array[i][mid]){
                    return true;
                }
                else if (array[i][mid]<target){
                    start=mid+1;
                }
                else {
                    end=mid-1;
                }
            }
        }
        return false;
    }
}
```


```plain
参考：从底部 0 头开始遍历
class Solution {
public:
    bool Find(vector<vector<int> > array,int target) {
        int rowCount = array.size();
        int colCount = array[0].size();
        int i,j;
        for(i=rowCount-1,j=0;i>=0&&j<colCount;)
        {
            if(target == array[i][j])
                return true;
            if(target < array[i][j])
            {
                i--;
                continue;
            }
            if(target > array[i][j])
            {
                j++;
                continue;
            }
        }
        return false;
    }
};

```
### 2 替换空格

```java
我的代码：
public class Solution {
    public String replaceSpace(StringBuffer str) {
        return str.toString().replace(" ", "%20");
    }
}
```


```java
参考代码：
class Solution {
public void replaceSpace(char *str,int length) {
     if (str == nullptr || length <= 0) return; // 养成良好习惯，判空操作
     int cnt = 0;  // 空格的个数
     for (int i=0; i != length; ++i) {
         if (str[i] == ' ') ++cnt;
     }
     if (!cnt) return; // 没有空格，直接返回
     int new_length = length+cnt*2;
     for (int i=length; i >= 0; --i) {
         if (str[i] == ' ') {
             str[new_length--] = '0';
             str[new_length--] = '2';
             str[new_length--] = '%';
         }
         else {
             str[new_length--] = str[i];
         }
     }
 }
};
```
### 3、从尾到头打印链表

```python
我的：
class Solution:
    # 返回从尾部到头部的列表值序列，例如[1,2,3]
    def printListFromTailToHead(self, listNode):
        # write code here
        if(listNode==None):
            return []
        res=list()
        while(listNode.next!=None):
            res.append(listNode.val)
            listNode=listNode.next
        res.append(listNode.val)
        return [res[i] for i in range(len(res)-1,-1,-1)]

```


```java
参考：
import java.util.*;
public class Solution {
    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        ArrayList<Integer> list = new ArrayList<>();
        ListNode tmp = listNode;
        while(tmp!=null){
            list.add(0,tmp.val);//每次插入第一行##重点
            tmp = tmp.next;
        }
        return list;
    }
}
```
### 4、 重建二叉树

```java
import java.util.Arrays;
public class Solution {
    public TreeNode reConstructBinaryTree(int [] pre,int [] in) {
        if (pre.length == 0 || in.length == 0) {
            return null;
        }

        TreeNode root = new TreeNode(pre[0]);

        // 在中序中找到前序的根
        for (int i = 0; i < in.length; i++) {
            if (in[i] == pre[0]) {
                // 左子树，注意 copyOfRange 函数，左闭右开
                root.left = reConstructBinaryTree(Arrays.copyOfRange(pre, 1, i + 1), Arrays.copyOfRange(in, 0, i));
                // 右子树，注意 copyOfRange 函数，左闭右开
                root.right = reConstructBinaryTree(Arrays.copyOfRange(pre, i + 1, pre.length), Arrays.copyOfRange(in, i + 1, in.length));
                break;
            }
        }
        return root;
    }
}
```
### 5、 两个栈实现队列

```plain
##不难，理清思路很重要
import java.util.Stack;
public class Solution {
    Stack<Integer> stack1 = new Stack<Integer>();
    Stack<Integer> stack2 = new Stack<Integer>();
    public void push(int node) {
      while(!stack2.isEmpty()){
          stack1.add(stack2.pop());
      }
      stack1.add(node);
    }
    public int pop() {
      while(!stack1.isEmpty()){
          stack2.add(stack1.pop());
      }
      return stack2.pop();
}}
```


### 6、旋转数组的最小数字

```java
没有 ac，注意****
import java.util.ArrayList;
public class Solution {
    public int minNumberInRotateArray(int [] array) {
        if (array.length==0){return 0;}
        int le=0;
        int ri=array.length-1;
        while(le<ri){
            if(array[le]<array[ri]){
                return array[le];
            }
            int mid=le+(ri-le)/2;
            if(array[mid]>array[ri])
            {
                le=mid+1;
            }
             if(array[mid]<array[ri])
            {
                ri=mid-1;
            }
             if(array[mid]==array[ri])
            {
                --ri;
            }
        }
        return array[le];
    }
}

```


### 9、变态跳阶梯

```python
class Solution:
    def jumpFloorII(self, number):
        # write code here
        if number==1:return 1
        dp=[0 for _ in range(number+1)]
        for i in range(1,number+1):
            dp[i]=sum(dp[:i])+1
        return dp[number]
```


```plain
参考：
对于方法一中的：f[n] = f[n-1] + f[n-2] + ... + f[0]

那么 f[n-1] 为多少呢？

f[n-1] = f[n-2] + f[n-3] + ... + f[0]

所以一合并，f[n] = 2*f[n-1]，初始条件 f[0] = f[1] = 1

所以可以采用递归，记忆化递归，动态规划，递推。具体详细过程，可查看青蛙跳台阶。

这里直接贴出递推的代码。

int jumpFloorII(int n) {
    if (n==0 || n==1) return 1;
    int a = 1, b;
    for (int i=2; i<=n; ++i) {
        b = a << 1; //  口诀：左移乘 2，右移除 2
        a = b;
    }
    return b;
}

```
### 10、矩阵覆盖

```plain
# -*- coding:utf-8 -*-，动态规划
class Solution:
    def rectCover(self, number):
        # write code here
        if (number==0):return 0
        if (number==1):return 1
        if (number==2):return 2
        dp=[0 for _ in range(number+1)]
        dp[1],dp[2]=1,2
        for i in range(3,number+1):
            dp[i] = dp[i-1] + dp[i-2]
        return dp[number]
```
### 11、二进制中 1 的个数

```python
 理解错了题目的含义，你需要自己处理负数的情况，
 //思想：用 1（1 自身左移运算，其实后来就不是 1 了）和 n 的每位进行位与，来判断 1 的个数
    private static int NumberOf1_low(int n) {
        int count = 0;
        int flag = 1;
        while (flag != 0) {
            if ((n & flag) != 0) {
                count++;
            }
            flag = flag << 1;
        }
        return count;
    }
    //--------------------最优解----------------------------
    public static int NumberOf1(int n) {
        int count = 0;
        while (n != 0) {
            ++count;
            n = (n - 1) & n;
        }
        return count;
    }
    public static void main(String[] args) {
        //使用 n=10,二进制形式为 1010，则 1 的个数为 2；
        int n = -10;
        System.out.println(n + "的二进制中 1 的个数：" + NumberOf1(n));
    }
}

```
### 12 数值的整数次方

```python
我的代码
class Solution:
    def Power(self, base, exponent):
        # write code here
        if(base==0):return 0
        if(exponent==0):return 1
        if(exponent==1):return base
        if(exponent<0):
            base=1/base
            exponent=-exponent
        if(exponent%2==0):
            return self.Power((base*base),exponent//2)
        else:
            return base*self.Power((base*base),exponent//2)
```


```plain
使用 python 自带的 pow 函数
class Solution:
    def Power(self, base, exponent):
        # write code here
        return pow(base,exponent)
```


### 13、调整数组顺序

```java
import java.util.ArrayList;
import java.util.List;
public class Solution {
    public void reOrderArray(int [] array) {
        List<Integer>ls1=new ArrayList<Integer>();
		List<Integer>ls2=new ArrayList<Integer>();
        for(int i=0;i<array.length;i++){
        	if(array[i]%2==1){
        		ls1.add(array[i]);
        	}
        	else {
        		ls2.add(array[i]);
        	}
        }
        ls1.addAll(ls2);
        for(int i=0;i<array.length;i++){
        	array[i]=ls1.get(i);
        }
    }
    }
```


```python
参考：
匿名函数
python 使用 lambda 来创建匿名函数。
lambda 只是一个表达式，函数体比 def 简单很多。
lambda 的主体是一个表达式，而不是一个代码块。仅仅能在 lambda 表达式中封装有限的逻辑进去。
lambda 函数拥有自己的命名空间，且不能访问自有参数列表之外或全局命名空间里的参数。
虽然 lambda 函数看起来只能写一行，却不等同于 C 或 C++的内联函数，后者的目的是调用小函数时不占用栈内存从而增加运行效率。
￥￥￥￥按照对key的顺序对range(len(B))排序
 Bindex=sorted(range(len(B)),key=lambda k:B[k])

# -*- coding:utf-8 -*-
class Solution:
    def reOrderArray(self, array):
        #filter 过滤
        oddL=filter(lambda x: x%2,array)
        evenL=filter(lambda x: not x%2,array)---->x 为参数
        L = oddL + evenL
        return L

filter 的使用
def is_sqr(x):
    return math.sqrt(x) % 1 == 0
newlist = filter(is_sqr, range(1, 101))#迭代
#################################################
####sorted，sort
L=[('b',2),('a',1),('c',3),('d',4)]
sorted(L, key=lambda x:x[1])               # 利用 key
[('a', 1), ('b', 2), ('c', 3), ('d', 4)]
 
def takeSecond(elem):
    return elem[1]
# 列表
random = [(2, 2), (3, 4), (4, 1), (1, 3)]
# 指定第二个元素排序
random.sort(key=takeSecond)
or random.sort(key=lambda x:x[1])
```


### 14、倒数第 k 个节点

```plain
暴力解法，需要考虑空值和 k 值大于链表值的情况 0（2*n）的复杂度
class Solution:
    def FindKthToTail(self, head, k):
        if(head==None):return None
        i=1
        head_se=head
        while(head_se.next!=None):
            i+=1
            head_se=head_se.next
        end=i-k
        if(end<0):return None
        while(end>0):
            head=head.next
            end-=1
        return head
```


```cpp
参考：严格的快慢指针 O(n)
class Solution {
public:
    ListNode* FindKthToTail(ListNode* pListHead, unsigned int k) {
        if (!pListHead || k <= 0) return nullptr;
        auto slow = pListHead, fast = pListHead;

        while (k--) {
            if (fast)
                fast = fast->next;
            else 
                return nullptr; //如果单链表长度 < K,直接返回
        }
        while (fast) {
            slow = slow->next;
            fast = fast->next;
        }
        return slow;
    }
};
```
### 15、反转链表

```python
class Solution:
    # 返回 ListNode
    def ReverseList(self, pHead):
        new_next = None##完美解决 new_next 进入下一层，想复杂了, 把值赋值给下次的          
        while(pHead!=None):
            temp_listNode=pHead.next
            pHead.next = new_next
            new_next=pHead
            pHead=temp_listNode
        return new_next
```


### 16、合并两个链表

```cpp
#设置两个链表，分别的迭代，其中一个负责更新
class Solution {
public:
    ListNode* Merge(ListNode* pHead1, ListNode* pHead2)
    {
        ListNode *vhead = new ListNode(-1);
        ListNode *cur = vhead;
        while (pHead1 && pHead2) {
            if (pHead1->val <= pHead2->val) {
                cur->next = pHead1;
                pHead1 = pHead1->next;
            }
            else {
                cur->next = pHead2;
                pHead2 = pHead2->next;
            }
            cur = cur->next;
        }
        cur->next = pHead1 ? pHead1 : pHead2;
        return vhead->next;
    }
};
```


```plain
#迭代方法求解，简单
# -*- coding:utf-8 -*-
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None
class Solution:
    # 返回合并后列表
    def Merge(self, pHead1, pHead2):
        if not pHead1:
            return pHead2
        if not pHead2:
            return pHead1
        if pHead1.val < pHead2.val:
            pHead1.next = self.Merge(pHead1.next, pHead2)
            return pHead1
        else:
            pHead2.next = self.Merge(pHead1, pHead2.next)
            return pHead2
```


￥￥￥￥￥判断树的子结构是否存在

```cpp
###遍历两棵树是否相同
bool dfs(TreeNode *r1, TreeNode *r2) {
    if (!r2) return true;
    if (!r1) return false;
    return r1->val==r2->val && dfs(r1->left, r2->left) && dfs(r1->right, r2->right);
}
#####遍历大树寻找与子树相同的节点
bool HasSubtree(TreeNode* pRoot1, TreeNode* pRoot2)
{
    if (!pro1 || !pRoot2) return false;
    return dfs(pRoot1, pRoot2) || HasSubtree(pRoot1->left, pRoot2) ||
    HasSubtree(pRoot1->right, pRoot2);

}
```


```python
$$层次遍历：(BFS)
class Solution:
    # 返回从上到下每个节点值列表，例：[1,2,3]
    def PrintFromTopToBottom(self, root):
        # write code here
        keep=list()
        print_list=list()
        if(root==None):return []
        keep.append(root)
        while(len(keep)!=0):
            tem=keep.pop(0)
            print_list.append(tem.val)
            if(tem.left): keep.append(tem.left)
            if(tem.right):keep.append(tem.right)
        return print_list
```


```python
#二叉树镜像（我的，需要另外设置一个端点，保存流程）
class Solution:
    # 返回镜像树的根节点
    def Mirror(self, root):
        new_root=root
        # write code here
        self.recu(root)
        return new_root
    def recu(self,root):
        if(root!=None):
            cur=root.left
            root.left=root.right
            root.right=cur
        else:
            return 
        self.recu(root.left)
        self.recu(root.right)
参考：后序遍历模板
void postOrder(TreeNode *root) {
    if (!root) return;
    postOrder(root->left); // left child
    postOrder(root->right); // right child
    // process root
}   
解答：
class Solution {
public:
    TreeNode* dfs(TreeNode *r) {
        if (!r) return nullptr;
        TreeNode *lval = dfs(r->left);
        TreeNode *rval = dfs(r->right);
        r->left = rval, r->right = lval;
        return r;
    }
    void Mirror(TreeNode *pRoot) {
        if (!pRoot) return;
        dfs(pRoot);
    }
};
```


### 17、顺时针打印矩阵

```plain
18.81、、
class Solution:
    # matrix 类型为二维列表，需要返回列表：list[1:3][1:3]不是 numpy 矩阵，不能取出纵坐标的数据
    def printMatrix(self, matrix):
        # write code here
        if(len(matrix)==1):return matrix[0]
        data=list()
        self.recu(matrix,data=data)
        return data
    def recu(self,matrix,data):

        max_y=len(matrix)
        if(max_y==1):
            for i in matrix[0]:
                data.append(i)
            return data
        if(max_y==0):
            return data
        mat_x = len(matrix[0])
        for i in range(mat_x):
            data.append(matrix[0][i])
        for i in range(1,max_y):
            data.append(matrix[i][mat_x-1])
        for i in range(mat_x-2,-1,-1):
            data.append(matrix[max_y-1][i])
        for i in range(max_y-2, 0, -1):
            data.append(matrix[i][0])
        self.recu(matrix[1:max_y-1][1:mat_x-1],data)
```


```java
参考：import java.util.ArrayList;
public class Solution {
    public ArrayList<Integer> printMatrix(int [][] matrix) {
        ArrayList<Integer> list = new ArrayList<>();
        if(matrix == null || matrix.length == 0 || matrix[0].length == 0){
            return list;
        }
        int up = 0;
        int down = matrix.length-1;
        int left = 0;
        int right = matrix[0].length-1;
        while(true){
            // 最上面一行
            for(int col=left;col<=right;col++){
                list.add(matrix[up][col]);
            }
            // 向下逼近
            up++;
            // 判断是否越界
            if(up > down){
                break;
            }
            // 最右边一行
            for(int row=up;row<=down;row++){
                list.add(matrix[row][right]);
            }
            // 向左逼近
            right--;
            // 判断是否越界
            if(left > right){
                break;
            }
            // 最下面一行
            for(int col=right;col>=left;col--){
                list.add(matrix[down][col]);
            }
            // 向上逼近
            down--;
            // 判断是否越界
            if(up > down){
                break;
            }
            // 最左边一行
            for(int row=down;row>=up;row--){
                list.add(matrix[row][left]);
            }
            // 向右逼近
            left++;
            // 判断是否越界
            if(left > right){
                break;
            }
        }
        return list;
    }
}
```


### 20 包含 min 函数的栈

```java
import java.util.Stack;
public class Solution {
    Stack<Integer> stack = new Stack<Integer>();
    Stack<Integer> min = new Stack<Integer>()
    public void push(int node) {
        stack.push(node);
        if(min.isEmpty()){
            min.push(node);
        }else{
            min.push((min.peek())>node?node:min.peek());
        }
    }   
    public void pop() {
        stack.pop();
        min.pop();
      
    public int top() {
        return stack.peek();
    }   
    public int min() {
        return min.peek();
    }
}
```


```python
#python 写出栈，值得关注
# -*- coding:utf-8 -*-
class Solution:
    def __init__(self):
        self.stack=[]
        self.minstack=[]
    def push(self, node):
        # write code here
        self.stack.append(node)
        if not self.minstack or node<=self.minstack[-1]:
            self.minstack.append(node)
        else:
            self.minstack.append(self.minstack[-1])
    def pop(self):
        # write code here
        if not self.stack:
            self.stack.pop()
        self.minstack.pop()
    def top(self):
        # write code here
        return self.stack[-1]
    def min(self):
        # write code here
        return self.minstack[-1]
```


### 21、栈的压入和弹出

```python
# -*- coding:utf-8 -*-
class Solution:
    def IsPopOrder(self, pushV, popV):
        # write code here
        j,stack=0,list()
        for i,c in enumerate(pushV):
            stack.append(c)
            while(len(stack)!=0 and (stack[-1]==popV[j])):
                stack.pop()
                j+=1
        if(len(stack)!=0):return False
        else:return True
```


### 23、二叉树的搜索树的后序遍历序列

```cpp
##那么，只需要不断地确定出左子树区间和右子树区间，并且判断：左子树区间的所有结点值 < 根结点值 < 右子树区间所有结点值，这个条件是否满足即可
public class Solution {

    public boolean helpVerify(int [] sequence, int start, int root){
        if(start >= root)return true;
        int key = sequence[root];
        int i;
        //找到左右子数的分界点
        for(i=start; i < root; i++)
            if(sequence[i] > key)
                break;
        //在右子树中判断是否含有小于 root 的值，如果有返回 false
        for(int j = i; j < root; j++)
            if(sequence[j] < key)
                return false;
        return helpVerify(sequence, start, i-1) && helpVerify(sequence, i, root-1);
```
    }
    public boolean VerifySquenceOfBST(int [] sequence) {

```cpp
        if(sequence == null || sequence.length == 0)return false;
        return  helpVerify(sequence, 0, sequence.length-1);
    }
}
```


### 24、二叉树中和为某一值的路径

```python
# 递归解法 去解
class Solution:
    def binaryTreePaths(self, root):
        if root == None:
            return []
        result = []
        self.DFS(root, result, [root.val])
        return result


    def DFS(self, root, result, path):
        if root.left == None and root.right == None:###手工判断下一层出递归的状态
      现在何为某路径则为：sum(path) == self.sums，加一个出站的条件
            result.append(path)
        if root.left != None:
            self.DFS(root.left, result, path + [root.left.val])
        if root.right != None:
            self.DFS(root.right, result, path + [root.right.val])
```
### 25 复杂链表的复制

```cpp
//下面那段代码思维太混乱了，大家不要参考，如果要用 map 解决此题，看这段代码就好
import java.util.HashMap;
public class Solution {
    public RandomListNode Clone(RandomListNode pHead)
    {
        HashMap<RandomListNode, RandomListNode> map = new HashMap<RandomListNode, RandomListNode>();
        RandomListNode p = pHead;
        //第一次遍历 新建立节点
        while(p != null){
            RandomListNode newNode = new RandomListNode(p.label);
            map.put(p, newNode);
            p = p.next;
        }
        //第二次遍历 赋值映射关系
        p = pHead;
        while(p != null){
            RandomListNode node = map.get(p);
            node.next = (p.next == null)?null: map.get(p.next);
            node.random = (p.random == null)?null: map.get(p.random);
            p = p.next;
        }
        //最后的返回值
        return map.get(pHead);
    }
}           
```
### 26 二叉搜索树与双向链表

```java
public TreeNode Convert(TreeNode pRootOfTree) {
        if(pRootOfTree == null){
            return null;
        }
        ArrayList<TreeNode> list = new ArrayList<>();
        Convert(pRootOfTree, list);
        return Convert(list);
    }
    //中序遍历，在 list 中按遍历顺序保存
    public void Convert(TreeNode pRootOfTree, ArrayList<TreeNode> list){
        if(pRootOfTree.left != null){
            Convert(pRootOfTree.left, list);
        }
        list.add(pRootOfTree);
        if(pRootOfTree.right != null){
            Convert(pRootOfTree.right, list);
        }
    }
    //遍历 list，修改指针
    public TreeNode Convert(ArrayList<TreeNode> list){
        for(int i = 0; i < list.size() - 1; i++){
            list.get(i).right = list.get(i + 1);
            list.get(i + 1).left = list.get(i);
        }
        return list.get(0);
    }
```


### 30 连续子数组的最大和

```python
class Solution:
    def FindGreatestSumOfSubArray(self, array):
# write code here
        len_ar=len(array)
        dp=[0 for _ in range(len_ar)]
        ret=array[0]
        for i in range(len_ar):
            dp[i]=max(array[i-1],dp[i-1]+array[i-1])
            ret=max(ret,dp[i])
        return ret
```
### 31 连续不同字符串

```python
class Solution:
    def FindGreatestSumOfSubArray(self, array):
        str_t=list()
        for i in range(len(array)):
            temp_str = ""
            for j in range(i,len(array)):
                if(array[j] in temp_str):
                    break
                temp_str+=array[j]
            str_t.append(temp_str)
        return str_t
```
### 32 把数组排成最小的数

```python
# -*- coding:utf-8 -*-
# -*- coding:utf-8 -*-
class Solution:
    def PrintMinNumber(self, numbers):
        # write code here
        for i in range(len(numbers)-1):
          for j in range(i+1,len(numbers)):
            if int(str(numbers[i])+str(numbers[j])) > int(str(numbers[j])+str(numbers[i])):
              numbers[i],numbers[j] = numbers[j],numbers[i]
        return "".join([str(i) for i in numbers])
```
### 33 丑数（穷举才行)

```python
class Solution:
    def GetUglyNumber_Solution(self, index):
        # write code here
        if index <= 0:
            return 0
        uglyList = [1]
        p2 = 0 # p2 指向小于 newUgly 且最大的乘以 2 后可能成为下一个丑数的丑数
        p3 = 0 # p3 指向小于 newUgly 且最大的乘以 3 后可能成为下一个丑数的丑数
        p5 = 0 # p5 指向小于 newUgly 且最大的乘以 5 后可能成为下一个丑数的丑数
        for i in range(index-1):
            newUgly = min(uglyList[p2]*2, uglyList[p3]*3, uglyList[p5]*5)
            uglyList.append(newUgly)
            if (newUgly % 2 == 0):
                p2 += 1
            if (newUgly % 3 == 0):
                p3 += 1
            if (newUgly % 5 == 0):
                p5 += 1
        return uglyList[-1]
```
### 34 第一次只出现一次的字符

```java
import java.util.*;
public class Solution {
    public int FirstNotRepeatingChar(String str) {
        for(int i =0;i<str.length();i++){
            if(str.indexOf(str.charAt(i)) == i && str.indexOf(str.charAt(i),i+1) == -1) return i;
               
        }
        return -1;
    }
}
```
### 35 数组逆序对

```cpp
#两次 for 循环#######
class Solution {
private:
    const int kmod = 1000000007;
public:
    int InversePairs(vector<int> data) {
        int ret = 0;
        int n = data.size();
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (data[i] > data[j]) {
                    ret += 1;
                    ret %= kmod;
                }
            }
        }
        return ret;
    }
};
```
### 36 两个链表的公众节点

```python
class Solution:
    def FindFirstCommonNode(self, pHead1, pHead2):
        p1=pHead1
        p2=pHead2
        while(p1!=p2):
            if(p1 is not None):p1=p1.next
            if (p2 is not None): p2 = p2.next
            if(p1!=p2):
                if(p1 is None):p1=pHead2
                if (p2 is None): p2= pHead1
        return p1
```
### 37 数字在升序数组中出现的次数

```python
class Solution:
    def GetNumberOfK(self, data, k):
        count=0
        left,right=0,len(data)-1
        while left<=right:
            middle=left+(right-left)//2
            if data[middle]==k:
                count+=1
                # for i in range(middle-1,left-1,-1):
                i=middle-1
                while(i>left-1):
                    if data[i]==k:
                        count+=1
                        i-=1
                    else:break
                i=middle+1
                while(i<right+1):
                    if data[i]==k:
                        count+=1
                        i+=1
                    else:break
                return count
            if k>data[middle]:
                left=middle+1
            else:
                right=middle-1
        return 0
```
### 38 二叉树的深度

```python
#递归，写出
class Solution:
    def TreeDepth(self, pRoot):
        len=0
        res=self.recu(pRoot,len)
        return res
    def recu(self,pRoot,len):
        if (pRoot==None):
            return len
        len+=1
        left_len = self.recu(pRoot.left,len)
        right_len = self.recu(pRoot.right,len)
        return max(left_len, right_len)
#非递归，写出层次遍历
class Solution:
    def TreeDepth(self, pRoot):
        if not pRoot:
            return 0
        a，d= [pRoot],0
        while a:
            b = []##另取一个 list 则不需弹出的操作
            for node in a:
                if node.left:b.append(node.left)
                if node.right:b.append(node.right)
            a = b
            d += 1
        return d
```
### 39 平衡二叉树

```python
class Solution:
    def Leval_Sort(self, root):
        if root is None:
            return 0
        return max(self.Leval_Sort(root.left), self.Leval_Sort(root.right))+1


    def IsBalanced_Solution(self, pRoot):
        # write code here
        if not pRoot:
            return True
        if pRoot:
            a = self.Leval_Sort(pRoot.left)
            b = self.Leval_Sort(pRoot.right)
            if abs(a-b) > 1:
                return False
        return self.IsBalanced_Solution(pRoot.left) and self.IsBalanced_Solution(pRoot.right)
            
```


### 40 返回类表中出现 1 次的数据

```python
# -*- coding:utf-8 -*-
class Solution:
    # 返回[a,b] 其中 ab 是出现一次的两个数字
    def FindNumsAppearOnce(self, array):
        temp = {}#控制异常来形成字典树
        for i in array:
            try:
                temp.pop(i)
            except KeyError:
                temp[i] = None
        return list(temp.keys())
#使用 count 函数来计算出现次数    
class Solution:
    # 返回[a,b] 其中 ab 是出现一次的两个数字
    def FindNumsAppearOnce(self, array):
        temp = {}   
        for i in array:
            try:
                temp.pop(i)
            except KeyError:
                temp[i] = None     
        return list(temp.keys())        
```
### 41 和为 S 的连续整数序列

```python
class Solution:
    def FindContinuousSequence(self, tsum):
        # write code here
        res_lists=list()
        for i in range(1,tsum):
            sum=0
            for j in range(i,tsum):
                sum+=j
                if sum==tsum:
                    res=[i for i in range(i,j+1)]
                    res_lists.append(res)
                    break
                if sum>tsum:break
        return res_lists
```
滑动窗口来处理
```cpp
class Solution {
public:
    vector<vector<int> > FindContinuousSequence(int sum) {
        vector<vector<int>> ret;
        int l = 1, r = 1;
        int tmp = 0;
        while (l <= sum / 2) {
            if (tmp < sum) {
                tmp += r;
                ++r;
            }
            else if (tmp > sum) {
                tmp -= l;
                ++l;
            }
            else {
                vector<int> ans;
                for (int k=l; k<r; ++k) 
                    ans.push_back(k);
                ret.push_back(ans);
                tmp -= l;
                ++l;
            }
        }
        return ret;
    }
};
```
### 42 和为 S 的两个数字

```python
class Solution:
    def FindNumbersWithSum(self, array, tsum):
        res=[]
        # write code here
        min_mul=float("inf")###无穷大
        for i,a in enumerate(array):
            b=tsum-a
            if(b in array[i+1:] and a*b<min_mul):
                min_mul=a*b
                res=[a,b]
        return res
```
双指针:O(n)和 O(1)
```cpp
递增数组
class Solution {
public:
    vector<int> FindNumbersWithSum(vector<int> array,int sum) {
        if (array.empty()) return vector<int>();
        int tmp = INT_MAX;
        pair<int, int> ret;
        int i = 0, j = array.size();
        while (i < j) {
            if (array[i] + array[j-1] == sum) {
                if (array[i]*array[j-1] < tmp) {
                    tmp = array[i] * array[j-1];
                    ret = {i, j-1};
                }
                ++i, --j;
            }
            else if (array[i] + array[j-1] < sum) {
                ++i;
            }
            else {
                --j;
            }
        }
        if (ret.first == ret.second) return vector<int>();
        return vector<int>({array[ret.first], array[ret.second]});
    }
}
```
### 45 扑克牌顺子

```cpp
0（n）0（n）
class Solution {
public:
    bool IsContinuous( vector<int> numbers ) {
        if (numbers.empty()) return false;
        set<int> st;
        int max_ = 0, min_ = 14;
        for (int val : numbers) {
            if (val > 0) {
                if (st.count(val) > 0) return false;
                st.insert(val);
                max_ = max(max_, val);
                min_ = min(min_, val);
            }
        }
        return max_ - min_ < 5;
    }
};
```
### 47 不使用乘除求和

```python
# -*- coding:utf-8 -*-
class Solution:
    def Sum_Solution(self, n):
        return n and ( n + self.Sum_Solution(n-1) )
```
### 48 按位运算得到想要的结果

```python
# -*- coding:utf-8 -*-
##python 位运算
class Solution:
    def Add(self, num1, num2):
        # write code here
        num1&=0xffffffff
        num2&=0xffffffff
        while(num2):
            temp=(num1^num2)&0xffffffff
            num2=(num1&num2 & 0xffffffff)<<1
            num1=temp
        
        return num1 if num1>>31==0 else (num1-(0xFFFFFFFF+1))
```
### 49 字符串转成整数

```python
# -*- coding:utf-8 -*-
import re##短小精炼，值得学习
class Solution:
    def StrToInt(self, s):
        # write code here
        pat = re.match(r'[-+]?\d+$',s)
        if not pat: return 0
        MAX,MIN = 2**31-1,-2**31
        num = int(pat.group())
        if num<MIN: return MIN
        elif num>MAX: return MAX
        else: return num  
```
### 51 构建乘积数组

```python
class Solution:
    def multiply(self, A):
        # write code here
        B=list()
        res=1
        for da in A:
            B.append(res)
            res*=da
        res=1
        for i in range(len(A)-1,-1,-1):
            B[i]*=res
            res*=A[i]
        return B
```
### 52 正则表达式匹配

```plain

```
### 53 表示数值的字符串

```python
#正则解决
import re
class Solution:
    def isNumeric(self, s):
        return re.match(r"^[\+\-]?[0-9]*(\.[0-9]*)?([eE][\+\-]?[0-9]+)?$",s)
```
### 54 字节流第一个不重复的词

```python
##设计到字节流，动态数组
# -*- coding:utf-8 -*-
class Solution:
    # 返回对应 char##设计类的方法
    def __init__(self):
        self.tmp = []
        self.dic = {}
    def FirstAppearingOnce(self):
        # write code here
        if not self.tmp:
            return '#'
        for i in self.tmp:
            if self.dic[i]==1:return i
        return '#'
    def Insert(self, char):
        # write code here
        self.tmp.append(char)
        if char not in self.dic:
            self.dic[char] = 1
        else:self.dic[char] += 1
        #if self.dic[char] == 1:
           # self.tmp.append(char)
java 版本
import java.util.HashMap;public class Solution {
    HashMap<Character, Integer> map = new HashMap<Character, Integer>();
    StringBuffer s = new StringBuffer();
    //Insert one char from stringstream    
    public void Insert(char ch)    {
        s.append(ch);
        if(map.containsKey(ch)){
            map.put(ch, map.get(ch)+1);
        }else{
            map.put(ch, 1);
        }
    }
  //return the first appearence once char in current stringstream    
    public char FirstAppearingOnce()    {
        for(int i = 0; i < s.length(); i++){
            if(map.get(s.charAt(i)) == 1)
                return s.charAt(i);
        }
        return '#';
    }
}
```
### 55 链表的环起点

```python
#链表存贮遍历节点    
def EntryNodeOfLoop(self, pHead):
        # write code here
        hmp=[]
        while pHead.next:
            if pHead not in hmp:
                hmp.append(pHead)
            else:
                return pHead
            pHead=pHead.next
        return None
#快慢指针
class Solution:
    def EntryNodeOfLoop(self, pHead):
        # write code here
        if not pHead or not pHead.next:
            return None
        slow = pHead
        fast = pHead
        while fast and fast.next:
            fast = fast.next.next
            slow = slow.next
            if fast == slow:
                break
        if fast == None:
            return None
        while pHead != slow:
            slow = slow.next
            pHead = pHead.next
        return slow
```
### 56 删除链表中重复的节点

```python
#双链表的使用
class Solution:
    def deleteDuplication(self, pHead):
        a = ListNode(0)
        a.next = pHead
        pre = a
        cur = pHead
        while cur:
            if cur.next and cur.val == cur.next.val:
                tem = cur.next
                while tem and tem.val == cur.val:
                    tem = tem.next
                pre.next = tem
                cur = tem
            else:
                pre = pre.next
                cur = cur.next
        return a.next
#set保存一个遍历的节点
class Solution {
public:
    ListNode* deleteDuplication(ListNode* pHead)
    {
        if (!pHead) return pHead;
        set<int> st;
        ListNode *pre = pHead;
        ListNode *cur = pHead->next;
        while (cur) {
            if (pre->val == cur->val) {
                st.insert(pre->val);
            }
            pre = pre->next;
            cur = cur->next;
        }

        ListNode *vhead = new ListNode(-1);
        vhead->next = pHead;
        pre = vhead;
        cur = pHead;
        while (cur) {
            if (st.count(cur->val)) {
                cur = cur->next;
                pre->next = cur;     
            }
            else {
                pre = pre->next;
                cur = cur->next;
            }
        }
        return vhead->next;
    }
};
```
### 57 二叉树的下一个

```python
#暴力破解==求出根节点==》遍历求得
#归纳总结、
class Solution:
    def GetNext(self, pNode):
        # write code here
        if pNode is None:
            return pNode
        while pNode.right:
            tmp = pNode.right
            if tmp.left != None:
                tmp = tmp.left
            return tmp
        while pNode.next:
            father = pNode.next
            if father.left == pNode:
                return father
            pNode = father
```
### 58 对称二叉树--两边同时开始对比

```python
class Solution {
public:
    bool isSame(TreeNode *root1, TreeNode *root2) {
        if (!root1 && !root2) return true;
        if (!root1 || !root2) return false;
        return root1->val == root2->val && 
        isSame(root1->left, root2->right) &&
        isSame(root1->right, root2->left);
    }
    bool isSymmetrical(TreeNode* pRoot)
    {
        return isSame(pRoot, pRoot);
    }
};
```
### 59 Z字形打印输出

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def Print(self, pRoot):
        # write code here
        if pRoot==None:return []
        res_list=[pRoot]
        res=[]
        res.append([pRoot.val])
        i=1
        while res_list:
            tem=list()
            while res_list:
                node=res_list.pop(0)
                if node.left:tem.append(node.left)
                if node.right:tem.append(node.right)
            i=i+1
            if not tem:break
            res_list=tem
            res_temp=[j.val for j in tem[::-1]] if not i%2 else [j.val for j in tem]
            res.append(res_temp)
        return res
```
### 60 序列化和反序列化--根据序列造树前中后层都可以照成

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def Serialize(self, root):
        # write code here
        if root==None:
            return '#'
        return str(root.val)+','+self.Serialize(root.left)+','+self.Serialize(root.right)
    def Deserialize(self, s):
        # write code here
        root,index=self.deserialize(s.split(','),0)
        return root
    def deserialize(self,s,index):
        if s[index]=='#':
            return None,index+1
        root=TreeNode(int(s[index]))
        index+=1
        root.left,index=self.deserialize(s, index)
        root.right,index=self.deserialize(s, index)
        return root,index
```
### 61 二叉树的第k各节点

```python
# -*- coding:utf-8 -*-
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    # 返回对应节点TreeNode
    def KthNode(self, pRoot, k):
        # write code here
        # 第三个节点是4
        # 前序遍历5324768
        # 中序遍历2345678
        # 后序遍历2436875
        # 所以是中序遍历，左根右
        global result
        result = []
        self.midnode(pRoot)
        if k <= 0 or len(result) < k:
            return None
        else:
            return result[k - 1]

    def midnode(self, root):
        if not root:
            return None
        self.midnode(root.left)
        result.append(root)
        self.midnode(root.right)
```
### 62 非递归函数中序遍历

```java
import java.util.Stack;
public class Solution {
    TreeNode KthNode(TreeNode pRoot, int k)
    {
        if(pRoot == null || k <= 0){
            return null;
        }
        Stack<TreeNode> stack = new Stack<>(); //建立栈
        TreeNode cur = pRoot;
        //while 部分为中序遍历
        while(!stack.isEmpty() || cur != null){ 
            if(cur != null){
                stack.push(cur); // 当前节点不为null，应该寻找左儿子
                cur = cur.left;
            }else{
                cur = stack.pop();//当前节点null则弹出栈内元素，相当于按顺序输出最小值。
                if(--k == 0){ //计数器功能
                    return cur;
                }
                cur = cur.right;
            }
        }
        return null;
    }
}
```
### 64 滑动窗口最大值或者构建大顶堆

```python
# -*- coding:utf-8 -*-
class Solution:
    def maxInWindows(self, num, size):
        # write code here
        if not num:
            return []
        if len(num) < size:
            return []
        if size < 1:
            return []
        return [max(num[i:i+size]) for i in range(len(num)-size+1)]
#####大顶堆
import java.util.*;
//思路：用一个大顶堆，保存当前滑动窗口中的数据。滑动窗口每次移动一格，就将前面一个数出堆，后面一个数入堆。
public class Solution {
    public PriorityQueue<Integer> maxQueue = new PriorityQueue<Integer>((o1,o2)->o2-o1);//大顶堆
    public ArrayList<Integer> result = new ArrayList<Integer>();//保存结果
    public ArrayList<Integer> maxInWindows(int [] num, int size)
    {
        if(num==null || num.length<=0 || size<=0 || size>num.length){
            return result;
        }
        int count=0;
        for(;count<size;count++){//初始化滑动窗口
            maxQueue.offer(num[count]);
        }
        while(count<num.length){//对每次操作，找到最大值（用优先队列的大顶堆），然后向后滑动（出堆一个，入堆一个）
            result.add(maxQueue.peek());
            maxQueue.remove(num[count-size]);
            maxQueue.add(num[count]);
            count++;
        }
        result.add(maxQueue.peek());//最后一次入堆后没保存结果，这里额外做一次即可


        return result;
    }
}
```
### 65 矩阵中的路径问题

```cpp
DFS模板：
dfs(){
    // 第一步，检查下标是否满足条件
    // 第二步：检查是否被访问过，或者是否满足当前匹配条件
    // 第三步：检查是否满足返回结果条件
    // 第四步：都没有返回，说明应该进行下一步递归
    // 标记
    dfs(下一次)
    // 回溯
}  

main() {
    for (对所有可能情况) {
        dfs()
    }
}

######
class Solution {
public:
    char *mat = 0;
    int h = 0, w = 0;
    int str_len = 0;
    int dir[5] = {-1, 0, 1, 0, -1};
    bool dfs(int i, int j, int pos, char *str) {
        // 因为dfs调用前，没有进行边界检查，
        // 所以需要第一步进行边界检查，
        // 因为后面需要访问mat中元素，不能越界访问
        if (i < 0 || i >= h || j < 0 || j >= w) {
            return false;
        }
        char ch = mat[i * w + j];
        // 判断是否访问过
        // 如果没有访问过，判断是否和字符串str[pos]匹配
        if (ch == '#' || ch != str[pos]) {
            return false;
        }
         // 如果匹配，判断是否匹配到最后一个字符
        if (pos + 1  == str_len) {
            return true;
        }
        // 说明当前字符成功匹配，标记一下，下次不能再次进入
        mat[i * w + j] = '#';
        for (int k = 0; k < 4; ++k) {
            if (dfs(i + dir[k], j + dir[k + 1], pos + 1, str)) {
                return true;
            }
        } 
        // 如果4个方向都无法匹配 str[pos + 1]
        // 则回溯， 将'#' 还原成 ch          
        mat[i * w + j] = ch;
        // 说明此次匹配是不成功的
        return false;   
    }
    bool hasPath(char* matrix, int rows, int cols, char* str)
    {
        mat = matrix;
        h = rows, w = cols;
         str_len = strlen(str);
        for (int i = 0; i < rows; ++i) {
            for (int j = 0; j < cols; ++j) {
                if (dfs(i, j, 0, str)) {
                    return true;
                }
            }
        }
        return false;
    }
};
```
### 66、机器人的运动范围

```cpp
class Solution {
public:
    using V = vector<int>;
    using VV = vector<V>;    
    int dir[5] = {-1, 0, 1, 0, -1};
    int check(int n) {
        int sum = 0;
        while (n) {
            sum += (n % 10);
            n /= 10;
        }
        return sum;
    }
    void dfs(int x, int y, int sho, int r, int c, int &ret, VV &mark) {
        // 检查下标 和 是否访问
        if (x < 0 || x >= r || y < 0 || y >= c || mark[x][y] == 1) {
            return;
        }
        // 检查当前坐标是否满足条件
        if (check(x) + check(y) > sho) {
            return;
        }
        // 代码走到这里，说明当前坐标符合条件
        mark[x][y] = 1;
        ret += 1;
        for (int i = 0; i < 4; ++i) {
            dfs(x + dir[i], y + dir[i + 1], sho, r, c, ret, mark);
        }
    } 
    int movingCount(int sho, int rows, int cols)
    {
        if (sho <= 0) {
            return 0;
        }
        VV mark(rows, V(cols, -1));
        int ret = 0;
        dfs(0, 0, sho, rows, cols, ret, mark);
        return ret;
    }
};

DFS：（python版本）
class Solution:
    def movingCount(self, threshold, rows, cols):
        # write code here
        if not rows or not cols or threshold < 0:
            return 0
        def cal(i):
            sum1 = 0
            while i:
                sum1 += i %10
                i = i // 10
            return sum1
        visited = set()
        def findpath(i,j):
            if i >= rows or j >= cols or cal(i) + cal(j) > threshold or (i,j) in visited:
                return 0
            visited.add((i,j))
            return 1 + findpath(i+1, j) + findpath(i, j+1)
        return findpath(0, 0)
BFS：
class Solution {
public:
    using pii = pair<int,int>;
    int dir[5] = {-1, 0, 1, 0, -1};
    int check(int n) {
        int sum = 0;
        while (n) {
            sum += (n % 10);
            n /= 10;
        }
        return sum;
    }
    int movingCount(int sho, int rows, int cols)
    {
        if (sho <= 0) {
            return 0;
        }
        int ret = 0;
        int mark[rows][cols];
        memset(mark, -1, sizeof(mark));
        queue<pii> q;
        q.push({0, 0});
        mark[0][0] = 1;
        while (!q.empty()) {
            auto node = q.front();
            q.pop();
            // 每次保证进队列的都是满足条件的坐标
            ++ret;
            for (int i = 0; i < 4; ++i) {
                int x = node.first + dir[i];
                int y = node.second + dir[i + 1];
                if (x >= 0 && x < rows && y >= 0 && y < cols && mark[x][y] == -1) {
                    if (check(x) + check(y) <= sho) {
                        q.push({x, y});
                        mark[x][y] = 1;
                    }
                }
            }
        }
        return ret;
    }
};
```
### 67、减绳子

```cpp
递归：
class Solution {
public:
    int back_track(int n) {
        // n <= 4, 表明不分，长度是最大的
        if (n <= 4) {
            return n;
        }
        int ret = 0;
        for (int i = 1; i < n; ++i) {
            ret = max(ret, i * back_track(n - i));
        }
        return ret;
    }
    int cutRope(int number) {
        // number = 2 和 3 时，分 2 段和分 1 段的结果是不一样的，所以需要特判一下
        if (number == 2) {
            return 1;
        }
        else if (number == 3) {
            return 2;
        }
        return back_track(number);
    }
};
记忆递归：
class Solution {
public:
  int back_track(int n, vector<int> &mark) {
      if (n <= 4) {
          return n;
      }
      // 在方法一的基础上添加
      if (mark[n] != -1) {
          return mark[n];
      }
      int ret = 0;
      for (int i = 1; i < n; ++i) {
          ret = max(ret, i * back_track(n - i));
      }
      // 添加部分
      return mark[n] = ret;
  }
  int cutRope(int number) {
      if (number == 2) {
          return 1;
      }
      else if (number == 3) {
          return 2;
      }
      // 添加部分
      vector<int> mark(number, -1);
      return back_track(numberm, mark);
  }
};
动态规划：
class Solution {
public:
    int cutRope(int number) {
        if (number == 2) {
            return 1;
        }
        else if (number == 3) {
            return 2;
        }
        vector<int> f(number + 1, -1);
        for (int i = 1; i <= 4; ++i) {
            f[i] = i;
        }
        for (int i = 5; i <= number; ++i) {
            for (int j = 1; j < i; ++j) {
                f[i] = max(f[i], j * f[i - j]);
            }
        }
        return f[number];
    }
};
```
