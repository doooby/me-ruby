set -e
root_path=/me
db_path=$root_path/var/production.sqlite3

# DOCS
# either pass a source file to copy
# or pass "--empty" to write new empty database

function assure_db_path_exists() {
  if [ -f $db_path ]; then
    echo "The database seems to exist already."
    echo "Delete $db_path first, if you mean to."
    exit 0
  fi
  mkdir -p `dirname $db_path`
}

function create_empty_db() {
  set -x
  sqlite3 $db_path "VACUUM;"
  set +x
}

function copy_file_from() {
  local source_path="$1"
  set -x
  cp $source_path $db_path
  set +x
}

assure_db_path_exists

copy_from="$1"
if [ $copy_from == "--empty" ]; then
  create_empty_db
else
  copy_file_from $copy_from
fi
