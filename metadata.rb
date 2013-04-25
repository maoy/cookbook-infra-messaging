name             "infra-messaging"
maintainer       "AT&T Services, Inc."
maintainer_email "cookbooks@lists.tfoundry.com"
license          "Apache 2.0"
description      "Installs/Configures infra-messaging"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

recipe           "infra-messaging", "Installs/Configures infra-messaging"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "nova"
depends "openstack-common", ">= 0.1.7"
depends "rabbitmq"
