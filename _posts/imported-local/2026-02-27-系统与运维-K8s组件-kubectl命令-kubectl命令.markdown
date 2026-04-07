---
layout: "post"
title: "kubectl命令"
subtitle: "系统与运维 / K8s组件"
date: "2026-02-27 21:29:38"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - K8s组件
categories:
    - 系统与运维
---

> 来源：`本机相关/06-系统与运维/K8s组件/kubectl命令.md`

Lable：
1、查看命名空间下所有资源的标签：
kubectl get all --namespace=<namespace> --show-labels
2、如果你只想查看某一类资源（如 Pod）的标签，可以使用以下命令：
kubectl get pods --namespace=<namespace> --show-labels
3、查看某个特定 Pod 的标签：
kubectl get pod <pod-name> --namespace=<namespace> --show-labels
4、如果想查看某个具体资源（如 Pod）的详细标签，可以使用 kubectl describe 命令：
kubectl describe pod <pod-name> --namespace=<namespace>

如果你想要查看或修改标签，可以使用以下命令来操作：
添加标签到某个 Pod：
kubectl label pod <pod-name> <label-key>=<label-value> --namespace=<namespace>
删除某个标签：
kubectl label pod <pod-name> <label-key>- --namespace=<namespace>

kubectl describe deployment
kubectl get pods -l app=kubernetes-nginx
kubectl get services -l app=kubernetes-nginx
kubectl get pods -l version=v1



//保存文件上传至pod
kubectlcp<本地文件》<pod-name>:/etc/nginx/nginx.conf//查看所有configmaps信息
kubectl get cm -n datafinder realtime-task -o yam//查看作业和cronJob
kubectl get jobs -n<namespaces>
kubectl get cronjobs -nxnamespaces>//查看副本数
kubectl get deployments vpc-collect-applog -n data -o=jsonpath='{.spec.replicas}kubect1get deployments vpc"device"idsvc "n data "omjsonpathm'(.spec.replicas}"//扩容副本
kubectl scale deployments vpc-collect-applog -n data --replicas x//根据pod 知统dep1oyments
kubectl get pod clickhouse-2-1-0 -n clickhouse .o=jsonpath='{.metadata}"kubectl get pod clickhouse-2-1-8 -n clickhouse -o yamlkubectl describe pod vpc-task-realtime-finder-runninginfo-795c946b7d-k8ha8 -n datafinder


//日志排查
kubectl logs -n datafinder -lapp=vpc-task-realtime-finder-etl --tail 280 | grep --color -( 10 'error"exec it 'n datafinder vpc"task*realtime.finderrunninginfo-68448b9655-jg9sw .*/bin/bashkubect1kubectl logs -n datafinder -lapp=vpc-task-realtime-finder-parser ..tail 230 i grep …color .( 10 'finder etl error'
mbectl lois vpcteskerealitine finaeretl escsosec anstx "n astariner mtail soe i grep coior cie tnts t p
kubectl logs -n datafinder -lapp=vpc-device-idsvc --tail 208
alias 11'1s -alrh"


// 查看 pod部署节点情况
kubectl describe deployments vpc-task-realtime-finder-etl -n datafinder
kubectl get pods o wide l app=vpc.task-realtime-finder-etl -n datafinder
kubectl get pod -n datafinder -owide|grep et

#资源相关
kubectl top node
ansible all_nodes -m shell -a "free -g"


//查看yaml配置kubectl describe deployments vpc-collect-applog -n data.
kubectl get deployment vpc-collect-applog -n data .o yamlkubecti get deploy -n datarangers vpc-rangers-transformer -oyamlkubectl get cm-n data vpc-collect-applog -o yaml
//编疆confiemap
kubectl edit confiemep confiemap-simulator -n simulator
kubectl describe configmap/configmap-minibase-custom -n minibasekubectl get configmap/configmap-minibase-custom "n minibase *o=jsonpath…'(.datae.configl.json)’> config_$(modify time).json
//重启服务
kubectl rollout restart deployment vpc-simulator-simulatorbe -n simulator
kubectl rollout status deploy -n datarangers vpc-rangers-transformer// 更新或者创建pod


kubectl -n datarangers apply -f vpc-rangersmeta-cronjob-statics-data-reported.yaml
kubectl rollout status deploy "n datarangers vpc"rangers-transformer
kubectl get po -A



kubectl get sts -n minio：kubectl命令获取名为"minio"的StatefulSet在命名空间"minio"中的信息
包括副本数量、容器状态等

kubectl get modrules -n minio：查看副本情况
kubectl get xxx -n xx -o=jsonpath='{.data@.config\.json}'>tmp.json ：

 kubectl get 命令来获取指定命名空间（-n xx）中名为 xxx 的资源，并使用 -o=jsonpath='{.data@.config\.json}' 选项来指定 JSONPath 表达式。这个表达式的意思是从资源的 .data 字段中选择 config.json 键的值。

 kubectl -n datarangers apply -f xxx.yaml:kubectl 应用一个 YAML 文件来创建或更新 Kubernetes 资源，其中 -n datarangers 是指定了命名空间为 datarangers。这是一个很常见的操作，通常用于部署应用程序或者更新配置。

 kubectl get deploy xxx -n xxx -o yaml






kubectl delete deployment my-deployment：停止服务
kubectl指定节点部署服务
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
	kubernetes.io/hostname: your-specific-node-name
kubectl apply -f your-file.yaml




#查看所有Ingress：
kubectl get ingress
查看 my-ingress 的详细信息：

kubectl describe ingress my-ingress
查看 my-ingress 的YAML配置：

kubectl get ingress my-ingress -o yaml
通过这些命令，你可以方便地查看和管理Kubernetes集群中的Ingress资源配置
