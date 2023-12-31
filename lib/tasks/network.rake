# frozen_string_literal: true

#
# These are Mac OsX development related
#
namespace :network do
  desc %{ ›› Toggle Web Proxy (HTTP) OFF }
  task :proxy_off do
    sh %( networksetup -setwebproxystate Ethernet off )
  end

  desc %{ ›› Toggle Web Proxy (HTTP) ON }
  task :proxy_on do
    sh %( networksetup -setwebproxy Ethernet 10.10.10.14 3128 )
  end

  desc %( ›› Add *.localhost to Mac OsX Network Proxy Settings )
  task :configure_bypass_proxy do
    sh %( networksetup -setproxybypassdomains Ethernet *.localhost, *.local, 169.254/16 )
  end

  desc %( ›› Get External IP )
  task :external_ip do
    sh %( curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g' )
    # Alternative
    # sh %{ curl ipecho.net/plain ; echo }
  end

  desc %( ›› Get Internal IP )
  task :internal_ip do
    sh %( ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d  -f2 )
  end

  # UUID Generation is built-in.
  desc %( ›› Get Random UUID )
  task :uuid do
    sh %( uuidgen | tr -d - | tr -d '\n' | tr '[:upper:]' '[:lower:]'  | pbcopy && pbpaste && echo )
    # Alternative
    # sh %{ require 'securerandom'; SecureRandom.uuid }
  end
end
