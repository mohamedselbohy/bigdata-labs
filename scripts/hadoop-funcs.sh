#!/usr/bin/env bash

CONTAINER_NAME="${CONTAINER_NAME:-namenode}"

hdfs-mkdir() {
  local path="$1"
  docker exec "$CONTAINER_NAME" bash -c "hdfs dfs -mkdir -p $path"
}

hdfs-copy() {
  local local_path="$1"
  local hdfs_path="$2"
  local aux_path="/tmp/hdfs-copy-aux/$(basename "$local_path")"
  docker exec "$CONTAINER_NAME" bash -c "mkdir -p /tmp/hdfs-copy-aux"
  docker cp "$local_path" "$CONTAINER_NAME:$aux_path"
  docker exec "$CONTAINER_NAME" bash -c "hdfs dfs -put $aux_path $hdfs_path"
  docker exec "$CONTAINER_NAME" bash -c "rm -rf /tmp/hdfs-copy-aux"
}

hdfs-get() {
  local local_path="$2"
  local hdfs_path="$1"
  local aux_path="/tmp/hdfs-copy-aux/$(basename "$hdfs_path")"
  docker exec "$CONTAINER_NAME" bash -c "mkdir -p /tmp/hdfs-copy-aux"
  docker exec "$CONTAINER_NAME" bash -c "hdfs dfs -get $hdfs_path $aux_path"
  docker cp "$CONTAINER_NAME:$aux_path" "$local_path"
  docker exec "$CONTAINER_NAME" bash -c "rm -rf /tmp/hdfs-copy-aux"
}

hdfs-cat() {
  local hdfs_path="$1"
  docker exec "$CONTAINER_NAME" bash -c "hdfs dfs -cat $hdfs_path"
}

hdfs-rm() {
  local path="$1"
  docker exec "$CONTAINER_NAME" bash -c "hdfs dfs -rm -r $path"
}

hdfs-ls() {
  local path="${1:-/}"
  docker exec "$CONTAINER_NAME" bash -c "hdfs dfs -ls $path"
}

hadoop-build() {
  mvn package -DskipTests
}

hadoop-run() {
  # hadoop-run <compiled-jar-output> <class-name> <input-file-path> <output-directory-path>
  local jar_file="$1"
  local class_name="$2"
  local input_path="$3"
  local output_path="$4"

  local jar_name=$(basename "$jar_file")
  docker cp "$jar_file" "$CONTAINER_NAME:/tmp/$jar_name"
  docker exec "$CONTAINER_NAME" bash -c "hadoop jar /tmp/$jar_name $class_name $input_path $output_path"
  docker exec "$CONTAINER_NAME" bash -c "rm -f /tmp/$jar_name"
}
