Rails.application.routes.draw do
  mount Metasploit::Concern::Engine => "/metasploit/concern"
end
