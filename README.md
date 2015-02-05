vagrant centos7 dev box
=======================

- run `bundle install` to get all necessary gems
- install `bundle exec librarian-puppet install` or updated `bundle exec librarian-puppet update`
- run `vagrant up`
- add the `10.0.0.10 app` entry at your hosts file
- verify the installation through http://app/info.php
- access elasticsearch on http://10.0.0.10:9200