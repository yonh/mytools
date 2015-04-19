# Set application dependencies
require File.expand_path("../app", __FILE__)

set :port, 80
set :bind, '0.0.0.0'
enable :sessions

App.run!
