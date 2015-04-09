kind = TemplateKind.find_or_create_by_name('Bootdisk')

ConfigTemplate.without_auditing do
  content = File.read(File.join(ForemanBootdisk::Engine.root, 'app', 'views', 'foreman_bootdisk', 'host.erb'))
  tmpl = ConfigTemplate.find_or_create_by_name(
    :name => 'Boot disk iPXE - host',
    :template_kind_id => kind.id,
    :snippet => false,
    :template => content
  )
  tmpl.attributes = {
    :template => content,
    :default  => true,
    :vendor   => "Foreman boot disk",
    :locked   => true
  }
  tmpl.save!(:validate => false) if tmpl.changes.present?

  content = File.read(File.join(ForemanBootdisk::Engine.root, 'app', 'views', 'foreman_bootdisk', 'generic_host.erb'))
  tmpl = ConfigTemplate.find_or_create_by_name(
    :name => 'Boot disk iPXE - generic host',
    :template_kind_id => kind.id,
    :snippet => false,
    :template => content
  )
  tmpl.attributes = {
    :template => content,
    :default  => true,
    :vendor   => "Foreman boot disk",
    :locked   => true
  }
  tmpl.save!(:validate => false) if tmpl.changes.present?

  content = File.read(File.join(ForemanBootdisk::Engine.root, 'app', 'views', 'foreman_bootdisk', 'hostgroup.erb'))
  tmpl = ConfigTemplate.find_or_create_by_name(
    :name => 'Boot disk iPXE - hostgroup',
    :template_kind_id => kind.id,
    :snippet => false,
    :template => content
  )
  tmpl.attributes = {
    :template => content,
    :default  => true,
    :vendor   => "Foreman boot disk",
    :locked   => true
  }
  tmpl.save!(:validate => false) if tmpl.changes.present?
end
