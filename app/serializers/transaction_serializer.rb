class TransactionSerializer < ActiveModel::Serializer
  attributes :id,
             :operation_type,
             :sent_currency,
             :received_currency,
             :sent_amount,
             :received_amount,
             :unit_price,
             :user

  def user
    object.user.email
  end

  def sent_amount
    object.sent_currency == 'usd' ? format("%.2f", object.sent_amount) : format("%.8f", object.sent_amount)
  end

  def received_amount
    object.received_currency == 'usd' ? format("%.2f", object.received_amount) : format("%.8f", object.received_amount)
  end
end
