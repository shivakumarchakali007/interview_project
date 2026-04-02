class HubspotService

  def self.create_deal(listing)

    client = Hubspot::Client.new(access_token: ENV["HUBSPOT_TOKEN"])
    
    # HubSpot timestamp is in milliseconds
    close_date = (Time.now + 30.days).to_i * 1000

    properties = {
      "dealname" => "listing_#{listing.listing_number}",
      "amount" => listing.listing_price.to_s,
      "closedate" => close_date.to_s,
      "description" => listing.description
    }

    begin
      api_response = client.crm.deals.basic_api.create(body: { properties: properties })
      api_response.id
    rescue Hubspot::Crm::Deals::ApiError => e
      Rails.logger.error "HubSpot Deal Creation Error: #{e.message}"
      nil
    end

  end

end