source 'https://rubygems.org'

#ruby '1.9.3' # fails 1: cucumber features/student_feedback.feature:10 # Scenario: correctly reports grace period
#ruby '2.0.0' # fails 2:  Failing Scenarios:
#   cucumber features/student_feedback.feature:10 # Scenario: correctly reports grace period
#   cucumber features/student_feedback.feature:14 # Scenario: correctly reports late period

ruby '2.0.0'

gem 'rspec', '~> 2.14.1'
#gem 'cucumber', '<= 1.3.15' # >= 1.3.16 was possible syntax change: "describe missing"
gem 'cucumber', '1.3.10'
gem 'metric_fu'
gem 'mechanize'
gem 'octokit'
gem 'term-ansicolor'
gem 'xqueue_ruby', :git => 'https://github.com/zhangaaron/xqueue-ruby'
gem 'activerecord'

group :development, :testing do
  gem 'ZenTest'
#  gem 'debugger'
  gem 'byebug'
  gem 'simplecov'
  gem 'fakeweb'
  gem 'simplecov-rcov'
  gem 'addressable'
end
