require 'jekyll-inline-svg'

module Jekyll
  module Tags
    class JekyllInlineSvg
      alias_method :render_without_div, :render

      def render(*args, **kwargs)
        s = render_without_div(*args, **kwargs)

        "<div class=\"inline-svg-container\">#{s}</div>"
      end
    end
  end
end
