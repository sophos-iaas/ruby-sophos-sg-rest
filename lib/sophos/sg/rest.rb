# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf

require 'net/http'
require 'json'
require 'ostruct'
require 'openssl'

require "sophos/sg/rest/version"

module Sophos
  module SG
    module REST
      autoload :HTTP, "sophos/sg/rest/http"
      autoload :Error, "sophos/sg/rest/error"
      autoload :Client, "sophos/sg/rest/client"
    end
  end
end
