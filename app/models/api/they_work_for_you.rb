class Api::TheyWorkForYou < Api

  stateaware_api 'TheyWorkForYou provides information on MPs', :data_group_name => 'MP Data', :methods => {
    :get_data_for_postcode => { :arguments => [:postcode], :description => 'Find an MP for a location' }
  }

  def get_data_for_postcode(postcode)
    # access they work for you and get an MP's data
    data_point = data_points.find_by_address postcode

    if data_point
      # TODO: This could refetch data every so often to update it
      data_point
    else
      client = Twfy::Client.new(Settings['apis']['theyworkforyou']['key'])
      mp = client.mp(:postcode => postcode)
      # if data was found, store it as a DataPoint entry
      if mp
        map_result_to_data_point postcode, client.mp_info(:id => mp.person_id)
      end
    end
  rescue Twfy::Client::APIError => exception
    errors.add_to_base exception.to_s
  end

  def map_result_to_data_point(postcode, result)
    return if result.nil?
    data_points.create :link => result.mp_website,
      :name => result.name,
      :address => postcode,
      :api => self,
      :entity_type => 'Person',
      :additional_links => { 'Wikipedia' => result.wikipedia_url },
      :data_summary => { 'Debates spoken in over the last year' => result.debate_sectionsspoken_inlastyear },
      :original_data => result
  end
end
