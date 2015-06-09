# on successful build, build -ci repos which use rag
#BUILD_NUM=$(curl -s 'https://api.travis-ci.com/repos/apelade/rails-intro-ci/builds' | grep -o '^\[{"id":[0-9]*,' | grep -o '[0-9]' | tr -d '\n')
travis restart -r apelade/rails-intro-ci --pro


