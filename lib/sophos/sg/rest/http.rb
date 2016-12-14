# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf

class Sophos::SG::REST::HTTP < Net::HTTP
  attr_reader :url

  def initialize(url, options = {})
    @url = URI(url)
    super(@url.host, @url.port)
    if @url.scheme == 'https'
      self.use_ssl = true
      self.verify_mode = OpenSSL::SSL::VERIFY_PEER
      self.verify_callback = lambda do |preverify_ok, ssl_context|
        if options[:fingerprint]
          # check if the fingerprint is matching (don't respect the chain)
          fingerprint = options[:fingerprint].gsub(/\s|:/, '').downcase
          ssl_context.chain.each do |cert|
            if fingerprint == OpenSSL::Digest::SHA1.new(cert.to_der).to_s
              return true
            end
          end
          false
        else
          # if the certificate is valid and no fingerprint is passed the
          # certificate chain result is determining
          preverify_ok
        end
      end
    end
  end
end
