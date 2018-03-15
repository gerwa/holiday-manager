class MyMailer < ApplicationMailer
  default from: "GHM <no-reply@holiday-manager.ch>"
 
  def testmail(mailaddr)
  	mail(:to => mailaddr, :subject => 'testmail')
  end
  
end
