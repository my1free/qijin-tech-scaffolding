


在服务根目录下根据骨架生成 archetype (generate.sh)
```
mvn archetype:create-from-project -Darchetype.properties=archetype.properties
```
生成 target 目录


### 升级版本
升级版本不要一个文件一个文件修改，请使用以下命令:
```
mvn versions:set -DnewVersion=2.0.0-SNAPSHOT
```
