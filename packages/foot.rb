# Adapted from Arch Linux foot PKGBUILD at:
# https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=foot

require 'buildsystems/meson'

class Foot < Meson
  description 'Wayland terminal emulator - fast, lightweight and minimalistic'
  homepage 'https://codeberg.org/dnkl/foot'
  version '1.15.0'
  compatibility 'x86_64 aarch64 armv7l'
  source_url 'https://codeberg.org/dnkl/foot.git'
  git_hashtag version

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/foot/1.15.0_armv7l/foot-1.15.0-chromeos-armv7l.tar.zst',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/foot/1.15.0_armv7l/foot-1.15.0-chromeos-armv7l.tar.zst',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/foot/1.15.0_x86_64/foot-1.15.0-chromeos-x86_64.tar.zst'
  })
  binary_sha256({
    aarch64: '600c9b3fefa7b6416f87c39a95afb3bf06075760a2e1ad6e9e84dfe1a46bc609',
     armv7l: '600c9b3fefa7b6416f87c39a95afb3bf06075760a2e1ad6e9e84dfe1a46bc609',
     x86_64: '4baccb81bb940da9f73b2610dd98777524e1085422709fa7ac3ae193cf65291c'
  })

  depends_on 'libxkbcommon'
  depends_on 'wayland'
  depends_on 'pixman'
  depends_on 'fontconfig'
  depends_on 'utf8proc'
  depends_on 'ncurses'
  depends_on 'fcft'
  depends_on 'wayland_protocols' => :build
  depends_on 'tllist' => :build
  depends_on 'freetype' # R
  depends_on 'glibc' # R
  depends_on 'harfbuzz' # R
  depends_on 'gcc_lib' # R
  depends_on 'glibc_lib' # R

  def self.preflight
    abort 'Foot requires glibc > 2.28.' if Gem::Version.new(LIBC_VERSION.to_s) < Gem::Version.new('2.28')
  end
end
