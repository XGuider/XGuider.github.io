---
layout: "post"
title: "Spring注解"
subtitle: "Java开发 / Spring框架 / Spring"
date: "2025-07-29 16:23:51"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Spring框架
    - Spring
categories:
    - Java开发
---

{% raw %}
> 来源：`本机相关/02-Java开发/01-Spring框架/Spring/Spring注解.md`

注解（Annotation）是 Java 语言中的一种元数据（metadata），它提供了一种在代码中添加元数据的方式。注解本身不会直接影响代码的执行，但它们可以被编译器、工具或框架用来生成代码、配置文件，或者在运行时通过反射机制来获取和处理这些元数据。

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
public @interface TableName {
    String value() default "";

    String resultMap() default "";
} 

@Documented:
表示这个注解应该被包含在 JavaDoc 文档中。
@Retention(RetentionPolicy.RUNTIME):
表示这个注解在运行时可以通过反射获取到。
@Target({ElementType.TYPE}):
表示这个注解只能应用于类（TYPE）。
String value() default "";:
这是一个注解的属性，用于指定表名。默认值为空字符串。
String resultMap() default "";:
这是另一个注解的属性，用于指定结果映射的名称。默认值为空字符串。


1. 定义注解
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.SOURCE)
@Target(ElementType.TYPE)
public @interface GenerateGetterSetter {
}

2. 实现注解处理器
import javax.annotation.processing.*;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.*;
import javax.lang.model.type.TypeMirror;
import javax.tools.Diagnostic;
import java.util.Set;

@SupportedAnnotationTypes("GenerateGetterSetter")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class GetterSetterProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        for (Element element : roundEnv.getElementsAnnotatedWith(GenerateGetterSetter.class)) {
            if (element.getKind() == ElementKind.CLASS) {
                generateGetterSetter((TypeElement) element);
            }
        }
        return true;
    }

    private void generateGetterSetter(TypeElement typeElement) {
        String className = typeElement.getSimpleName().toString();
        StringBuilder sourceCode = new StringBuilder();

        // 生成类的头部
        sourceCode.append("public class ").append(className).append(" {\n");

        // 遍历类的字段
        for (Element enclosedElement : typeElement.getEnclosedElements()) {
            if (enclosedElement.getKind() == ElementKind.FIELD) {
                VariableElement field = (VariableElement) enclosedElement;
                String fieldName = field.getSimpleName().toString();
                TypeMirror fieldType = field.asType();

                // 生成 getter 方法
                sourceCode.append("    public ").append(fieldType).append(" get").append(capitalize(fieldName)).append("() {\n");
                sourceCode.append("        return this.").append(fieldName).append(";\n");
                sourceCode.append("    }\n");

                // 生成 setter 方法
                sourceCode.append("    public void set").append(capitalize(fieldName)).append("(").append(fieldType).append(" ").append(fieldName).append(") {\n");
                sourceCode.append("        this.").append(fieldName).append(" = ").append(fieldName).append(";\n");
                sourceCode.append("    }\n");
            }
        }

        // 生成类的尾部
        sourceCode.append("}\n");

        // 输出生成的代码
        processingEnv.getMessager().printMessage(Diagnostic.Kind.NOTE, sourceCode.toString());
    }

    private String capitalize(String name) {
        if (name == null || name.length() == 0) {
            return name;
        }
        return name.substring(0, 1).toUpperCase() + name.substring(1);
    }
}
3. 注册注解处理器
在 META-INF/services 目录下创建一个名为 javax.annotation.processing.Processor 的文件，并在文件中添加你的处理器类的全限定名：
com.example.GetterSetterProcessor

4. 使用注解
@GenerateGetterSetter
public class Person {
    private String name;
    private int age;
}
{% endraw %}
