module Vim
  module Flavor
    class VersionConstraint
      attr_reader :base_version

      # Specifies how to choose a suitable version according to base_version.
      attr_reader :qualifier

      def initialize(s)
        # FIXME
      end

      def to_s()
        "#{qualifier} #{base_version}"
      end
    end
  end
end
