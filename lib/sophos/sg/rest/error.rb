# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf

class Sophos::SG::REST::Error < StandardError
  attr_reader :request, :response, :body

  def initialize(request, response, body)
    @request = request
    @response = response
    @body = body

    message = response.message
    message << ": #{errors.first.name}" if errors.any?
    reqdesc = "#{request.method} #{request.path} -> #{response.code}"

    super "UTM: #{message} (#{reqdesc})"
  end

  def errors
    body.is_a?(Array) ? body : []
  end
end
