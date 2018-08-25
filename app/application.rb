class Application

  @@items = ["Apples","Carrots","Pears"]

  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      # create a new path called cart to show items in cart
      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      end # end if @@cart empty
    elsif req.path.match(/add/)
      # create new path called add that adds item to cart
      item_to_add = req.params["item"]
      if handle_search(item_to_add).include?("is one of our items")
        @@cart << item_to_add
        resp.write "added #{item_to_add}\n"
      else
        resp.write "We don't have that item"
      end # end if handle_search
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
