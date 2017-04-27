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

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-98155490-1'
end

activate :dato
activate :i18n, langs: dato.available_locales, mount_at_root: false
activate :directory_indexes
set :lang, :en

def other_locale(locale)
  ["en", "es"].reject{ |ele| ele == locale.to_s }.first
end

def org_list
  ["jpmorgan", "wellsfargo", "goldman-sachs", "boeing", "disney", "ibm", "blackrock", "uber", "blackstone"]
end

def whos_next(org)
  i = org_list.index(org)
  list = []
  case i
  when 0..6
    list += org_list[i+1..i+2]
  when 7
    list += ["blackstone", "jpmorgan"]
  when 8
    list += ["jpmorgan", "wellsfargo"]
  end
  list
end

dato.tap do |dato|
  dato.available_locales.each do |locale|
    I18n.with_locale(locale) do
      other_lang = other_locale(locale)
    	proxy(
    		"#{locale}/index.html",
    		"/templates/index.html",
    		locals: { 
          other_locale: other_lang,
          other_locale_url: "/#{other_lang}/index.html",
          locale: locale
        },
    		locale: locale
    	)

      dato.organizations.each do |org|
        proxy(
          "/#{locale}/#{org.url_title}.html",
          "/templates/card.html",
          locals: {
            locale: locale,
            other_locale: other_lang,
            other_locale_url: "/#{other_lang}/#{org.url_title}.html",
            organization: org,
            whos_next: whos_next(org.url_title) 
          },
          locale: locale
        )
      end
    end
  end
end

ignore "templates/index.html.erb"
ignore "templates/card.html.erb"
redirect "index.html", to: "en/"
