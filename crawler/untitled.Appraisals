require 'rubygems'
require 'boilerpipe_article'
require 'net/http'
require 'uri'
require 'feedjira'
require 'yaml'
require 'fileutils'
require_relative 'link_extractor'
module Crwaler
  class CrawlLinks

    def get_data(url, index, dir_name)
      # dir_name = URI.parse(url).hostname.gsub(".", "_")
      Dir.mkdir("data/#{dir_name}") unless File.exists?("data/#{dir_name}")

      file = File.open("data/#{dir_name}/#{index}.yml", "w")
      uri = URI(url)
      html = Net::HTTP.get(uri)

      parser =  BoilerpipeArticle.new(html)
      metas = parser.getMetas
      allText  = parser.getAllText
      data = {
        title: metas["og:title"],
        short_description: metas["description"],
        type: metas["og:type"],
        description: allText
      }
      file.write data.to_yaml
    end

    def crawl_me(file_name)
      puts "crawling started: #{file_name}"

      links = YAML.load_file("./feed_links/www_sitepoint_com.yml")
      puts "#{links}"
      if(links)
        links.inspect.each do |key, url|
          puts "crawling for: #{url}"
          get_data(url, key, file_name)
        end
      end
    end
  end

  url = "https://www.sitepoint.com/javascript/feed/"
  file_name = Crwaler::LinkExtractor.new.get_links(url)
  crawler = Crwaler::CrawlLinks.new
  crawler.crawl_me(file_name)
end