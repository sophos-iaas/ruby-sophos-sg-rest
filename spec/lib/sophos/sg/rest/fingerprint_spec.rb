# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf

describe Sophos::SG::REST::HTTP do
  let(:url) { 'https://www.sophos.com' }

  context 'with fingerprint' do
    let(:figerprint) do
    end

    it 'should not be valid if fingerprint invalid' do
      fp = 'F3:D3:C6:C2:01:93:4A:BC:87:C4:07:8D:10:5A:59:F3:B0:B0:3C:XX'
      http = described_class.new(url, fingerprint: fp)
      expect do
        http.request(Net::HTTP::Get.new('/en-us.aspx'))
      end.to raise_error(OpenSSL::SSL::SSLError)
    end

    it 'should be valid if fingerprint valid' do
      fp = '35:98:A3:F0:28:0E:79:6A:31:D2:84:71:F5:88:4F:3F:F0:DA:2E:F6'
      http = described_class.new(url, fingerprint: fp)
      expect do
        http.request(Net::HTTP::Get.new('/en-us.aspx'))
      end.to_not raise_error
    end
  end

  context 'without fingerprint' do
    it 'should be possible to disable verification' do
      http = described_class.new(url)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      expect do
        http.request(Net::HTTP::Get.new('/en-us.aspx'))
      end.to_not raise_error(OpenSSL::SSL::SSLError)
    end
  end
end