
 test
## 作用
自动生成一个带有multimodule的工程。如生成类似account这样的，可以单独作为一个服务的工程。

## 特点
1. 自动生成multimodule
2. 自动生成多个module。目前支持的module有:

    - xxx-base: 基础包

    - xxx-db: 提供访问db的类和方法。可通过mbg自动生成mapper、model和动态查询sql。
    
    - xxx-rpc-client: rpc client
    
    - xxx-service: 服务于xxx-server，整个系统核心逻辑所在
    
    - xxx-server: 提供rpc和rest接口
    
3. server使用spring boot2
4. 一键执行命令后，极少改动，即可得到一个完整工程

## 使用方法

### 生成工程
在任何没有pom.xml文件的目录下，执行如下命令：

### 生成工程
在任何没有pom.xml文件的目录下，执行如下命令：

```
mvn archetype:generate -DarchetypeGroupId=tech.qijin.archetype -DarchetypeArtifactId=qijin-multimodules -DarchetypeVersion=1.0-SNAPSHOT -DgroupId=tech.qijin.account  -DartifactId=account  -Dversion=1.0.0-SNAPSHOT  -Dpackage=tech.qijin.account -DinteractiveMode=false
```

其中如下参数须根据需要，自行修改:

`-DgroupId`: tech.qijin.xxx

`-DartifactId`: xxx。这里的xxx与上面的`-DgroupId`中的xxx一致

`-Dversion`: 建议使用1.0.0-SNAPSHOT
  
`-Dpackage`: tech.qijin.xxx

执行如上命令后，会生成如下工程目录(以生成account项目为例):

```
account/
├── account-db
│   ├── pom.xml
│   └── src
│       ├── main
│       │   ├── java
│       │   │   └── com
│       │   │       └── qijin
│       │   │           └── account
│       │   │               └── db
│       │   │                   ├── dao
│       │   │                   │   └── package-info.java
│       │   │                   └── package-info.java
│       │   └── resources
│       │       ├── application.properties
│       │       └── generatorConfig.xml
├── account-rpcclient
│   ├── pom.xml
│   └── src
│       ├── main
│       │   ├── java
│       │   │   └── com
│       │   │       └── qijin
│       │   │           └── account
│       │   │               └── rpcclient
│       │   │                   └── package-info.java
│       │   └── resources
├── account-server
│   ├── pom.xml
│   └── src
│       ├── main
│       │   ├── java
│       │   │   └── com
│       │   │       └── qijin
│       │   │           └── account
│       │   │               └── server
│       │   │                   ├── ServerApplication.java
│       │   │                   ├── api
│       │   │                   │   └── BaseController.java
│       │   │                   └── rpcserver
│       │   │                       └── package-info.java
│       │   └── resources
├── account-service
│   ├── pom.xml
│   └── src
│       ├── main
│       │   ├── java
│       │   │   └── com
│       │   │       └── qijin
│       │   │           └── account
│       │   │               └── service
│       │   │                   └── package-info.java
│       │   └── resources
└── pom.xml
```

### mbg生成db支持

生成项目架构后，xxx-db还需要执行如下命令，使之自动生成与数据库一一对应的model，同时生成mapper:

>**注意**
>
>在执行如下命令之前，需要做一些配置：
>
>配置数据库地址和要连的database ↓_↓
>
>spring.datasource.url=jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf-8
>
>配置数据库username ↓_↓
>
>spring.datasource.username=root
>
>配置数据库密码 ↓_↓
>
>spring.datasource.password=

```
# 首先一定要先进入刚生成的工程目录
cd xxx
mvn -U clean  mybatis-generator:generate -pl xxx-db/
```

如:
```
cd account
mvn -U clean  mybatis-generator:generate -pl account-db/
```

数据库每次变动后，都需要执行上面的语句，很长，记不住，很麻烦。为此，将上面的命令写到了mbg.sh脚本中。这样，每次数据库改动后，只需执行：
```
sh mbg.sh
```

生成的目录结构如下所示，数据库中的table和column会自动生成对应的Java类。同时生成了常见的CRUD操作：
```
account-db/
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── qijin
    │   │           └── account
    │   │               └── db
    │   │                   ├── dao
    │   │                   │   └── package-info.java
    │   │                   ├── mapper
    │   │                   │   ├── UserMapper.java
    │   │                   │   └── UserSqlProvider.java
    │   │                   ├── model
    │   │                   │   ├── User.java
    │   │                   │   └── UserExample.java
    │   │                   └── package-info.java
    │   └── resources
    │       ├── application.properties
    │       └── generatorConfig.xml
```

### install依赖
server依赖service, db等，因此需要先把所有的包都install一下

```
# 在生成工程的根目录
mvn -U clean install -Dmaven.test.skip 
```


### 启动server测试

**打包server**

在生成的xxx目录中执行如下命令:
```
mvn -U clean package -pl xxx-server
```



**启动server**

>java -jar xxx-server/target/xxx-server.jar


在浏览器地址栏中输入：

```
http://localhost:8080/health_check
```

返回“Alive”即为正确

## 精简版

以生成account为例

```
mvn archetype:generate -DarchetypeGroupId=tech.qijin.archetype -DarchetypeArtifactId=qijin-multimodules -DarchetypeVersion=1.0-SNAPSHOT -DarchetypeCatalog=local -DgroupId=tech.qijin.account  -DartifactId=account  -Dversion=1.0.0-SNAPSHOT  -Dpackage=tech.qijin.account -DinteractiveMode=false

cd account

sh mbg.sh

mvn install

mvn package -pl account-server

java -jar account-server/target/account-server.jar

访问: http://localhost:8080/health_check 
```

## TODO
1. UT仍需完善
2. maven surefire plugin默认不能skip test的问题仍未解决

执行命令放到最后一行：
mvn archetype:generate -DarchetypeGroupId=tech.qijin.archetype -DarchetypeArtifactId=qijin-multimodules -DarchetypeVersion=1.0-SNAPSHOT -DarchetypeCatalog=local -DgroupId=tech.qijin.account  -DartifactId=account  -Dversion=1.0.0-SNAPSHOT  -Dpackage=tech.qijin.account -DinteractiveMode=false
