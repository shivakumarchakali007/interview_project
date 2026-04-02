class ListingImporter

  def self.fetch_data(page=1, limit=100)

    conn = Faraday.new(url: "https://api.empireflippers.com/api/v1/listings/list") do |f|
      f.request :url_encoded
      f.response :json
      f.options.timeout = 10
      f.options.open_timeout = 10
      f.adapter Faraday.default_adapter
    end

    response = conn.get("", { page: page, limit: limit})

    data = response.body

    data["data"]["listings"] || []

    
  end

end