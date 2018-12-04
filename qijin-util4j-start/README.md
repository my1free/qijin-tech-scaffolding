## 作用
自动生成util4j目录下的子module

## 使用方法
在没有pom.xml的任意目录执行如下命令：

```
mvn archetype:generate -DarchetypeGroupId=tech.qijin.archetype -DarchetypeArtifactId=qijin-util4j-start -DarchetypeVersion=1.0-SNAPSHOT -Dcatalog=local -DgroupId=tech.qijin.util4j  -DartifactId=demo  -Dversion=1.0.0-SNAPSHOT  -Dpackage=tech.qijin.util4j.demo -DinteractiveMode=false
```

其中如下参数须根据需要，自行修改:

`-DartifactId`

`-Dversion`: 建议使用1.0.0-SNAPSHOT
  
`-Dpackage`: 

如，上面的命令执行完成后，会生成如下的一个工程:

```
├── pom.xml
├── src
│   ├── main
│   │   └── java
│   │       └── tech
│   │           └── qijin
│   │               └── util4j
│   │                   └── demo
│   │                       └── App.java
│   └── test
│       └── java
│           └── tech
│               └── qijin
│                   └── util4j
│                       └── demo
│                           └── AppTest.java
```

其中，`pom.xml`中核心内容有:

```xml
<parent>
    <artifactId>parent</artifactId>
    <groupId>tech.qijin.util4j</groupId>
    <version>1.0.0-SNAPSHOT</version>
    <relativePath>../util4j-parent</relativePath>
</parent>

<groupId>tech.qijin.util4j</groupId>
<artifactId>demo</artifactId>
<version>1.0.0-SNAPSHOT</version>
```

即，定义了该module的parent和自身的一些定义

这样，就生成了一个子module所需的所有基础配置。

然后再将该module放到util4j目录下，同时在util4j/pom.xml中添加该`<module>`。一个全新的基础jar包就生成了。

## TODO
1. UT仍需完善
2. 目前只能生成util4j下的子module，如需支持自定义父模块，仍需完善

执行命令放到最后一行：
mvn archetype:generate -DarchetypeGroupId=tech.qijin.archetype -DarchetypeArtifactId=qijin-util4j-start -DarchetypeVersion=1.0-SNAPSHOT -Dcatalog=local -DgroupId=tech.qijin.util4j  -DartifactId=demo  -Dversion=1.0.0-SNAPSHOT  -Dpackage=tech.qijin.util4j.demo -DinteractiveMode=false
