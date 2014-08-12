require 'nokogiri'
require 'open-uri'

xml = Nokogiri::XML(open('serviceStatus.txt')) do |config| 
				config.noblanks 
			end

timestamp = xml.xpath('//timestamp').text
status_header = "<h4>Service Status as of #{timestamp}</h4>"

# Each key in the hash will be one of the 5 services from the MTA
# The values are an HTML string of a table to append to the page
service_statuses = Hash.new("<div class='service_table'>#{status_header}<table>")

# Append line information as a row in the table
xml.xpath('//line').each do |node| 
	service = node.parent.name.downcase.to_sym
	line_name = node.children[0].text
	line_status = node.children[1].text
	service_statuses[service] += "<tr><td>#{line_name}</td><td>#{line_status}</td></tr>" 
end

# Close HTML tags
service_statuses.each do |k,v|
	service_statuses[k] = v + "</table></div>"
end

Rails.cache.write('statuses', service_statuses)