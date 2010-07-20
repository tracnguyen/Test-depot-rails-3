#!/bin/bash
source ~/.rvm/scripts/rvm
rvm 1.8.7
exec bundle exec rake jobs:work
