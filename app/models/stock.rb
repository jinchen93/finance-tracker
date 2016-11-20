class Stock < ActiveRecord::Base

  # Find stock that has already been looked up and stored
  def Stock.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  # Lookup new stock and store in database
  def Stock.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless looked_up_stock.name

    new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.name)
    new_stock.last_price = new_stock.price
    new_stock
  end

  # Find price of a certain stock
  def price
    closing_price = StockQuote::Stock.quote(ticker).close
    return "#{closing_price} (Closing)" if closing_price

    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (Opening)" if opening_price

    return "Unavailable"
  end

end
