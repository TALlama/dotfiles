#!/usr/bin/ruby
require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

IRB.conf[:PROMPT_MODE] = :SIMPLE

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true

def say(msg)
	%x{osascript -e 'tell application "Finder" to say "#{msg}"'}
end

%w[rubygems looksee/shortcuts awesome_print].each do |gem|
  begin
    require gem
  rescue LoadError
  end
end

AwesomePrint.defaults = {indent: 2, index: false, multiline: false} if defined? AwesomePrint

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  copy content
end

def paste
  `pbpaste`
end

load File.dirname(__FILE__) + '/.railsrc' if ($0 == 'irb' && ENV['RAILS_ENV']) || ($0 == 'script/rails' && Rails.env)
