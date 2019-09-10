module Twitch
  struct Transaction
    JSON.mapping(
      id: String,
      timestamp: String, # TODO: Time
      broadcaster_id: {type: Int32, converter: IDConverter},
      broadcaster_name: String,
      user_id: {type: Int32, converter: IDConverter},
      user_name: String,
      product_type: String, # TODO: Enum
      product_data: Product
    )
  end

  struct Product
    JSON.mapping(
      domain: String,
      broadcast: Bool,
      expiration: String,
      sku: String,
      cost: Cost,
      displayName: String,
      inDevelopment: Bool
    )
  end

  struct Cost
    JSON.mapping(
      amount: Int32,
      type: String # TODO: Enum
    )
  end
end
