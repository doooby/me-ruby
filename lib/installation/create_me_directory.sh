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
set -x
mkdir $root_path/bin
cat << EOF > $root_path/bin/cli
#!/usr/bin/env sh
cd $root_path && exec bin/production_exec bin/cli.rb "$@"
EOF
chmod u+x $root_path/bin/cli
set +x

echo "... installing dependencies"
cd $root_path
bundle config set without development test
bundle install

echo "DONE"
