# Hash Selector Pattern

Its generally common that our web application needs to take different routes based on certain conditions. There are a few ways we can express these conditions in Ruby. Ifs and Case / Switch come to mind. They're one of the most common ways to express logical paths in our application.

Case / Switch can offer very nice syntax and clear code however if / else are much faster than case / switches. At the same time complex if else can make your code very complicated and difficult to read.

Lets take a look at a simple example.

Remember our flash partials? What if we wanted the color to change based on the type of error. Using ifs we can write it like this.

```ruby
  if flash[:type] == :success
    'alert-success'
  elsif flash[:type] == :error
    'alert-danger'
  elsif flash[:type] == :warn
    'alert-warning'
  elsif flash[:type] == :info
    'alert-info'
  end
```

> Note that these outputs are based on bootstrap alert classes that output different colors based on the class names.

Lets take a look at the case / switch solution. Its much cleaner but its also a lot slower than the if based solution.

```ruby
  case flash[:type]
  when :success then 'alert-success'
  when :error   then 'alert-danger'
  when :warn    then 'alert-warning'
  when :info    then 'alert-info'
  end
```

Let me introduce you to the hash selector pattern

```ruby
  { success: 'alert-success',
    error:   'alert-danger',
    notice:  'alert-info',
    warn:    'alert-warning' }[flash[:type]]
```

We're using hash to store the result for the different routes of our application, and simply selecting the result based on the selector. 

In this case the selector is the `flash[:type]`. We have a very simple example here of the hash selector pattern. Our code more readable and concise.

## Procs and Lambdas

Great so we can output simple text using hashes nothing special. What about calling methods, can we do that? Well absolutely! Let me demonstrate.

In your controller you may be fimiliar with this sort of logic

```ruby
  if @comment.save
    respond_with @post, @comment
  else
    xms_error @comment
  end
```

Generally when you have a simple logic like this I recommend with the if / else solution as its small enough to be clean and readable. However if you have a more complex logic with multiple elsifs you might want to do something like this 

```ruby
  { true  => -> { self.respond_with @post, @comment },
    false => -> { self.xms_error @comment } 
  }[@comment.save].call
```

The code above does the exact same thing as the if / else solution. However it is much shorter. In this case I wouldn't say that hash / selector has improved our code but here I am just trying to show you that it is possible to call methods using hashes. You just have to wrap it inside of a proc.

## Conclusion

The hash selector pattern separates the logic from the result, generally this will make your code easier to read. It gives the right balance between readable code and performance. In most cases Hash / Selector pattern will be faster than if / else, but if your `selector` is very complex it might become slower.

My general rule of thumb is if you are using a lot of `elsif` in your codebase chances are you can probably refactor it using hash / selector pattern.

Here is my Fizzbuzz solution using Hash / Selector

## Further Examples

```ruby
class Fizzbuzz
  def initialize(number)
    @number = number
  end
 
  def self.count(number)
    count = new(number)
    count.output_data[count.selector]
  end
 
  def self.count_if(number)
    count = new(number)
    count.output_if
  end
 
  def output_if
    result = 'Fizz' if @number % 3 == 0
    result = 'Buzz' if @number % 5 == 0         
    result = 'Fizzbuzz' if @number % 15 == 0
    result 
  end
 
  def output_data
    { "3" => "Fizz", 
      "5" => "Buzz",
      "15" => "Fizzbuzz" }
  end
 
  def selector
    output_data.keys.map { |k| k.to_i }.select do |k| 
      @number % k == 0 
    end.last
  end
end
```

