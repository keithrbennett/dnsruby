
require_relative 'spec_helper'
require 'diffy'

class TestIssue110 < Minitest::Test

  DOMAIN = 'xyz.com'
  ATTACKER_DOMAIN = 'bad.com'

  def test_both_update_creation_styles
    update1 = Dnsruby::Update.new(DOMAIN)
    update1.add(DOMAIN, Dnsruby::Types::MX, 86400, 10, ATTACKER_DOMAIN)

    update2 = Dnsruby::Update.new(DOMAIN)
    mx = Dnsruby::RR.create("#{DOMAIN} 86400 IN MX 10 #{ATTACKER_DOMAIN}")
    update2.add(mx)

    s1 = update1.to_s, s2 = update2.to_s
    puts Diffy::Diff.new(update1.to_s, update2.to_s)

    assert_equal update1, update2  # fails
  end
end

=begin
Diff Output:

 ;; Security Level : UNCHECKED
-;; id = 11722
+;; id = 615
 ;; qr = false    opcode = Update    rcode = NOERROR
 ;; zocount = 1  prcount = 0  upcount = 1  adcount = 0

 ;; ZONE SECTION (1  record)
 ;; xyz.com.	IN	SOA

 ;; UPDATE SECTION (1  record)
-xyz.com	86400	IN	ANY	15 10
+xyz.com	86400	IN	MX	10 bad.com

=end
