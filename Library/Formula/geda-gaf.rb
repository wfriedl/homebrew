require 'formula'

class GedaGaf < Formula
  homepage 'http://geda.seul.org'
  url 'http://geda.seul.org/release/v1.6/1.6.2/geda-gaf-1.6.2.tar.gz'
  sha1 '87c21b3b77eebc8eec1c16672d4b1ab418ccb80d'

  devel do
    url 'http://ftp.geda-project.org/geda-gaf/stable/v1.8/1.8.1/geda-gaf-1.8.1.tar.gz'
    sha1 '89757c0d8387225b80dcde200890c2042d02259e'
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'guile'
  depends_on 'gawk'
  depends_on :x11

  def patches
    # MacPorts fix for glib 2.32 includes
    # Needed for 1.6.2 and 1.7.x
    ps = {:p0 => [
      "https://trac.macports.org/export/92743/trunk/dports/science/geda-gaf/files/patch-glib-2.32.diff"
    ]}

    if !build.devel?
      ps = []
    end

    ps
  end

  def install
    # Help configure find libraries
    gettext = Formula.factory('gettext')
    pcb = Formula.factory('pcb')

    extra_configure_args = []
    if !build.devel?
      extra_configure_args << "--with-pcb-confdir=#{pcb.etc/:pcb}"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--with-gettext=#{gettext.prefix}",
                          "--disable-update-xdg-database",
                          "--with-pcb-datadir=#{HOMEBREW_PREFIX/:share/:pcb}",
                          *extra_configure_args

    system "make"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end

# There appears to be a typo info geda-gaf's configuration.
__END__
diff -ur a/m4/pcb-data-dirs.m4 b/m4/pcb-data-dirs.m4
--- a/m4/pcb-data-dirs.m4
+++ b/m4/pcb-data-dirs.m4
@@ -71,7 +71,7 @@
       [directory where PCB site configuration files are installed [[SYSCONFDIR/pcb]]]),
    [ if (test "X$with_pcb_confdir" != "Xno" &&
           test "X$with_pcb_confdir" != "Xyes"); then
-        PCBCONFDIR="$with_pcb_m4dir"
+        PCBCONFDIR="$with_pcb_confdir"
      fi ], [])
   AC_MSG_RESULT([$PCBCONFDIR])
   AC_SUBST([PCBCONFDIR])
