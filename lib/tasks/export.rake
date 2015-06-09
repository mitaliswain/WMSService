namespace :export do
  desc "Prints GlobalConfiguration .all in a seeds.rb way."
  task :seeds_format => :environment do
    GlobalConfiguration.order(:id).all.each do |country|
      puts "GlobalConfiguration.create(#{country.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end
end