require 'uri'

module ForemanBootdisk
  class Renderer
    include ::Foreman::Renderer
    include ::Foreman::Controller::ConfigTemplates
    include Rails.application.routes.url_helpers

    def generic_template_render
      tmpl = ConfigTemplate.find_by_name(Setting[:bootdisk_generic_host_template]) || raise(::Foreman::Exception.new(N_('Unable to find template specified by %s setting'), 'bootdisk_generic_host_template'))
      @profiles = ConfigTemplate.pxe_default_combos
      @host = Struct.new(:token, :subnet).new(nil, nil)
      unattended_render(tmpl.template)
    end

    def hostgroup_template_render
      tmpl = ConfigTemplate.find_by_name(Setting[:bootdisk_hostgroup_template]) || raise(::Foreman::Exception.new(N_('Unable to find template specified by %s setting'), 'bootdisk_hostgroup_template'))
      @hostgroups = ::Hostgroup.all
      @host = Struct.new(:token, :subnet).new(nil, nil)
      unattended_render(tmpl.template)
    end

    def bootdisk_chain_url(action = 'iPXE')
      u = URI.parse(foreman_url(action))
      u.query = "#{u.query}&mac="
      u.fragment = nil
      u.to_s
    end
  end
end
