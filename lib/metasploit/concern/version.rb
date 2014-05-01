module Metasploit
  module Concern
    # Holds components of {VERSION} as defined by {http://semver.org/spec/v2.0.0.html semantic versioning v2.0.0}.
    module Version
      # The major version number.
      MAJOR = 0
      # The minor version number, scoped to the {MAJOR} version number.
      MINOR = 0
      # The patch number, scoped to the {MINOR} version number.
      PATCH = 2
      # The prerelease version number, scoped to the {PATCH} version number.
      PRERELEASE = 'shared-example'

      # The full version string, including the {MAJOR}, {MINOR}, {PATCH}, and optionally, the `PRERELEASE` in the
      # {http://semver.org/spec/v2.0.0.html semantic versioning v2.0.0} format.
      #
      # @return [String] '{MAJOR}.{MINOR}.{PATCH}' on master.  '{MAJOR}.{MINOR}.{PATCH}-<PRERELEASE>' on any branch
      #   other than master.
      def self.full
        version = "#{MAJOR}.#{MINOR}.#{PATCH}"

        if defined? PRERELEASE
          version = "#{version}-#{PRERELEASE}"
        end

        version
      end
    end

    # @see Version.full
    VERSION = Version.full
  end
end
