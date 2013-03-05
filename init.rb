Redmine::Plugin.register :auto_gollum_wikis do
  name 'Auto Gollum Wikis plugin'
  author 'David Rios'
  description 'A plugin to load Gollum wikis from project git repositories.'
  version '0.0.1'
  url 'https://github.com/davidrios/redmine_auto_gollum_wikis'
  author_url 'https://github.com/davidrios'

  requires_redmine :version_or_higher => '2.2.0'
end
