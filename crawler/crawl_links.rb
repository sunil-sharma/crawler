require 'rubygems'
require 'boilerpipe_article'
require 'net/http'
require 'uri'
require 'feedjira'
require 'pry'
require 'yaml'
require 'fileutils'
require_relative 'link_extractor'

module Crwaler
  class CrawlLinks

    def get_data(url, index)
      dir_name = URI.parse(url).hostname.gsub(".", "_")
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

    def crawl_me(path)
      links = YAML.load_file("./#{path}")
      file_names = Dir["./data/www_sitepoint_com/*"]
      alread_crawled =  file_names.map { |f| f.to_s.gsub("./data/www_sitepoint_com/", "").gsub(".yml", "").to_i }
      links.reject!{ |k| k < alread_crawled.max }
      links.each do |key, url|
        get_data(url, key)
      end
    end
  end

  path = "feed_links/www_sitepoint_com.yml"
  # extractor = Crwaler::LinkExtractor.new
  # links = extractor.get_links_from_site_point
  # extractor.read_or_write_links(path, links)
  
  crawler = CrawlLinks.new
  crawler.crawl_me(path)
end