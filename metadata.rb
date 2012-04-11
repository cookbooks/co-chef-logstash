maintainer       "Joshua Timberman"
maintainer_email "cookbooks@housepub.org"
license          "Apache 2.0"
description      "Installs/Configures logstash"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "runit"

recipe           "logstash::default", "Installs logstash" 
recipe           "logstash::indexer", "Configures a logstash Indexing agent"
recipe           "logstash::shipper", "Configures a logstash Shipper agent"
