require 'jekyll-seo-tag'

module Jekyll
  class SeoTag
    class JSONLDDrop < Jekyll::Drops::Drop

      alias_method :author_without_my, :author
      private :author_without_my

      def author
        s = author_without_my

        return unless s

        same_as = page_drop.author['url']
        s['url'] = same_as if same_as

        s
      end
    end
  end
end
