use strict;
use warnings;
use Test::More;


use Catalyst::Test 'blog';
use blog::Controller::users;

ok( request('/users')->is_success, 'Request should succeed' );
done_testing();
