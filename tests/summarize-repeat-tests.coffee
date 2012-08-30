summarize = require '../contents/js/views/lib/summarize-repeat'
assert = require 'assert'

assert summarize, 'should exist'

# ## weekly

assert.equal summarize('weekly', [0]), 'every Sunday'
assert.equal summarize('weekly', [0,6]), 'every Saturday and Sunday'
assert.equal summarize('weekly', [0,3,6]), 'every Wednesday, Saturday, and Sunday'
assert.equal summarize('weekly', [0,1,2,3,4,5,6]), 'every day'
assert.equal summarize('weekly', [1,2,3,4,5]), 'every weekday'
# assert.equal summarize('weekly', [1,2,4,5]), 'every weekday except wenesday'
# assert.equal summarize('weekly', [0,1,2,4,5,6]), 'every day except wenesday'
assert.equal summarize('weekly', []), 'never'


# ## biweekly

assert.equal summarize('biweekly', [0]), 'every other Sunday'

# ## monthly onDate

date = new Date(2012, 7, 29)
assert.equal summarize('monthly', null, date, true), 'on the 29th of every month'

date = new Date(2012, 7, 1)
assert.equal summarize('monthly', null, date, true), 'on the 1st of every month'

date = new Date(2012, 7, 22)
assert.equal summarize('monthly', null, date, true), 'on the 22nd of every month'

date = new Date(2012, 7, 3)
assert.equal summarize('monthly', null, date, true), 'on the 3rd of every month'

# ## monthly (not onDate)

date = new Date(2012, 8, 5)
assert.equal summarize('monthly', null, date), 'on the first Wednesday of every month'

date = new Date(2012, 8, 8)
assert.equal summarize('monthly', null, date), 'on the second Saturday of every month'

date = new Date(2012, 8, 24)
assert.equal summarize('monthly', null, date), 'on the last Monday of every month'
