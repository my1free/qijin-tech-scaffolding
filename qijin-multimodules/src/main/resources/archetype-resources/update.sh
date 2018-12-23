#!/bin/bash
# 脚本作用：
#   更新scaffolding中的变更

# 背景:
#   当scaffolding中有变更时，已有工程怎么把这些变更更新过来？
#   通过scaffolding重新生成工程，直接覆盖？显然是不行的，这会覆盖掉已有工程后来的改动！
#   一个一个文件地对比？可行，但是太费时间！
#   因此，开发了这个脚本。通过此脚本，可自动对比已有工程与通过scaffolding生成工程的差异，并将差异展示出来。使用者可自行取舍两方的差异

# 使用方法
#   1. 执行本脚本，即执行：sh update.sh
#   2. 该脚本会自动对比所有文件，并通过vimdiff展示
#   3. 使用者根据二者的区别，根据需要进行取舍

# 注意：
#   1. 差异使用vimdiff展示，使用者需要有vim操作的经验
#   2. vimdiff展示的左侧是通过scaffolding生成的工程文件，右侧是已有工程文件
#   3. 文件是否有差异是通过对比二者文件中的md5值来进行的
#   4. 以scaffolding生成的文件列表为模板。只存在于已有工程中的文件，不在对比之列



function find_groupid()
{
    line=`grep "groupId" pom.xml | head -n2 |tail -n1 | sed 's/ //g'`
    length=${#line}
    step=$((length-19))
    echo ${line:9:$step}
}
function find_artifactid()
{
    line=`grep "artifactId" pom.xml | head -n2 |tail -n1|sed 's/ //g'`
    length=${#line}
    step=$((length-25))
    echo ${line:12:$step}
}
function find_version()
{
    line=`grep "version" pom.xml | head -n2 |tail -n1 | sed 's/ //g'`
    length=${#line}
    step=$((length-19))
    echo ${line:9:$step}
}

function gen_tmp_project
{
    groupid=$1
    artifactid=$2
    version=$3
    package=$groupid
    cd /tmp
    if [ -d $artifactid ];then
        echo "[INFO] $artifactid exists. delete it"
        /bin/rm -rf $artifactid
    fi
    mvn archetype:generate -DarchetypeGroupId=tech.qijin.archetype -DarchetypeArtifactId=qijin-multimodules -DarchetypeVersion=1.0-SNAPSHOT -DgroupId=$groupid  -DartifactId=$artifactid  -Dversion=$version  -Dpackage=$package -DinteractiveMode=false
    cd -
}

function lsdir()
{
    local dir=$1
    for i in `ls $dir`;do
        if [ -d "$dir/$i" ] ;then
            lsdir $dir/$i
        else
            file=$dir/$i
            echo $file
        fi
    done
}

function diff_file
{
    srcFile=$1
    desFile=$2
    if [ -f $desFile ];then
        srcMd5=`cat $srcFile | md5`
        desMd5=`cat $desFile | md5`
        if [ $srcMd5 = $desMd5 ];then
            echo "[SUCCESS] equals file: $desFile"
        else
            echo "[WARNING] unequals file: $desFile"
            vimdiff $srcFile $desFile
        fi
    else
        echo "[WARNING] file not found: $desFile. copy it"
        desPath=$(dirname "$desFile")
        if [ ! -d $desPath ];then
            echo "$desPath not exist. create"
            mkdir -p $desPath
        fi
        cp $srcFile $desFile
    fi
}

function diff_files
{
    template_path=$1
    opponent_path=$2
    template_res=`lsdir $template_path`
    template_files=(${template_res// / })
    if [ ${#template_files} -eq 0 ];then
        echo "[WARNING] there are no files in path $template_path"
        exit 1
    fi
    for ele in ${template_files[@]};do
        file_name=`echo $ele | awk -F"$template_path" '{print $2}'`
        opponent_file=$opponent_path$file_name
        diff_file $ele $opponent_file
    done
}

function main()
{
    if ! [ -f pom.xml ];then
        echo "can not find pom.xml"
        exit 1
    fi
    groupid=`find_groupid`
    artifactid=`find_artifactid`
    version=`find_version`
    echo "[INFO] groupId is: $groupid"
    echo "[INFO] artifactId is: $artifactid"
    echo "[INFO] version is: $version"
    echo "[INFO] start to generate project from archetype"
    gen_tmp_project $groupid $artifactid $version

    echo "[INFO] start to diff files"
    template_path="/tmp/$artifactid"
    opponent_path="."

    diff_files $template_path $opponent_path
}

main
