activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :sprockets

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false


# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do
  def get_fields(org, field)
    org.to_hash.select { |k,v| k.to_s.include? field }.count
  end
end

def slugify(title)
	title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :minify_css
  activate :minify_javascript
  set :http_prefix, '/backers-of-hate-static'
end

activate :dato

activate :i18n, langs: dato.available_locales, mount_at_root: false
activate :directory_indexes
set :lang, :en

dato.tap do |dato|
  dato.available_locales.each do |locale|

    I18n.with_locale(locale) do

    	proxy(
    		"#{locale}/index.html",
    		"/templates/index.html",
    		locals: { locale: locale },
    		locale: locale
    	)

      dato.organizations.each do |org|
        proxy(
          "/#{locale}/#{org.url_title}.html",
          "/templates/card.html",
          locals: { organization: org },
          locale: locale
        )
      end
    end
  end
end

ignore "templates/index.html.erb"
ignore "templates/card.html.erb"

redirect "index.html", to: "en/"