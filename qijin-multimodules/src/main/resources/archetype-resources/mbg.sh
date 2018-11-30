#!/bin/bash

mvn -Dmybatis.generator.overwrite=true mybatis-generator:generate -pl ${artifactId}-db/

echo "开始生成Dao文件"

pack=${package}
artifactId=${artifactId}

pack_path=`echo $pack | sed 's/\./\//g'`

function create_dao()
{
    file=$1
    prefix=$2
    mapper_class=${prefix}Mapper
    if [ -f $file ];then
        echo "======== [SUCCESS] $file exist, skip ========"
        return
    fi
    echo "======== [WARNING] $file not exist, create ========"
    touch $file
    dao_pack=${pack}.db.dao
    echo "package $dao_pack;" >> $file
    echo "" >> $file
    import=${pack}.db.mapper.$mapper_class
    echo "import $import;" >> $file
    echo "/**" >> $file
    echo "* @author: SYSTEM" >> $file
    echo "**/" >> $file
    echo "" >> $file
    echo "public interface ${prefix}Dao extends ${prefix}Mapper {" >> $file
    echo "" >> $file
    echo "}" >> $file
}

mapper_path=${artifactId}-db/src/main/java/$pack_path/db/mapper
dao_path=${artifactId}-db/src/main/java/$pack_path/db/dao

if [ ! -d $dao_path ];then
    echo "======== [INFO]$dao_path not exist! create ========"
    mkdir -p $dao_path
fi

dir=$mapper_path
for i in `ls $dir`;do
    if [ -d "$dir/$i" ] ;then
        lsdir $dir/$i
    else
        file=$dir/$i
        file_name=$(basename $file)
        nf=`echo $file_name | awk -F"Mapper.java" '{print NF}'`
        if [ ! $nf -eq 2 ];then
            continue
        fi
        echo "======== [INFO] mapper file: $file ========"
        prefix=`echo $file_name | awk -F"Mapper.java" '{print $1}'`
        dao_file="${prefix}Dao.java"
        create_dao $dao_path/$dao_file $prefix
    fi
done