#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_ROOT="$(dirname "$SCRIPT_DIR")"
LIBS_DIR="$ENV_ROOT/hadoop-lib"

has_jars() {
  find "$LIBS_DIR" -name "*.jar" 2>/dev/null | head -1 | grep -q .
}

mkdir -p "$LIBS_DIR/mapreduce" "$LIBS_DIR/common" "$LIBS_DIR/hdfs" "$LIBS_DIR/yarn"

if ! has_jars; then
  echo "Copying Hadoop Jars from temporary container..."

  docker run -d --name temp-hadoop-libs apache/hadoop:3.4 sleep infinity
  docker cp temp-hadoop-libs:/opt/hadoop/share/hadoop/mapreduce/. "$LIBS_DIR/mapreduce/"
  docker cp temp-hadoop-libs:/opt/hadoop/share/hadoop/common/. "$LIBS_DIR/common/"
  docker cp temp-hadoop-libs:/opt/hadoop/share/hadoop/hdfs/. "$LIBS_DIR/hdfs/"
  docker cp temp-hadoop-libs:/opt/hadoop/share/hadoop/yarn/. "$LIBS_DIR/yarn/"
  docker rm -f temp-hadoop-libs

  echo "Hadoop Jars copied into $LIBS_DIR"
else
  echo "Hadoop libs already present, skipping copy"
fi

source "$SCRIPT_DIR/hadoop-funcs.sh"

if [ -d "$ENV_ROOT/.venv" ]; then
  source "$ENV_ROOT/.venv/bin/activate"
else
  python3 -m venv "$ENV_ROOT/.venv"
  source "$ENV_ROOT/.venv/bin/activate"
  pip install -r "$ENV_ROOT/requirements.txt"
fi
