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

echo "TODO copy rails master key"
echo "TODO add database (either from backup or create new one)"
echo "TODO install bash command alias for /me/src/bin/cli.rb"
