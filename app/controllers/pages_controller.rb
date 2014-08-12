class PagesController < ApplicationController
	def index
	end

	def status
		service = params[:service].to_sym
		service_table = Rails.cache.read('statuses')[service]
		render json: service_table.to_json
	end
end
