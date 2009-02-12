# -*- coding: utf-8 -*-
class Notifications < ActionMailer::Base
  def new_books(books)
    setup

    if books.size == 1
      subject "[Books] Ny bog: #{books.first.name}"
    else
      subject "[Books] Nye bøger: #{books.collect{ |b| b.name }.join(', ')}"
    end
    body[:books] = books
    recipients  'alle@lenio.dk'
  end

  protected
  def setup
    from      'noreply@lenio.dk'
    sent_on   Time.now
  end
end
