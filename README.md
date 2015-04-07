# Gon-sinatra gem — get your Sinatra variables in your js

### [![Build Status](https://secure.travis-ci.org/gazay/gon-sinatra.png)](http://travis-ci.org/gazay/gon-sinatra)

If you need to send some data to your js files and you don't want to do this with long way through views and parsing - use this force!

Now with [Rabl](https://github.com/nesquena/rabl) support!

Now with [Padrino](https://github.com/padrino/padrino-framework) support as well!

For rails use [gon](https://github.com/gazay/gon).

<a href="https://evilmartians.com/?utm_source=gon-sinatra">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54">
</a>

## Usage

`my_sinatra_application.rb`

**Note: For classic (non-modular) applications, you still have to explicitely register `Gon::Sinatra`**

``` ruby
# For classic applications:

Sinatra::register Gon::Sinatra
# and if you want to the use Rabl integration
Sinatra::register Gon::Sinatra::Rabl

# For modular applications:

class MySinatraApplication < Sinatra::Base #or Padrino::Application
  register Gon::Sinatra
  register Gon::Sinatra::Rabl
end
```

`views/application.erb`

``` erb
<head>
  <title>some title</title>
  <%= include_gon %>
  <!-- include your action js code -->
  ...
```

To camelize your variables in js you can use:

``` erb
<head>
  <title>some title</title>
  <%= include_gon(:camel_case => true) %>
  <!-- include your action js code with camelized variables -->
  ...
```

You can change the namespace of the variables:

``` erb
<head>
  <title>some title</title>
  <%= include_gon(:namespace => 'serverExports') %>
  <!-- include your action js code with 'serverExports' namespace -->
  ...
```

You put something like this in the Sinatra action:

``` ruby
@your_int = 123
@your_array = [1,2]
@your_hash = {'a' => 1, 'b' => 2}
gon.your_int = @your_int
gon.your_other_int = 345 + gon.your_int
gon.your_array = @your_array
gon.your_array << gon.your_int
gon.your_hash = @your_hash

gon.all_variables # > {:your_int => 123, :your_other_int => 468, :your_array => [1, 2, 123], :your_hash => {'a' => 1, 'b' => 2}}
gon.your_array # > [1, 2, 123]

gon.clear # gon.all_variables now is {}
```

Access the varaibles from your JavaScript file:

``` js
alert(gon.your_int)
alert(gon.your_other_int)
alert(gon.your_array)
alert(gon.your_hash)
```

With camelize:

``` js
alert(gon.yourInt)
alert(gon.yourOtherInt)
alert(gon.yourArray)
alert(gon.yourHash)
```

With custom namespace and camelize:

``` js
alert(customNamespace.yourInt)
alert(customNamespace.yourOtherInt)
alert(customNamespace.yourArray)
alert(customNamespace.yourHash)
```

## Usage with Rabl

Now you can write your variables assign logic to templates with [Rabl](https://github.com/nesquena/rabl).
The way of writing Rabl templates is very clearly described in their repo.

Profit of using Rabl with gon:

  1. You can clean your controllers now!
  2. Work with database objects and collections clearly and easyly
  3. All power of Rabl
  4. You can still be lazy and don't use common way to transfer data in js
  5. And so on

For using gon with Rabl you need to create new Rabl template and map gon
to it.
For example you have model Post with attributes :title and :body.
You want to get all your posts in your js as an Array.
That's what you need to do:

  1. Create Rabl template. I prefer creating special directory for
     templates which are not view templates.

    `goners/posts/index.rabl`

    ``` rabl
    collection @posts => 'posts'
    attributes :id, :title, :body
    ```

  2. All you need to do after that is only to map this template to gon.

    ``` ruby
    get '/' do
      # some logic
      @posts = [some_objects] # Rabl works with instance variables of controller

      gon.rabl 'goners/posts/index.rabl', :instance => self
      # some logic
    end
    ```

    Thats it! Now you will get in your js gon.posts variable which is Array of
    post objects with attributes :id, :title and :body.

In javascript file for view of this action write call to your variable:

``` js
alert(gon.posts)
alert(gon.posts[0])
alert(gon.posts[0].post.body)
```

P.s. If you didn't put include_gon tag in your html head area - it
wouldn't work. You can read about this in common usage above.

### Some tips of usage Rabl with gon:

If you don't use alias in Rabl template:

``` rabl
collection @posts
....
```

instead of using that:

``` rabl
collection @posts => 'alias'
....
```

Rabl will return you an array and gon by default will put it to variable
gon.rabl

Two ways how you can change it - using aliases or you can add alias to
gon mapping method:

``` ruby
# your logic stuff here

gon.rabl 'path/to/rabl/file', :as => 'alias', :instance => self
```

## Installation

Manually install gon-sinatra gem: `$ gem install gon-sinatra`

Add requirement to your app file

``` ruby
require 'gon-sinatra'
```

## Contributors

* @gazay
* @skade

Special thanks to @brainopia, @kossnocorp and @ai.
