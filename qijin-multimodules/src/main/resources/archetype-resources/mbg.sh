#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

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
model_path=${artifactId}-db/src/main/java/$pack_path/db/model

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

function camel_to_lowercase()
{
    camel=$1
    echo $camel | sed -e 's/\([A-Z]\)/_\1/g' -e 's/^_//'|awk '{print tolower($0)}'
}

key_reserved_words=("accessible " "action" "add " "after" "against" "aggregate" "algorithm" "all " "alter " "analyse" "analyze " "and " "any" "as " "asc " "ascii" "asensitive " "at" "autoextend_size" "auto_increment" "avg" "avg_row_length" "backup" "before " "begin" "between " "bigint " "binary " "binlog" "bit" "blob " "block" "bool" "boolean" "both " "btree" "by " "byte" "cache" "call " "cascade " "cascaded" "case " "catalog_name" "chain" "change " "changed" "char " "character " "charset" "check " "checksum" "cipher" "class_origin" "client" "close" "coalesce" "code" "collate " "collation" "column " "columns" "column_format" "column_name" "comment" "commit" "committed" "compact" "completion" "compressed" "concurrent" "condition " "connection" "consistent" "constraint " "constraint_catalog" "constraint_name" "constraint_schema" "contains" "context" "continue " "convert " "cpu" "create " "cross " "cube" "current" "current_date " "current_time " "current_timestamp " "current_user " "cursor " "cursor_name" "data" "database " "databases " "datafile" "date" "datetime" "day" "day_hour " "day_microsecond " "day_minute " "day_second " "deallocate" "dec " "decimal " "declare " "default " "default_auth" "definer" "delayed " "delay_key_write" "delete " "desc " "describe " "des_key_file" "deterministic " "diagnostics" "directory" "disable" "discard" "disk" "distinct " "distinctrow " "div " "do" "double " "drop " "dual " "dumpfile" "duplicate" "dynamic" "each " "else " "elseif " "enable" "enclosed " "end" "ends" "engine" "engines" "enum" "error" "errors" "escape" "escaped " "event" "events" "every" "exchange" "execute" "exists " "exit " "expansion" "expire" "explain " "export" "extended" "extent_size" "false " "fast" "faults" "fetch " "fields" "file" "first" "fixed" "float " "float4 " "float8 " "flush" "for " "force " "foreign " "format" "found" "from " "full" "fulltext " "function" "general" "geometry" "geometrycollection" "get " "get_format" "global" "grant " "grants" "group " "handler" "hash" "having " "help" "high_priority " "host" "hosts" "hour" "hour_microsecond " "hour_minute " "hour_second " "identified" "if " "ignore " "ignore_server_ids" "import" "in " "index " "indexes" "infile " "initial_size" "inner " "inout " "insensitive " "insert " "insert_method" "install" "int " "int1 " "int2 " "int3 " "int4 " "int8 " "integer " "interval " "into " "invoker" "io" "io_after_gtids " "io_before_gtids " "io_thread" "ipc" "is " "isolation" "issuer" "iterate " "join " "key " "keys " "key_block_size" "kill " "language" "last" "leading " "leave " "leaves" "left " "less" "level" "like " "limit " "linear " "lines " "linestring" "list" "load " "local" "localtime " "localtimestamp " "lock " "locks" "logfile" "logs" "long " "longblob " "longtext " "loop " "low_priority " "master" "master_auto_position" "master_bind " "master_connect_retry" "master_delay" "master_heartbeat_period" "master_host" "master_log_file" "master_log_pos" "master_password" "master_port" "master_retry_count" "master_server_id" "master_ssl" "master_ssl_ca" "master_ssl_capath" "master_ssl_cert" "master_ssl_cipher" "master_ssl_crl" "master_ssl_crlpath" "master_ssl_key" "master_ssl_verify_server_cert " "master_user" "match " "maxvalue " "max_connections_per_hour" "max_queries_per_hour" "max_rows" "max_size" "max_updates_per_hour" "max_user_connections" "medium" "mediumblob " "mediumint " "mediumtext " "memory" "merge" "message_text" "microsecond" "middleint " "migrate" "minute" "minute_microsecond " "minute_second " "min_rows" "mod " "mode" "modifies " "modify" "month" "multilinestring" "multipoint" "multipolygon" "mutex" "mysql_errno" "name" "names" "national" "natural " "nchar" "ndb" "ndbcluster" "new" "next" "no" "nodegroup" "none" "not " "no_wait" "no_write_to_binlog " "null " "number" "numeric " "nvarchar" "offset" "on " "one" "only" "open" "optimize " "option " "optionally " "options" "or " "order " "out " "outer " "outfile " "owner" "pack_keys" "page" "parser" "partial" "partition " "partitioning" "partitions" "password" "phase" "plugin" "plugins" "plugin_dir" "point" "polygon" "port" "precision " "prepare" "preserve" "prev" "primary " "privileges" "procedure " "processlist" "profile" "profiles" "proxy" "purge " "quarter" "query" "quick" "range " "read " "reads " "read_only" "read_write " "real " "rebuild" "recover" "redofile" "redo_buffer_size" "redundant" "references " "regexp " "relay" "relaylog" "relay_log_file" "relay_log_pos" "relay_thread" "release " "reload" "remove" "rename " "reorganize" "repair" "repeat " "repeatable" "replace " "replication" "require " "reset" "resignal " "restore" "restrict " "resume" "return " "returned_sqlstate" "returns" "reverse" "revoke " "right " "rlike " "rollback" "rollup" "routine" "row" "rows" "row_count" "row_format" "rtree" "savepoint" "schedule" "schema " "schemas " "schema_name" "second" "second_microsecond " "security" "select " "sensitive " "separator " "serial" "serializable" "server" "session" "set " "share" "show " "shutdown" "signal " "signed" "simple" "slave" "slow" "smallint " "snapshot" "socket" "some" "soname" "sounds" "source" "spatial " "specific " "sql " "sqlexception " "sqlstate " "sqlwarning " "sql_after_gtids" "sql_after_mts_gaps" "sql_before_gtids" "sql_big_result " "sql_buffer_result" "sql_cache" "sql_calc_found_rows " "sql_no_cache" "sql_small_result " "sql_thread" "sql_tsi_day" "sql_tsi_hour" "sql_tsi_minute" "sql_tsi_month" "sql_tsi_quarter" "sql_tsi_second" "sql_tsi_week" "sql_tsi_year" "ssl " "stacked" "start" "starting " "starts" "stats_auto_recalc" "stats_persistent" "stats_sample_pages" "status" "stop" "storage" "straight_join " "string" "subclass_origin" "subject" "subpartition" "subpartitions" "super" "suspend" "swaps" "switches" "table " "tables" "tablespace" "table_checksum" "table_name" "temporary" "temptable" "terminated " "text" "than" "then " "time" "timestamp" "timestampadd" "timestampdiff" "tinyblob " "tinyint " "tinytext " "to " "trailing " "transaction" "trigger " "triggers" "true " "truncate" "type" "types" "uncommitted" "undefined" "undo " "undofile" "undo_buffer_size" "unicode" "uninstall" "union " "unique " "unknown" "unlock " "unsigned " "until" "update " "upgrade" "usage " "use " "user" "user_resources" "use_frm" "using " "utc_date " "utc_time " "utc_timestamp " "value" "values " "varbinary " "varchar " "varcharacter " "variables" "varying " "view" "wait" "warnings" "week" "weight_string" "when " "where " "while " "with " "work" "wrapper" "write " "x509" "xa" "xml" "xor " "year" "year_month " "zerofill " "account" "always" "channel" "compression" "encryption" "file_block_size" "filter" "follows" "generated " "group_replication" "instance" "json" "master_tls_version" "max_statement_time" "never" "nonblocking" "old_password" "optimizer_costs " "parse_gcol_expr" "precedes" "replicate_do_db" "replicate_do_table" "replicate_ignore_db" "replicate_ignore_table" "replicate_rewrite_db" "replicate_wild_do_table" "replicate_wild_ignore_table" "rotate" "stored " "validation" "virtual " "without" "xid")

# check mysql reserved word
echo "======== [INFO] start to check mysql keywords and reserved words. Reference: https://dev.mysql.com/doc/refman/5.7/en/keywords.html ========"
for model in `ls ${model_path}`;do
    tb_file=`camel_to_lowercase $model`
    tb_name=`basename $tb_file .java`
    camel=`cat ${model_path}/$model | grep "private" | cut -d' ' -f7 | cut -d';' -f1`
    for i in ${camel[@]};do
        lowercase=`camel_to_lowercase $i`
        if [[ " ${key_reserved_words[@]} " =~ " ${lowercase} " ]]; then
            echo "${YELLOW} ======== [WARNING] ${RED}${BOLD}$lowercase ${NORMAL}${YELLOW}in table ${RED}${BOLD}${tb_name} ${NORMAL}${YELLOW}is mysql keyword or reserved word. ========"
        fi
    done
done
