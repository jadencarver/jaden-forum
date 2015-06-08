require_relative 'jaden-forum'

use Rack::MethodOverride
run JadenForum::Server
