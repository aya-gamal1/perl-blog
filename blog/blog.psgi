use strict;
use warnings;

use blog;

my $app = blog->apply_default_middlewares(blog->psgi_app);
$app;

