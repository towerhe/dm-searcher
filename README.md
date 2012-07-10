# DataMapper::Searcher

DataMapper plugin providing for searching models with nested conditions.

## Installation

Add this line to your application's Gemfile:

    gem 'dm-searcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dm-searcher

## Usage

```ruby
 # Models
 class User
   include DataMapper::Resource
   include DataMapper::Searcher

   property :id, Serial
   property :name, String

   has n, :roles
 end

 class Role
   include DataMapper::Resource
   include DataMapper::Searcher

   property :id, Serial
   property :name, String

   belongs_to :user
 end

 # Search for records
 User.search('name.like' => '%Tower%')
 # => Returns the users whose name contains 'Tower'.

 User.search('id.gt' => 10)
 # => Returns the users whose id is greater than 10.

 User.search('roles.name' => 'Administrators')
 # => Returns the users whose role is 'Administrator'.

 User.search('name.like' => '%Tower%',
             'id.gt' => 10,
             'roles.name' => 'Administrators') 
 # => Returns the users whose name contains 'Tower', id is greater than 10 and role is 'Administrators'.

 # Combining the result
 User.search('name.like' => '%Tower%') + User.search('id.gt' => 10)
 User.search('name.like' => '%Tower%') | User.search('id.gt' => 10)
 # => Returns the users whose name contains 'Tower' or id is greater than 10.

 User.search('name.like' => '%Tower%') & User.search('id.gt' => 10)
 User.search('name.like' => '%Tower%') - User.search('id.gt' => 10)
 # => Returns the users whose name contains 'Tower' and id is greater than 10.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
