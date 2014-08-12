class PagesController < ApplicationController
	def index
	end

	def status
		service = params[:service].to_sym
		service_table = Rails.cache.read('statuses')[service]
		render json: service_table.to_json
	end

	def reroute
		line = params[:line].to_sym
		reroute_modal = Rails.cache.read('reroutes')[line]
		render json: reroute_modal.to_json
	end
end
