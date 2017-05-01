
require_relative 'spec_helper'
require 'diffy'  # NOTE!!! You'll need to gem install diffy for this file to work!

class TestIssue110 < Minitest::Test

  DOMAIN = 'xyz.com'
  ATTACKER_DOMAIN = 'bad.com'

  def update_from_string
    update = Dnsruby::Update.new(DOMAIN)
    mx = Dnsruby::RR.create("#{DOMAIN} 86400 IN MX 10 #{ATTACKER_DOMAIN}")
    update.add(mx)
    update
  end


  def update_from_args(*args)
    update = Dnsruby::Update.new(args.first)
    update.add(*args)
    update
  end


  def do_test(test_num, update1)
    update2 = update_from_string
    puts "\n#{'-' * 60} Test #{test_num}"
    puts Diffy::Diff.new(update1.to_s, update2.to_s)
    assert_equal update1, update2  # fails
  end


  def test_1
    do_test(1,update_from_args(DOMAIN, Dnsruby::Types::MX, 86400, 10, ATTACKER_DOMAIN))
  end


  def test_2
    do_test( 2,update_from_args(DOMAIN, Dnsruby::Types::MX, 86400, ATTACKER_DOMAIN))
  end


  def test_3
    do_test( 3,update_from_args(DOMAIN, 'MX', 86400, ATTACKER_DOMAIN))
  end
end

=begin
Output:

Run options: --seed 45021

# Running:


------------------------------------------------------------ Test 1
 ;; Security Level : UNCHECKED
-;; id = 58403
+;; id = 46042
 ;; qr = false    opcode = Update    rcode = NOERROR
 ;; zocount = 1  prcount = 0  upcount = 1  adcount = 0

 ;; ZONE SECTION (1  record)
 ;; xyz.com.	IN	SOA

 ;; UPDATE SECTION (1  record)
-xyz.com	86400	IN	ANY	15 10
+xyz.com	86400	IN	MX	10 bad.com

TestIssue110 | FR
------------------------------------------------------------ Test 2
 ;; Security Level : UNCHECKED
-;; id = 9520
+;; id = 18475
 ;; qr = false    opcode = Update    rcode = NOERROR
 ;; zocount = 1  prcount = 0  upcount = 1  adcount = 0

 ;; ZONE SECTION (1  record)
 ;; xyz.com.	IN	SOA

 ;; UPDATE SECTION (1  record)
-xyz.com	86400	IN	ANY	15 bad.com
+xyz.com	86400	IN	MX	10 bad.com
F
             | 0.02 s
Slowest tests:
0.03 s	TestIssue110#test_1
0.02 s	TestIssue110#test_2
0.00 s	TestIssue110#test_3
Slowest suites:
0.05 s	TestIssue110


Finished in 0.053457s, 56.1199 runs/s, 37.4132 assertions/s.

  1) Failure:
TestIssue110#test_1 [test/tc_issue_110.rb:29]:
--- expected
+++ actual
@@ -1 +1 @@
-#<Dnsruby::Update:0xXXXXXX @header=#<Dnsruby::Header:0xXXXXXX @id=58403, @qr=false, @opcode=Update, @aa=false, @ad=false, @tc=false, @rd=0, @ra=false, @cd=false, @rcode=NOERROR, @qdcount=1, @nscount=1, @ancount=0, @arcount=0>, @question=[#<Dnsruby::Question:0xXXXXXX @qtype=SOA, @qclass=IN, @qname=#<Dnsruby::Name: xyz.com.>>], @answer=[], @authority=[#<Dnsruby::RR::IN::ANY:0xXXXXXX @rdata="15 10", @name=#<Dnsruby::Name: xyz.com>, @ttl=86400, @type=ANY, @klass=IN>], @additional=[], @tsigstate=:Unsigned, @signing=false, @tsigkey=nil, @answerfrom=nil, @answerip=nil, @send_raw=false, @do_validation=false, @do_caching=true, @security_level=UNCHECKED, @security_error=nil, @cached=false>
+#<Dnsruby::Update:0xXXXXXX @header=#<Dnsruby::Header:0xXXXXXX @id=46042, @qr=false, @opcode=Update, @aa=false, @ad=false, @tc=false, @rd=0, @ra=false, @cd=false, @rcode=NOERROR, @qdcount=1, @nscount=1, @ancount=0, @arcount=0>, @question=[#<Dnsruby::Question:0xXXXXXX @qtype=SOA, @qclass=IN, @qname=#<Dnsruby::Name: xyz.com.>>], @answer=[], @authority=[#<Dnsruby::RR::IN::MX:0xXXXXXX @rdata="10 bad.com", @preference=10, @exchange=#<Dnsruby::Name: bad.com>, @name=#<Dnsruby::Name: xyz.com>, @ttl=86400, @type=MX, @klass=IN>], @additional=[], @tsigstate=:Unsigned, @signing=false, @tsigkey=nil, @answerfrom=nil, @answerip=nil, @send_raw=false, @do_validation=false, @do_caching=true, @security_level=UNCHECKED, @security_error=nil, @cached=false>



  2) Error:
TestIssue110#test_3:
Dnsruby::DecodeError: MX record expects preference and domain
    /Users/kbennett/work/dnsruby/lib/dnsruby/resource/MX.rb:42:in `from_string'
    /Users/kbennett/work/dnsruby/lib/dnsruby/resource/RR.rb:113:in `initialize'
    /Users/kbennett/work/dnsruby/lib/dnsruby/resource/RR.rb:282:in `new'
    /Users/kbennett/work/dnsruby/lib/dnsruby/resource/RR.rb:282:in `_get_subclass'
    /Users/kbennett/work/dnsruby/lib/dnsruby/resource/RR.rb:245:in `new_from_string'
    /Users/kbennett/work/dnsruby/lib/dnsruby/resource/RR.rb:402:in `create'
    /Users/kbennett/work/dnsruby/lib/dnsruby/update.rb:238:in `add'
    test/tc_issue_110.rb:20:in `update_from_args'
    test/tc_issue_110.rb:44:in `test_3'


  3) Failure:
TestIssue110#test_2 [test/tc_issue_110.rb:29]:
--- expected
+++ actual
@@ -1 +1 @@
-#<Dnsruby::Update:0xXXXXXX @header=#<Dnsruby::Header:0xXXXXXX @id=9520, @qr=false, @opcode=Update, @aa=false, @ad=false, @tc=false, @rd=0, @ra=false, @cd=false, @rcode=NOERROR, @qdcount=1, @nscount=1, @ancount=0, @arcount=0>, @question=[#<Dnsruby::Question:0xXXXXXX @qtype=SOA, @qclass=IN, @qname=#<Dnsruby::Name: xyz.com.>>], @answer=[], @authority=[#<Dnsruby::RR::IN::ANY:0xXXXXXX @rdata="15 bad.com", @name=#<Dnsruby::Name: xyz.com>, @ttl=86400, @type=ANY, @klass=IN>], @additional=[], @tsigstate=:Unsigned, @signing=false, @tsigkey=nil, @answerfrom=nil, @answerip=nil, @send_raw=false, @do_validation=false, @do_caching=true, @security_level=UNCHECKED, @security_error=nil, @cached=false>
+#<Dnsruby::Update:0xXXXXXX @header=#<Dnsruby::Header:0xXXXXXX @id=18475, @qr=false, @opcode=Update, @aa=false, @ad=false, @tc=false, @rd=0, @ra=false, @cd=false, @rcode=NOERROR, @qdcount=1, @nscount=1, @ancount=0, @arcount=0>, @question=[#<Dnsruby::Question:0xXXXXXX @qtype=SOA, @qclass=IN, @qname=#<Dnsruby::Name: xyz.com.>>], @answer=[], @authority=[#<Dnsruby::RR::IN::MX:0xXXXXXX @rdata="10 bad.com", @preference=10, @exchange=#<Dnsruby::Name: bad.com>, @name=#<Dnsruby::Name: xyz.com>, @ttl=86400, @type=MX, @klass=IN>], @additional=[], @tsigstate=:Unsigned, @signing=false, @tsigkey=nil, @answerfrom=nil, @answerip=nil, @send_raw=false, @do_validation=false, @do_caching=true, @security_level=UNCHECKED, @security_error=nil, @cached=false>


3 runs, 2 assertions, 2 failures, 1 errors, 0 skips

=end
