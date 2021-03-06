# Get on Board API Ruby library

The Get on Board Ruby library provides a convenient access to the _Get on Board API_ from applications written in the Ruby language.

It abstracts the developer from having to deal with API requests by mapping the list of core resources like _Company_, _Category_, _Tag_, _Job_ or _Application_ to ruby classes and objects.

Key features:

- Easy to setup.
- Map core concepts in Get on Board to ruby classes.
- Allow access to relationships among these concepts like accessing all the jobs within a category, or what's the company behind a job.

## Documentation

Check the original API doc at: https://api-doc.getonbrd.com

## Installation

Add this line to your application's Gemfile:

```ruby
gem "getonbrd-ruby", github: "getonbrd/getonbrd-ruby"
```

then execute:

```sh
$ bundle install
```

## Usage

The API has two facets:

- Public: Provides access to the same data you can see in [Get on Board](https://www.getonbrd.com) without having to log in.
- Private: Provides access to the data of subscribed companies. All the requests made to this facet need to be authenticated.

### Public facet

Free access to _companies_, _categories_, _tags_ and _jobs_.

#### Models

The public facet allows anyone to download the data publicly accessible in [Get on Board](https://www.getonbrd.com) without having to login. The models are mapped vs the **Public** folder in the [API Reference](https://api-doc.getonbrd.com).

Note: Check the directory `lib/getonbrd/resources/public` for the complete list of resources.

Some examples:

```ruby
# paginate the list of categories
categories = Getonbrd::Public::Category.all(page: 2, per_page: 5)
# list their names
categories.map(&:name)

# retrieve the Programming category
programming = Getonbrd::Public::Category.retrieve("programming")
# retrieve the published jobs under programming
# notice that you can pass options the amount of jobs per page, the page
# and even expanding the response to bring the tags
jobs = programming.jobs(expand: ["tags"], per_page: 10, page: 2)
jobs.first.tags.map(&:name)
# select those looking for a remote position then list the modalities
jobs.select(&:remote?).map(&:remote_modality)

# Searching jobs using a free text
jobs = Getonbrd::Public::Search.jobs("remote backend ruby on rails")
```

### Private facet

Authenticated access to your company's data. an API key - that can be found in the settings page of your account in Get on Board - is needed.

#### Initialize the library with the API Key

Using your method of preference, initialize the library setting up the API Key. For instance, in case of a rails application, it can be by adding an initializer:

```ruby
# file: app/initializers/getonbrd.rb
require "getonbrd"

# it is a good idea to use an env not exposing the key
Getonbrd.api_key = ENV["GOB_API_KEY"]
```

#### Models

Those companies with access to the private facet of the API can use the models under `/lib/getonbrd/resources/private`. Follow some examples:

```ruby
# retrieve the list of jobs the company own
# by default page is 1 and per_page is 100 (the maximum possible)
jobs = Getonbrd::Private::Job.all(page: 2, per_page: 10)

# retrieve the list of hiring processes and their applications and professionals
processes = Getonbrd::Private::Job.all
processes.each do |process|
  apps = process.applications
  professionals = process.professionals
end
# it is possible to paginate thru applications and professionals directly too
apps = Getonbrd::Private::Application.all
# in the case of professionals, a process id is needed
professionals = Getonbrd::Private::Professional.all(process_id: <process-id>,
                                                    per_page: 50)

# create an application
app_attrs = {
  job_id: 1,
  email: "jon@snow.com",
  name: "Jon Snow",
  reason_to_apply: "They say I know nothing,...but that's not true...",
  ...
}
app = Getonbrd::Private::Application.create(app_attrs)
# update an application
app.update(description: "I do know a thing or two about Ruby and/or Rails.")
```

Note: Refer to the [API Reference](https://api-doc.getonbrd.com/) for the complete list of resources.

### Expanding the response

Some objects allow you to request additional information as an expanded response by using the `expand` parameter that is available on several of the endpoints, and applies to the response of that request only.

For instance a `job` has `tags`. If the response is not _expanded_, it will return only the `id` of the tags, however, if the response is _expanded_, it will return the list of tags with all their data Follo an example of a request expanding the response:

```ruby
job = Getonbrd::Private::Job.retrieve(job_id, expand: ["tags", "questions"])
# the tags and questions come expanded within the response
job.tags.map(&:name)
job.questions.each { |q| puts "#{q.required? ? "*" : ""} #{q.title}" }
```

## Development

Run the set up:

```sh
$ bundle
```

Run the specs:

```sh
$ bundle exec rspec
```

Run the linter:

```sh
$ bundle exec rubocop
```

## Contributing

1. Fork it.
1. Create your feature branch (git checkout -b my-new-feature).
1. Commit your changes (git commit -am 'Add some feature').
1. Push to the branch (git push origin my-new-feature).
1. Create a new Pull Request.

Bug reports and pull requests are welcome on GitHub at https://github.com/getonbrd/getonbrd-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/getonbrd/getonbrd-ruby/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Get on Board Ruby library project's codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/getonbrd/getonbrd-ruby/blob/master/CODE_OF_CONDUCT.md).
