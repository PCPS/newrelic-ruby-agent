# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require 'new_relic/agent/utilization/vendor'

module NewRelic
  module Agent
    module Utilization
      class PCF < Vendor
        vendor_name "pcf"
        keys ["CF_INSTANCE_GUID", "CF_INSTANCE_IP", "MEMORY_LIMIT"]
        key_transforms [:downcase, :to_sym]

        def detect
          begin
            return false unless pcf_keys_present?
            process_response ENV
          rescue => e
            NewRelic::Agent.logger.error "Unexpected error obtaining utilization data for #{vendor_name}", e
            record_supportability_metric
            false
          end
        end

        def pcf_keys_present?
          !(ENV.keys & keys).empty?
        end
      end
    end
  end
end
