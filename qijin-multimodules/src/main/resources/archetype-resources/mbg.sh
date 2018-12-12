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
    model=${prefix}
    sqlprovider=${model}SqlProvider
    echo "package $dao_pack;" >> $file
    echo "" >> $file
    import_mapper=${pack}.db.mapper.$mapper_class
    import_sqlprovider=${pack}.db.mapper.${sqlprovider}
    import_model=${pack}.db.model.${model}
    echo "import $import_mapper;" >> $file
    echo "import $import_sqlprovider;" >> $file
    echo "import $import_model;" >> $file
    echo "import org.apache.ibatis.annotations.Param;" >> $file
    echo "import org.apache.ibatis.annotations.InsertProvider;" >> $file
    echo "import com.google.common.collect.Lists;" >> $file
    echo "import org.apache.commons.lang3.StringUtils;" >> $file
    echo "import java.util.List;" >> $file
    echo "import java.util.Map;" >> $file
    echo "import java.util.stream.Collectors;" >> $file
    echo "" >> $file
    echo "/**" >> $file
    echo " * @author: SYSTEM" >> $file
    echo " **/" >> $file
    echo "" >> $file
    echo "public interface ${prefix}Dao extends ${prefix}Mapper {" >> $file
    echo "" >> $file
    echo "\t@InsertProvider(type = SqlProvider.class, method = \"batchInsert\")" >> $file
    echo "\tint batchInsert(@Param(\"records\") List<${model}> records);" >> $file
    echo "" >> $file
    echo "\tclass SqlProvider {" >> $file
    echo "\t\tprivate static final String VALUES = \"VALUES\";" >> $file
    echo "\t\t${sqlprovider} provider = new ${sqlprovider}();" >> $file
    echo "" >> $file
    echo "\t\tpublic String batchInsert(Map<String, Object> param) {" >> $file
    echo "\t\t\tList<${model}> records = (List<${model}>) param.get(\"records\");" >> $file
    echo "\t\t\treturn genSql(records);" >> $file
    echo "\t\t}" >> $file
    echo "" >> $file
    echo "\t\tprivate String genSql(List<${model}> records) {" >> $file
    echo "\t\t\tList<String> sqls = records.stream()" >> $file
    echo "\t\t\t\t\t.map(record -> provider.insertSelective(record))" >> $file
    echo "\t\t\t\t\t.collect(Collectors.toList());" >> $file
    echo "\t\t\tString[] arr = sqls.get(0).split(VALUES);" >> $file
    echo "\t\t\tString head = arr[0];" >> $file
    echo "\t\t\tString value = arr[1];" >> $file
    echo "\t\t\tList<String> values = Lists.newArrayList();" >> $file
    echo "\t\t\tfor (int i = 0; i <= sqls.size() - 1; i++) {" >> $file
    echo "\t\t\t\tStringBuilder sb = new StringBuilder().append(\"#{records[\").append(i).append(\"].\");" >> $file
    echo "\t\t\t\tvalues.add(value.replace(\"#{\", sb.toString()));" >> $file
    echo "\t\t\t}" >> $file
    echo "\t\t\treturn new StringBuilder().append(head).append(\" \").append(VALUES).append(\" \")" >> $file
    echo "\t\t\t\t\t.append(StringUtils.join(values, \",\")).toString();" >> $file
    echo "\t\t}" >> $file
    echo "\t}" >> $file
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
