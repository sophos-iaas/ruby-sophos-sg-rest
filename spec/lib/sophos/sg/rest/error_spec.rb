# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf

describe Sophos::SG::REST::Error do
  let(:request) { Struct.new(:path, :method).new('/some/path', 'GET') }
  let(:response) { Struct.new(:message, :code).new('Forbidden', '401') }
  let(:body) { [Struct.new(:name).new('error-41')] }

  it 'should format errors' do
    error = described_class.new(request, response, body)

    expect(error.message).to \
      eql("UTM: Forbidden: error-41 (GET /some/path -> 401)")
    expect(error.errors).to eql(body)
  end
end
