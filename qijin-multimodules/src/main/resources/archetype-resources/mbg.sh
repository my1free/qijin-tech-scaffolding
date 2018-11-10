#!/bin/bash

mvn -Dmybatis.generator.over@Profilewrite=true mybatis-generator:generate -pl ${artifactId}-db/