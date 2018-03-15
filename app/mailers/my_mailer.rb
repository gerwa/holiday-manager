class MyMailer < ApplicationMailer
  default from: "GHM <gertraud.wachmann@gmail.com>"
 
  def testmail(mailaddr)
  	mail(:to => mailaddr, :subject => 'testmail')
  end
  
end
