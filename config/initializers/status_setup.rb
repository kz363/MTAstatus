require 'nokogiri'
require 'open-uri'

# Each key in the hash will be one of the 5 services from the MTA
# The values are an HTML string of a table to append to the page
service_statuses = Hash.new('<table class="service_table">')

xml = Nokogiri::XML(open('serviceStatus.txt')) do |config| 
				config.noblanks 
			end

timestamp = xml.xpath('//timestamp').text
status_header = "<h4>Service Status</h4><h6>as of #{timestamp}</h6>"

xml.xpath('//line').each do |node| 
	service = node.parent.name.to_sym
	line_name = node.children[0].text
	line_status = node.children[1].text
	service_statuses[service] += "<tr><td>#{line_name}</td><td>#{line_status}</td></tr>" 
end

Rails.cache.write('statuses', service_statuses)