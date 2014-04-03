# Rails Flash Partials

Outputting flash messages is one of the most convenient ways of letting your users know when things happen in the system. Things like when users update their content or create new content.

With rails generally its pretty simple to output flash messages. You just do 

![Cover Picture](assets/cover.png)

```ruby
flash[:notice] = "Your post has been updated!"
```

And Voila! you can output flash messages in your views. However what if you want to output flash messages that are more than just simple text. What if you want to put links in there or use your view helpers in them? How would you go about handling all that? 

Well lets take a look!

## Skeleton Partial

The best way to use views helper is well in the view. So lets start by creating a simple partial. We create this in the `views/application/_flash.html.erb`. If you don't see an `application` folder in your views simply create it.

```erb
<div class='alert alert-info'>
  <div class='cotainer'>
    ... flash content goes here ...
  </div>
</div>
```

This simple partial will serve as the skeleton for our flash message. It will provide the basic structure. If your using twitter bootstrap the alert box will look something like the above. However you can just as easily come up with your own concoction.


## Flash Helper

Once we have our partial we need some helper code to help us use the flash partial. This code goes into a helper file called `flash_helper.rb`

```ruby
module FlashHelper
  def render_flash
    render 'flash' if can_flash?
  end

  def can_flash?
    flash.keys.sort == [:from, :object_id, :object_type, :type]
  end

  def flash_object
    flash[:object_type].classify.constantize.where(id: flash[:object_id]).first
  end

  def flash_path
    File.join(controller_name, 'flash', flash[:from].to_s, flash[:type].to_s)
  end
end
```

The render_flash is called in our `layouts/application.html.erb` like so.

```html
...
<body>
<%= render 'navigation' %>
<%= render_flash %>
<div class='container'>
  <%= yield %>
</div>

</body>
...
```

The `render_flash` checks with `can_flash?` whether or not it can display the flash message. 

In our `can_flash?` message all we're doing is making sure that the flash has that is passed to the view has the right keys. Basically for our flash to work right we need those keys. I'll explain abit later where all these are coming from.

When we work with flash it means we could also be working with redirection. Which means that the action thats rendering the actual flash message may have different objects in them. For example think of this scenario. We're creating a new post and after the post is created we redirect to the posts index. Well in the `posts#index` action we may not have the original `@post` object. So we need the `flash_object` to ensure that the object that the flash message depends on is available to the flash.

Lastly the `flash_path` just generates the partial path for the flash. We will explain later how and where we use this helper method.

## Controller Madness!

We need to do a few things in the controlle to get our partials working right. Lets have a look at whats going on with our `application_controller.rb`

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_flash(type, object: nil)
    flash[:from] = action_name
    flash[:type] = type
    flash[:object_type] = object.class.name
    flash[:object_id]   = object.id
  end
end
```

We just have a `set_flash` method that simply builds our flash hash which we will then use in our `flash_helper.rb`

Now all we need to do is call `set_flash` in our controller action as required.

```ruby
def update
  @post = get_post
  if @post.update_attributes(post_params)
    set_flash :success, object: @post
    redirect_to posts_path
  else
    set_flash :error, object: @post
    render :edit
  end
end

def create
  @post = Post.new(post_params)
  if @post.save
    set_flash :success, object: @post
    redirect_to posts_path
  else
    set_flash :error, object: @post
    render :new
  end
end
```

You'll see that we have a case where the flash is being used to handle success messages and error messages. We're going to get back to the views and see how we'll render out these flash messages.

## Into the Views

Once we've set everything up all we have to do now is render our flash messages through the partials in our views. However we need to use the path we defined in the FlashHelper called `flash_path` basically this is where its going to look for the flash message. You can change this and structure your flash messages however you like however in this case we're going to put it in the views that correspond to the controller.

We're going to create a few files 

```bash
views/posts/flash/create/_success.html
views/posts/flash/create/_error.html
views/posts/flash/update/_success.html
views/posts/flash/update/_error.html
```

Here are some example content of what you can do with these flash partials. Here is what my `create/_success.html.erb` looks like.

```
<h4>Congratulations!</h4>
Your post has been successfully created! <%= link_to object.title, object %>
```

Here is `update/_success.html.erb`
```
Your post has been successfully saved! <%= link_to "edit: #{object.title}", edit_post_path(object) %>
```


Basically this file structure is what we have setup in our `flash_path` method. So your free to use whatever kind of structure you like by modifying the `flash_path` method.

```ruby
  # def set_flash(type, object: nil)
    # flash[:from] = action_name
    # flash[:type] = type
    # flash[:object_type] = object.class.name
    # flash[:object_id]   = object.id
  # end

  def flash_path
    File.join(controller_name, 'flash', flash[:from].to_s, flash[:type].to_s)
  end
```

## Conclusion

You may be wondering why go through all that trouble. Well if your working with a large scale rails app. Having some sort of structure to help keep your flash messages clean and versatile might be something worth investing time into getting right. There are many solutions out there and they all work in their own way. Depending on what sort of app your building this could be a great solution for you!