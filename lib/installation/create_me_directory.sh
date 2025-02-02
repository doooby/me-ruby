set -e
root_path=/me

if [ -d $root_path ]; then
  echo "the directory $root_path already exists"
  exit 0
fi

echo "... creating directory $root_path"
set -x
sudo mkdir $root_path
sudo install -d -o $USER -g $USER -m 700 $root_path
set +x

echo "... pulling source code"
set -x
git clone git@github.com:doooby/me-ruby.git $root_path/src
set +x

echo "... setting production runner"
function GenerateBinRunner () {
  bin_file="$root_path/bin/$1"

  cat << EOF > $bin_file
  #!/usr/bin/env sh
set -e
cd $root_path/src
exec bin/production_exec bin/cli.rb $2 "\$@"
EOF

  chmod 500 $bin_file
}
set -x
mkdir $root_path/bin
# TODO v1.0
# rename bin/cli to bin/mecli
# add thewhole /me/bin to PATH
GenerateBinRunner mecli
GenerateBinRunner mecli_start start_task
GenerateBinRunner mecli_list list_tasks
set +x

echo "... installing dependencies"
cd $root_path
bundle config set without development test
bundle install

echo "DONE"
