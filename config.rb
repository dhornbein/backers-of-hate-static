activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :sprockets

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

helpers do
  def get_fields(org, field)
    org.to_hash.select { |k,v| k.to_s.include? field }.count
  end
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  set :http_prefix, '/backers-of-hate-static'
end

def other_locale(locale)
  ["en", "es"].reject{ |ele| ele == locale.to_s }.first
end

activate :dato

activate :i18n, langs: dato.available_locales, mount_at_root: false
activate :directory_indexes
set :lang, :en

dato.tap do |dato|
  dato.available_locales.each do |locale|
    I18n.with_locale(locale) do
      other_lang = other_locale(locale)
    	proxy(
    		"#{locale}/index.html",
    		"/templates/index.html",
    		locals: { other_locale_url: "/#{other_lang}/index.html", locale: locale },
    		locale: locale
    	)

      dato.organizations.each do |org|
        proxy(
          "/#{locale}/#{org.url_title}.html",
          "/templates/card.html",
          locals: { locale: locale, other_locale_url: "/#{other_lang}/#{org.url_title}.html", organization: org },
          locale: locale
        )
      end
    end
  end
end

ignore "templates/index.html.erb"
ignore "templates/card.html.erb"

redirect "index.html", to: "en/"