class Notifications < ActionMailer::Base
  def new_book(book)
    setup
    subject     "[Books] Ny bog: #{book.name}"
    body[:book] = book
    recipients  'alle@lenio.dk'
  end

  protected
  def setup
    from      'noreply@lenio.dk'
    sent_on   Time.now
  end
end
