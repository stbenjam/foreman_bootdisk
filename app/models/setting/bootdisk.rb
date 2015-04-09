class Setting::Bootdisk< ::Setting
  def self.load_defaults
    return unless ActiveRecord::Base.connection.table_exists?('settings')
    return unless super

    ipxe = ['/usr/lib/ipxe'].find { |p| File.exist?(p) } || '/usr/share/ipxe'
    syslinux = ['/usr/lib/syslinux'].find { |p| File.exist?(p) } || '/usr/share/syslinux'

    Setting.transaction do
      [
        self.set('bootdisk_ipxe_dir', N_('Path to directory containing iPXE images'), ipxe),
        self.set('bootdisk_syslinux_dir', N_('Path to directory containing syslinux images'), syslinux),
        self.set('bootdisk_host_template', N_('iPXE template to use for host-specific boot disks'), 'Boot disk iPXE - host'),
        self.set('bootdisk_generic_host_template', N_('iPXE template to use for generic host boot disks'), 'Boot disk iPXE - generic host'),
        self.set('bootdisk_hostgroup_template', N_('iPXE template to use for host group menu'), 'Boot disk iPXE - hostgroup'),
        self.set('bootdisk_mkiso_command', N_('Command to generate ISO image, use genisoimage or mkisofs'), 'genisoimage'),
        self.set('bootdisk_cache_media', N_('Installation media files will be cached for full host images'), true),
      ].compact.each { |s| self.create s.update(:category => "Setting::Bootdisk") }
    end

    true

  end
end
