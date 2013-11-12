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

usc_citations = citations.select do |citation|
  citation['type'] == 'usc'
end

usc_citations_grouped_by_section = usc_citations.group_by do |citation|
  citation['usc']['section_id']
end

cfr_citations = citations.select do |citation|
  citation['type'] == 'cfr'
end

cfr_citations_grouped_by_section = cfr_citations.group_by do |citation|
  citation['cfr']['section_id']
end

def documents_from_grouped_citations(grouped_citations)
  return [] if grouped_citations.keys.length == 0
  documents = []
  grouped_citations.each_pair do |citation_path, citations|
    citations.each do |citation|
      case citation["type"]
      when "usc"
        # schema for docid: citation_index/citation_section_id/case_id
        docid = citation["index"].to_s + "/" + citation["usc"]["section_id"] + "/" + citation["case_id"]
        documents << { 
          docid: docid,
          fields: {
            case_name: citation["case_name"],
            case_year: citation["case_year"],
            type: "usc",
            match: citation["match"],
            excerpt: citation["excerpt"],
            title: citation["usc"]["title"],
            section: citation["usc"]["section"],
            courtlistener_url: "http://courtlistener.com/#{citation['courtlistener_path']}"
          }
        }
      when "cfr"
        # schema for docid: citation_index/citation_section_id/case_id
        p "-------------"
        p citation["index"]
        p citation["cfr"]["section_id"]
        p citation["case_id"]
        docid = citation["index"].to_s + "/" + citation["cfr"]["section_id"] + "/" + citation["case_id"]
        documents << { 
          docid: docid,
          fields: {
            case_name: citation["case_name"],
            case_year: citation["case_year"],
            type: "cfr",
            match: citation["match"],
            excerpt: citation["excerpt"],
            title: citation["cfr"]["title"],
            section: citation["cfr"]["section"],
            courtlistener_url: "http://courtlistener.com/#{citation['courtlistener_path']}"
          }
        }
      end
    end
  end

  documents
end

def add_documents_to_index!(documents, index)
  documents.each_slice(20) do |documents_slice|
    response = index.batch_insert(documents_slice)
    puts response
  end
end

require_relative("../config.rb")

config = Configuration.keys

api = IndexTank::Client.new config["indexden_url"]
 
index = api.indexes "citations"

usc_documents = documents_from_grouped_citations(usc_citations_grouped_by_section)

pp usc_documents

add_documents_to_index!(usc_documents, index)
