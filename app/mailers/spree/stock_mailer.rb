module Spree
  class StockMailer < ActionMailer::Base
    helper 'spree/base'

    def find_empty_products()
        Spree::Product.where(:count_on_hand => 0).order("name").select {|prod|
            prod.deleted_at.nil? }
    end

    def find_empty_variants()
        Spree::Variant.where(:count_on_hand => 0).order("sku").select {|var|
	    var.deleted_at.nil? and not var.is_master?
        }
    end

    def generate_estimate(var)
	shipped_week = Spree::InventoryUnit.find(:all, :conditions => {
			:state		=> 'shipped',
			:variant_id	=> var.id,
			:updated_at	=> @last_week.midnight..@today.end_of_day,
			}).size()
	shipped_month = Spree::InventoryUnit.find(:all, :conditions => {
			:state		=> 'shipped',
			:variant_id	=> var.id,
			:updated_at	=> @last_month.midnight..@today.end_of_day,
			}).size()
	shipped_year = Spree::InventoryUnit.find(:all, :conditions => {
			:state		=> 'shipped',
			:variant_id	=> var.id,
			:updated_at	=> @last_year.midnight..@today.end_of_day,
			}).size()

	# Normalize to units per day... with a shared secret about the range
	norm_week = shipped_week / 7.0
	norm_month = shipped_month / 30.0
	norm_year = shipped_year / 365.0

        # A weighted mean with magic numbers pulled out of thing air.
	mean = ((0.6 * norm_week) + (0.25 * norm_month) + (0.15 * norm_year)) / 1.0
        if var.sku.empty?
            name = "Prd " + var.product.sku
        else
            name = "Sku " + var.sku
        end
	days = var.count_on_hand / mean

        {'weighted_mean' => mean, 'days' => days, 'variant' => var,
            'product' => var.product, 'name' => name}
    end

    def generate_forecast()
        @today = Date.today
        @last_week = @today - 7
        @last_month = @today - 30
        @last_year = @today - 365

        forecast = []
        vars = Spree::Variant.where("deleted_at IS NULL").order("sku").select {|var|
            var.product.deleted_at.nil? and var.count_on_hand > 0 }

        vars.each {|var|
            forecast.push(generate_estimate(var))
        }

        forecast
    end

    def stock_report_email()
        @empty_products = find_empty_products()
        @empty_variants = find_empty_variants()
        @forecast = generate_forecast()
        mail(:to => 'webshop@sysmocom.de',
            :subject => 'Stock report of the week')
    end
  end
end
