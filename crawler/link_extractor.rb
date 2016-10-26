require 'rubygems'
require 'uri'
require 'feedjira'
require 'yaml'
require 'fileutils'
require 'json'
module Crwaler
  class LinkExtractor
    def read_or_write_links(path, entries)
      links = []
      file = File.open(path, "w")
      existing = YAML.load_file("./#{path}")
      entries.each_with_index do |entry, index|
        unless existing && existing.to_h.values.include?(entry)
          links << [index, entry]
        end
      end
      
      file.write links.to_h.to_yaml unless links.empty?
    end

    def get_links_from_site_point(category: "javascript", offset: 0, limit: 20, links: [])
      conn = Faraday.new("https://www.sitepoint.com/wp-admin/admin-ajax.php?action=sp_api_posts&offset=#{offset}&per_page=#{limit}&category=#{category}")
      resp = conn.get
      results_set = JSON.parse(resp.body)
      links << results_set.map{|r| r["link"]} unless results_set.empty?
      links = links.flatten!
      return links if results_set.length < limit
      new_offset = offset + limit
      get_links_from_site_point(category: category, offset: new_offset, limit: 1000, links: links)
    end
  end

  # path = "feed_links/www_sitepoint_com.yml"
  # extractor = LinkExtractor.new
  # links = extractor.get_links_from_site_point
  # extractor.read_or_write_links(path, links)
end