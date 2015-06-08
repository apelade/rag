# Checkout the ruby API like this https://gist.github.com/rkh/4531148#file-gistfile1-rb
BUILD_NUM=$(curl -s 'https://api.travis-ci.org/repos/apelade/rails-intro-ci/builds' | grep -o '^\[{"id":[0-9]*,' | grep -o '[0-9]' | tr -d '\n')
