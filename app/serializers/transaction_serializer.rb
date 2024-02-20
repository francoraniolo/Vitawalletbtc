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
    object.sent_currency == 'usd' ? object.sent_amount.round(2) : object.sent_amount.round(8)
  end

  def received_amount
    object.received_currency == 'usd' ? object.received_amount.round(2) : object.received_amount.round(8)
  end
end
