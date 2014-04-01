# Only include the Rails engine when using Rails.  This is for compatibility with metasploit-framework.
if defined? Rails
  require 'metasploit/concern/engine'
end

# Shared namespace for metasploit gems; used in {https://github.com/rapid7/metasploit-concern metasploit-concern},
# {https://github.com/rapid7/metasploit-framework metasploit-framework}, and
# {https://github.com/rapid7/metasploit-model metasploit-model}
module Metasploit
  # The namespace for this gem.
  module Concern

  end
end
