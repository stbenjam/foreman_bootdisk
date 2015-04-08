module ForemanBootdisk::UnattendedControllerExt
  extend ActiveSupport::Concern
  include ::Foreman::Renderer

  included do
    alias_method_chain :find_host_by_ip_or_mac, :param_mac
    skip_filter :get_host_details, :allowed_to_install?, :only => :hostgroup
    before_filter :find_host_properties, :only => :hostgroup
  end

  def find_host_by_ip_or_mac_with_param_mac
    request.env['HTTP_X_RHN_PROVISIONING_MAC_0'] = "unknown #{params['mac']}" unless request.env.has_key?('HTTP_X_RHN_PROVISIONING_MAC_0') || params['mac'].nil?
    find_host_by_ip_or_mac_without_param_mac
  end

  def hostgroup
    tmpl = if params[:token]
             @host = Host::Managed.new(:name            => params[:name],
                                       :mac             => params[:mac],
                                       :hostgroup       => @hostgroup,
                                       :organization    => @organization,
                                       :location        => @location,
                                       :managed         => true,
                                       :build           => true)
              @host.save
              "#!ipxe\nchain #{bootdisk_chain_url}#{params[:mac]}"
            else
              ForemanBootdisk::Renderer.new.hostgroup_template_render
            end
    render :text => tmpl
  end

  private

  def bootdisk_chain_url(action = 'iPXE')
    u = URI.parse(foreman_url(action))
    u.query = "#{u.query}&mac="
    u.fragment = nil
    u.to_s
  end

  def find_host_properties
    return unless params[:token]
    # validate token
    @hostgroup = ::Hostgroup.find(params[:hostgroup])
    @organization = ::Organization.find(params[:organization])
    @location = ::Location.find(params[:location])
    error _('Unable to find properties') unless @hostgroup and @organization and @location
  end
end
