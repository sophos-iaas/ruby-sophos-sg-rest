# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf

class Sophos::SG::REST::Client
  HEADER_USER_AGENT = "#{self} (#{Sophos::SG::REST::VERSION})".freeze
  HEADER_ACCEPT = 'application/json'.freeze
  HEADER_CONTENT_TYPE = 'Content-Type'.freeze
  HEADER_ERR_ACK = 'X-Restd-Err-Ack'.freeze
  HEADER_SESSION = 'X-Restd-Session'.freeze
  HEADER_INSERT = 'X-Restd-Insert'.freeze
  HEADER_LOCK_OVERRIDE = 'X-Restd-Lock-Override'.freeze
  DEFAULT_HEADERS = {
    'Accept' => HEADER_ACCEPT,
    'User-Agent' => HEADER_USER_AGENT
  }.freeze
  attr_reader :http, :url

  def initialize(url, options = {})
    @http = Sophos::SG::REST::HTTP.new(url, options)
  end

  def logger=(logger)
    @http.set_debug_output(logger)
  end

  def objects(type)
    get path_objects(type)
  end

  def object(type, ref)
    get path_object(type, ref)
  end

  def create_object(type, attributes, insert = nil)
    post path_objects(type), attributes, insert
  end

  def patch_object(type, ref, attributes)
    patch path_object(type, ref), attributes
  end

  def update_object(type, attributes, insert = nil)
    h = attributes.to_h
    ref = h['_ref'] || h[:_ref]
    raise ArgumentError, "Object _ref must be set! #{h.inspect}" if ref.nil?
    put path_object(type, ref), h, insert
  end

  def destroy_object(type, ref = nil)
    # if ref is not passed, assume object or hash
    if ref.nil?
      if type.is_a? Hash
        ref = type['_ref'] || type[:_ref]
        type = type['_type'] || type[:_type]
      elsif type.respond_to?(:_type) && type.respond_to?(:_ref)
        ref = type._ref
        type = type._type
      else
        raise ArgumentError, 'type must be a string, hash or object with ' \
          ' _ref and _type defined'
      end
    end

    delete path_object(type, ref)
  end

  def nodes
    get nodes_path
  end

  def update_nodes(hash)
    patch nodes_path, hash
  end

  def node(id)
    get nodes_path(id)
  end

  def update_node(id, value)
    put nodes_path(id), value
  end

  def nodes_path(id = nil)
    base = File.join(@http.url.path, 'nodes') + '/'
    base = File.join(base, id) if id
    base
  end

  def path_object(type, ref)
    File.join(@http.url.path, 'objects', type, ref)
  end

  def path_objects(type)
    File.join(@http.url.path, 'objects', type) + '/'
  end

  def get(path)
    do_json_request('GET', path)
  end

  def post(path, data, insert = nil)
    do_json_request('POST', path, data) do |req|
      req[HEADER_CONTENT_TYPE] = HEADER_ACCEPT
      req[HEADER_INSERT] = insert if insert
    end
  end

  def put(path, data, insert = nil)
    do_json_request('PUT', path, data) do |req|
      req[HEADER_CONTENT_TYPE] = HEADER_ACCEPT
      req[HEADER_INSERT] = insert if insert
    end
  end

  def patch(path, data)
    do_json_request('PATCH', path, data) do |req|
      req[HEADER_CONTENT_TYPE] = HEADER_ACCEPT
    end
  end

  def delete(path)
    do_json_request('DELETE', path) do |req|
      req[HEADER_ERR_ACK] = 'all'
    end
  end

  def do_json_request(method, path, body = nil)
    body = json_encode(body) unless body.nil?
    req = request(method, path, body)
    yield req if block_given?
    response = @http.request(req)
    decode_json(response, req)
  end

  def request(method, path, body = nil)
    req = Net::HTTPGenericRequest.new(method, !body.nil?, true, path, DEFAULT_HEADERS)
    req.basic_auth @http.url.user, @http.url.password
    req.body = body
    req
  end

  def json_encode(data)
    data.to_json
  end

  def decode_json(response, req)
    body = nil

    if response.body && response.body != ''
      # rubys JSON parse is unable to parse scalar values (number, string,
      # bool, ...) directly, because of this it needs to be wrapped before
      body = JSON.parse('[' + response.body + ']').first
      if body.is_a?(Array) && body.any? && body.first.is_a?(Hash)
        body = body.map { |i| OpenStruct.new(i) }
      elsif body.is_a? Hash
        body = OpenStruct.new(body)
      else
        body
      end
    end

    if response.code.to_i >= 400
      raise Sophos::SG::REST::Error.new(req, response, body)
    end

    body
  end
end
