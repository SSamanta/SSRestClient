Pod::Spec.new do |s|
  s.name     = "SSRestClient"
  s.version  = "2.0.1"
  s.license  = { :type => 'MIT' }
  s.summary  = 'Sample network call.'
  s.homepage = 'https://github.com/SSamanta/'
  s.authors  = { 'Susim' => 'susim.samanta@me.com' }
  s.source   = { :git => "https://github.com/SSamanta/SSRestClient.git", :branch => "v-2.0.0", :tag => "v1.0.1"  }
  s.source_files = 'SSRestClient/SSRestClient/*.{h,m}'
  s.requires_arc = true
end
