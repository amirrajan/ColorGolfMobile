# -*- coding: utf-8 -*-

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

# This file is empty on purpose, you can edit it to add your own tasks.
# Use `rake -T' to see the list of all tasks.
# For iOS specific settings, refer to config/ios.rb.
# For OS X specific settings, refer to config/osx.rb.
# For Android specific settings, refer to config/android.rb.

task :ad => ['android:device']
task :acd => ['android:clean', 'android:device']
task :as => ['android:emulator']
task :acs => ['android:clean', 'android:emulator']

task :id => ['ios:device']
task :icd => ['ios:clean', 'ios:device']
task :is => ['ios:simulator']
task :ics => ['ios:clean', 'ios:simulator']
