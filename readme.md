# Vagrant Sandbox

A repo for developing core Vagrant.

## Usage

Make sure you have cloned [Vagrant](https://github.com/hashicorp/vagrant) into
the same parent directory as where you clone this repo so that it looks like:

```
brian@localghost:code % ls -lah
drwxr-xr-x  33 brian  staff   1.0K Aug  8 15:08 congenial-octo-palm-tree
drwxr-xr-x  33 brian  staff   1.0K Aug  8 15:08 vagrant
```

If your Vagrant source dir is else where, make sure to update the path in this
projects `Gemfile`.

__Note__: Comment out the plugin block in the `Gemfile` if you are not developing
the vmware plugin from source.

```
rvm use @vagrant --create
bundle install
bundle exec vagrant <commands>
```
