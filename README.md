# gitlab-tricks
Some gitlab tricks for devops and sysadmins



## 1- Remove artifacts that have not been tagged

This script is useful when you need to free up storage.

### Install

```
git clone https://github.com/supermpm/gitlab-tricks
pip3 install python-gitlab
pip3 install simplejson
```

Edit file remove_artifacts.py and set variables token and host with your data.

### Use

```
python remove_artifacts.py proj_id task
```

Posible tasks:

* L: for listing artifacts that have not been tagged
* D: for deleting artifacts that have not been tagged

### Examples

```
$ python3 remove_artifats.py 10 L
```

```
$ python3 remove_artifats.py 10 D
```
