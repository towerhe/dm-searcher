module DataMapper
  module Searcher
    extend ActiveSupport::Concern

    module ClassMethods
      # Valid symbol operators for the conditions are:
      #
      #  gt    # greater than
      #  lt    # less than
      #  gte   # greater than or equal
      #  lte   # less than or equal
      #  not   # not equal
      #  eql   # equal
      #  like  # like
      #
      # @example
      #
      #   # Models
      #   class User
      #     include DataMapper::Resource
      #     include DataMapper::Searcher
      #
      #     property :id, Serial
      #     property :name, String
      #
      #     has n, :roles
      #   end
      #
      #   class Role
      #     include DataMapper::Resource
      #     include DataMapper::Searcher
      #
      #     property :id, Serial
      #     property :name, String
      #
      #     belongs_to :user
      #   end
      #
      #   # Search for records
      #   User.search('name.like' => '%Tower%')
      #   # => Returns the users whose name contains 'Tower'.
      #
      #   User.search('id.gt' => 10)
      #   # => Returns the users whose id is greater than 10.
      #
      #   User.search('roles.name' => 'Administrators')
      #   # => Returns the users whose role is 'Administrator'.
      #
      #   User.search('name.like' => '%Tower%',
      #               'id.gt' => 10,
      #               'roles.name' => 'Administrators') 
      #   # => Returns the users whose name contains 'Tower', id is greater than 10 and role is 'Administrators'.
      #
      #   # Combining the result
      #   User.search('name.like' => '%Tower%') + User.search('id.gt' => 10)
      #   User.search('name.like' => '%Tower%') | User.search('id.gt' => 10)
      #   # => Returns the users whose name contains 'Tower' or id is greater than 10.
      #
      #   User.search('name.like' => '%Tower%') & User.search('id.gt' => 10)
      #   User.search('name.like' => '%Tower%') - User.search('id.gt' => 10)
      #   # => Returns the users whose name contains 'Tower' and id is greater than 10.
      #
      # @return [DataMapper::Collection] Matched records
      def search(opts = {})
        options = parse_opts(self, opts)

        self.all(options)
      end

      private

      def parse_opts(model, opts)
        options = {}

        opts.keys.each do |k|
          key = parse_key(model, k)

          options[key] = opts[k] if key && !opts[k].blank?
        end

        options
      end

      def parse_key(model, key)
        path, property, operator = model, nil, nil

        steps = key.to_s.split(/\./)
        steps.each do |s|
          s = s.to_sym

          if model.relationships.named?(s)
            path = path.send(s)
            model = path.model
          elsif model.properties.named?(s)
            property = path == model ? s : path.send(s)
          elsif (DataMapper::Query::Conditions::Comparison.slugs | [:not, :asc, :desc]).include?(s)
            operator = property.send(s)
          else
            raise "#{key} is not a valid property or operator."
          end
        end
        
        operator || property
      end
    end
  end
end
