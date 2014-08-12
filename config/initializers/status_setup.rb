require 'nokogiri'
require 'open-uri'

def omglol
	puts "*" * 500
end

# Add font color to status
def color_status(status)
	td = "<td style='color: #"

	case status[0..1]
	when "Go"
		td += "060'>"
	when "Sa"
		td += "5d0dff'>"
	when "Pl", "Se"
		td += "996600'>"
	when "De"
		td += "990033'>"
	end

	td + status + "</td>"
end

def update_cache
	uri = open('http://web.mta.info/status/serviceStatus.txt')
	xml = Nokogiri::XML(uri) do |config| 
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
		line_name = "<td>#{node.children[0].text}</td>"
		line_status = node.children[1].text.downcase.split(' ').map(&:capitalize).join(' ')
		colored_status = color_status(line_status)
		service_statuses[service] += "<tr>#{line_name}#{colored_status}</tr>"
	end

	# Close HTML tags
	service_statuses.each do |k,v|
		service_statuses[k] = v + "</table></div>"
	end

	Rails.cache.write('statuses', service_statuses)
end