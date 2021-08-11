# require 'pry'

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
      end_date = req.params["ed"]

      # http://localhost:9292/search/?q=Carrots&ed=20211231

      puts req.path
      puts search_term
      puts end_date

      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.size == 0
        resp.write "Your cart is empty."
      else
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      end
    elsif req.path.match(/add/)
      item = req.params["item"]
      resp.write handle_pick(item)
    else
      resp.write "Path Not Found"
    end
    resp.finish
  end

  def handle_pick(item)
    if @@items.include?(item)
      @@cart << item
      return "added #{item} to the cart."
    else
      return "We don't have that item"
    end
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
