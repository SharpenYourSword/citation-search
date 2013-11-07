require "json"
require "pp"
require "rubygems"
require "bundler/setup"
require "indextank"

filenames = Dir["../data/citations/**/*.json"]

citations = filenames.map do |filename|
  contents = File.read(filename)

  JSON.parse(contents)
end.flatten!

#grouped_by_title = citations.group_by do |citation|
#  citation['usc']['title']
#end

grouped_by_section = citations.group_by do |citation|
  citation['usc']['section_id']
end

#grouped_by_subsection = citations.group_by do |citation|
#  citation['usc']['id']
#end

require_relative("../config.rb")

config = Configuration.keys

api = IndexTank::Client.new config["indexden_url"]
 
index = api.indexes "citations"

documents = []
grouped_by_section.each_pair do |citation_path, citations|
  citations.each do |citation|
    # schema for docid: citation_index/citation_section_id/case_id
    docid = citation["index"].to_s + "/" + citation["usc"]["section_id"] + "/" + citation["case_id"]
    documents << { 
      docid: docid,
      fields: {
        case_name: citation["case_name"],
        case_year: citation["case_year"],
        match: citation["match"],
        excerpt: citation["excerpt"],
        title: citation["usc"]["title"],
        section: citation["usc"]["section"],
        courtlistener_url: "http://courtlistener.com/#{citation['courtlistener_path']}"
      }
    }
  end
end

documents.each_slice(20) do |documents_slice|
  response = index.batch_insert(documents_slice)
  puts response
end

#response = index.batch_insert(documents)
