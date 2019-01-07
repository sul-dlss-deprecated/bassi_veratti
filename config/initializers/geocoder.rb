if Rails.env.test?
  Geocoder.configure(lookup: :test)

  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        'coordinates'  => [37.4248398, -122.1677058],
        'address'      => 'Stanford',
        'state'        => 'California',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
else
  Geocoder.configure(timeout: 10)
end
