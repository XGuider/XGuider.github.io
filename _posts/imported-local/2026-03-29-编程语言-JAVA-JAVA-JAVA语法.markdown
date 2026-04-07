---
layout: "post"
title: "JAVA语法"
subtitle: "编程语言 / JAVA / JAVA"
date: "2026-03-29 14:07:21"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - JAVA
categories:
    - 编程语言
---

{% raw %}
> 来源：`本机相关/01-编程语言/01-JAVA/JAVA/JAVA语法.md`

---
tags:
  - Java
  - 编程语言
  - 基础语法
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

ArrayList的toArray方法返回一个数组
ArrayList的asList方法返回一个列表

# 按字典顺序比较两个字符串
ArrayList<String> list = new ArrayList<String>();
Collections.sort(list, new Comparator<String>() {
    @Override
     public int compare(String o1, String o2) {
        // TODO Auto-generated method stub
         return 0;
     }
});


#前序和中序 遍历获取 二叉树

class Solution {
    public TreeNode buildTree(int[] preorder, int[] inorder) {
        if (preorder == null || inorder == null) {
            return null;
        }
        return dfs(preorder,inorder);
    }

    public static TreeNode dfs(int[] preorder, int[] inorder){
        if (preorder.length == 0 || inorder.length == 0){
            return null;
        }
        TreeNode root = new TreeNode(preorder[0]);
        int flag = 0;
        for (int i = 0; i < inorder.length; i++){
            if (preorder[0] == inorder[i]){
                flag = i;
                break;
            }
        }

        root.left = dfs(Arrays.copyOfRange(preorder,1,flag+1), Arrays.copyOfRange(inorder,0,flag));
        root.right = dfs(Arrays.copyOfRange(preorder,flag+1,preorder.length),Arrays.copyOfRange(inorder,flag+1,
                inorder.length));
        return root;
}}
{% endraw %}
