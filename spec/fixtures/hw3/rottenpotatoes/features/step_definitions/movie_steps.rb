Given /the following movies exist/ do |movies_table|
  #Movie.delete_all
  Movie.create!(movies_table.hashes)
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body.index(e1) < page.body.index(e2)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.delete(' ').split(',')
  if uncheck == 'un'
    ratings.each{ |rating| page.uncheck('ratings_'+rating) }
  elsif uncheck == nil
    ratings.each{ |rating| page.check('ratings_'+rating) }
  end
end

Then /I should see all the movies/ do
  assert_equal page.all('tbody tr').count, Movie.count
end
