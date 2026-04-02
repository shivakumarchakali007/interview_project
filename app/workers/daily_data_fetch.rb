class DailyDataFetch

  include Sidekiq::Worker
  sidekiq_options queue: 'newqueue'

  def perform(page=1, limit=100)
    
    listing_data = ListingImporter.fetch_data(page, limit)
    Rails.logger.info "---Fetching the listing---"

    listing_data.each do |listing|
      record = Listing.create_or_find_by!(listing_number: listing["listing_number"]) do |r|
        r.title          = listing["public_title"]
        r.description    = listing["summary"]
        r.listing_price  = listing["listing_price"]
        r.status         = listing["listing_status"]
      end

      if record.hubspot_deal_id.nil? && record.status == "For Sale"
        # create HubSpot deal here
        deal_id = HubspotService.create_deal(record)

        if deal_id
          record.update!(hubspot_deal_id: deal_id.to_s)
        end
      end
    end

    if listing_data.count == limit
      sleep(1)
      DailyDataFetch.perform_async(page + 1, limit)
    end
    
  end

end
