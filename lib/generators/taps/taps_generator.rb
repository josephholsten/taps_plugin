class TapsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  add_shebang_option!
  
  def script
    directory "script" do |content|
      "#{shebang}\n" + content
    end
    chmod "script", 0755, :verbose => false
  end
  
  def gemfile
    gem 'taps', '~>0.3', :group => 'development'
  end
end
