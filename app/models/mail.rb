class Mail
  attr_accessor :recipient, :content
  
  def valid?
    true
  end
  
  def errors
    []
  end
  
  def new_record?
    true
  end
end