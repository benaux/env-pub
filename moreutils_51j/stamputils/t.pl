use Digest::SHA 'sha1';
use Convert::Base32::Crockford;
 
my $foo = 888;
my $digest = sha1($foo);
my $base32 = encode_base32($digest);

print $base32;
 
