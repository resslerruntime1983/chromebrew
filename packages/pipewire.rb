require 'package'

class Pipewire < Package
  description 'PipeWire is a project that aims to greatly improve handling of audio and video under Linux.'
  homepage 'https://pipewire.org'
  version = if Gem::Version.new(CREW_KERNEL_VERSION.to_s) < Gem::Version.new('3.9')
            '0.3.29'
          elsif Gem::Version.new(CREW_KERNEL_VERSION.to_s) <= Gem::Version.new('5.4')
            '0.3.60'
          else
            '0.3.80'
          end
  compatibility 'all'
  license 'LGPL-2.1+'
  source_url 'https://gitlab.freedesktop.org/pipewire/pipewire.git'
  git_hashtag version

  if Gem::Version.new(CREW_KERNEL_VERSION.to_s) < Gem::Version.new('3.9')
    binary_url({
      i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/pipewire/0.3.29_i686/pipewire-0.3.29-chromeos-i686.tpxz'
    })
    binary_sha256({
      i686: '0dbeda58c4e1db7a180ebfb2b7bc3057cc6966927f4d5ee543953b734dfc4510'
    })
  elsif Gem::Version.new(CREW_KERNEL_VERSION.to_s) <= Gem::Version.new('5.4')
    binary_url({
      aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/pipewire/0.3.60_armv7l/pipewire-0.3.60-chromeos-armv7l.tar.zst',
       armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/pipewire/0.3.60_armv7l/pipewire-0.3.60-chromeos-armv7l.tar.zst',
       x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/pipewire/0.3.60_x86_64/pipewire-0.3.60-chromeos-x86_64.tar.zst'
    })
    binary_sha256({
      aarch64: '237ad8299b16e6d294a6561a4959efb47fc72ee66d06f51a3863f55dbdedcf78',
       armv7l: '237ad8299b16e6d294a6561a4959efb47fc72ee66d06f51a3863f55dbdedcf78',
       x86_64: '1534c6a7d71870ac60ec77aab0f795e148e63cf2eac61ff6ec58a5d3af23d994'
    })
  else
    binary_url({
      aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/pipewire/0.3.80_armv7l/pipewire-0.3.80-chromeos-armv7l.tar.zst',
       armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/pipewire/0.3.80_armv7l/pipewire-0.3.80-chromeos-armv7l.tar.zst',
       x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/pipewire/0.3.80_x86_64/pipewire-0.3.80-chromeos-x86_64.tar.zst'
    })
    binary_sha256({
      aarch64: '2d4b62539499d2bf0aa7456e9c96900de442b69eae365c76eb855b39e4cda5f3',
       armv7l: '2d4b62539499d2bf0aa7456e9c96900de442b69eae365c76eb855b39e4cda5f3',
       x86_64: 'a8dbd73b9706f5a90db5aeb9177aeb3a5f009357d61c4097ae290c6cee2467d1'
    })
  end

  depends_on 'alsa_lib' # R
  depends_on 'alsa_plugins' => :build
  depends_on 'avahi' # R
  depends_on 'ca_certificates' => :build
  depends_on 'dbus' # R
  depends_on 'eudev' # R
  depends_on 'gcc_lib' # R
  depends_on 'glibc' # R
  depends_on 'glib' # R
  depends_on 'gsettings_desktop_schemas' => :build
  depends_on 'gstreamer' # R
  depends_on 'jack' # R
  depends_on 'libsndfile' # R
  depends_on 'lilv' # R
  depends_on 'ncurses' # R
  depends_on 'openssl' # R
  depends_on 'pulseaudio' # R
  depends_on 'readline' # R
  depends_on 'vulkan_headers' => :build
  depends_on 'vulkan_icd_loader' # R
  depends_on 'webrtc_audio_processing' # R

  def self.prebuild
    # Without running the ca_certificates postinstall armv7l build breaks
    # complaining about the network not working.
    system "#{CREW_PREFIX}/bin/update-ca-certificates --fresh --certsconf #{CREW_PREFIX}/etc/ca-certificates.conf"
  end

  def self.build
    system "mold -run meson setup \
      #{CREW_MESON_OPTIONS} \
      -Dbluez5-backend-hsphfpd=disabled \
      -Dbluez5-backend-ofono=disabled \
      -Dbluez5=disabled \
      -Dexamples=disabled \
      -Dtest=disabled \
      -Dudevrulesdir=#{CREW_PREFIX}/etc/udev/rules.d \
      -Dv4l2=disabled \
      -Dvolume=auto \
      -Dvulkan=enabled \
      builddir"
    system 'meson configure builddir'
    system "#{CREW_NINJA} -C builddir"
  end

  def self.install
    system "DESTDIR=#{CREW_DEST_DIR} #{CREW_NINJA} -C builddir install"
    Dir.chdir("#{CREW_DEST_PREFIX}/include") do
      FileUtils.ln_sf 'spa-0.2/spa', 'spa'
      FileUtils.ln_sf 'pipewire-0.3/pipewire', 'pipewire'
    end
  end
end
