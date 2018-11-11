## 作用
自动生成commons目录下的子module

## 使用方法
在没有pom.xml的任意目录执行如下命令：

```
mvn archetype:generate -DarchetypeGroupId=com.qijin.archetype -DarchetypeArtifactId=qijin-quickstart -DarchetypeVersion=1.0-SNAPSHOT -DgroupId=com.qijin.commons  -DartifactId=demo  -Dversion=1.0.0-SNAPSHOT  -Dpackage=com.qijin.commons.demo
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
│   │       └── com
│   │           └── qijin
│   │               └── commons
│   │                   └── demo
│   │                       └── App.java
│   └── test
│       └── java
│           └── com
│               └── qijin
│                   └── commons
│                       └── demo
│                           └── AppTest.java
```

其中，`pom.xml`中核心内容有:

```xml
<parent>
    <artifactId>parent</artifactId>
    <groupId>com.qijin.commons</groupId>
    <version>1.0.0-SNAPSHOT</version>
    <relativePath>../commons-parent</relativePath>
</parent>

<groupId>com.qijin.commons</groupId>
<artifactId>demo</artifactId>
<version>1.0.0-SNAPSHOT</version>
```

即，定义了该module的parent和自身的一些定义

这样，就生成了一个子module所需的所有基础配置。

然后再将该module放到commons目录下，同时在commons/pom.xml中添加该`<module>`。一个全新的基础jar包就生成了。

## TODO
1. UT仍需完善
2. 目前只能生成commons下的子module，如需支持自定义父模块，仍需完善

执行命令放到最后一行：
mvn archetype:generate -DarchetypeGroupId=com.qijin.archetype -DarchetypeArtifactId=qijin-quickstart -DarchetypeVersion=1.0-SNAPSHOT -Dcatalog=local -DgroupId=com.qijin.commons  -DartifactId=demo  -Dversion=1.0.0-SNAPSHOT  -Dpackage=com.qijin.commons.demo -DinteractiveMode=false
