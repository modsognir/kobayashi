module Kobayashi
  class Page < Kobayashi::Post
    class << self

      # Returns all pages
      def all
        pages ||= page_files.map { |pf| new(pf) }
      end

      # Find pages in the pages directory
      def find(args)
        page = page_files.select {|pf| File.basename(pf) =~ /#{args}/i }.map {|pf| new(pf)}
        page = page.first
      end

      # Grab all the page files
      def page_files
        @page_files ||= (Dir.glob (Pathname.pwd.join("pages", "*.md"))).sort
      end

    end

  end
end