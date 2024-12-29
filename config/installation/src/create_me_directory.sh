set -e
root_path=/me

if [ -d "$root_path" ]; then
  echo "the directory $root_path already exists"
  exit 0
fi

echo "... creating directory $root_path"
set -x
sudo mkdir "$root_path"
sudo install -d -o "$USER" -g "$USER" -m 700 "$root_path"
set +x

echo "... pulling source code"
set -x
mkdir "$root_path"/src
git clone git@github.com:doooby/me-ruby.git src
set +x

echo "TODO add database (either from backup or create new one)"
