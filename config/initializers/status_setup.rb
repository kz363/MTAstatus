require 'nokogiri'
require 'open-uri'

def omglol
	puts "*" * 500
end

# Add font color to status
def color_status(status)
	td = "<td style='cursor: pointer; color: #"

	case status[0..1]
	when "Go"
		td += "060'>"
	when "Sa"
		td += "5d0dff' class='service'>"
	when "Pl", "Se"
		td += "996600' class='service'>"
	when "De"
		td += "990033' class='service'>"
	end

	td + status + "</td>"
end

def update_cache
	uri = open('http://web.mta.info/status/serviceStatus.txt')
	xml = Nokogiri::XML(uri) do |config| 
					config.noblanks 
				end

	timestamp = xml.xpath('//timestamp').text
	status_header = "<h4>Status as of #{timestamp}</h4>"

	# Each key in the hash will be one of the 5 services from the MTA
	# The values are an HTML string of a table to append to the page
	service_statuses = Hash.new("<div class='service_table'>#{status_header}<table>")

	# Stores information about reroutes for each line
	reroutes = Hash.new("")

	# Append line information as a row in the table
	xml.xpath('//line').each do |node| 
		service = node.parent.name.to_sym
		line_name = "<td>#{node.children[0].text}</td>"
		line_status = node.children[1].text.downcase.split(' ').map(&:capitalize).join(' ')
		colored_status = color_status(line_status)
		reroutes[node.children[0].text.to_sym] += node.children[2].text
		service_statuses[service] += "<tr>#{line_name}#{colored_status}</tr>"
	end

	# Close HTML tags and append Service name
	service_statuses.each do |k,v|
		service_statuses[k] = v + "</table></div>"
		service = k[0].capitalize + k[1..-1]
		service_statuses[k] = v.gsub("<h4>", "<h4>#{service} ")
	end

	Rails.cache.write('statuses', service_statuses)
	Rails.cache.write('reroutes', reroutes)
end