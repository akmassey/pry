Pry.config.commands.command 'pbcopy', 'Copy input to clipboard' do |input|
  input = input ? target.eval(input) : _pry_.last_result
  IO.popen('pbcopy', 'w') { |io| io << input }
end

Pry.config.commands.command 'html-view', 'Write input to and html file and open it' do |input|
  input = input ? target.eval(input) : _pry_.last_result

  require 'tempfile'
  file = Tempfile.new(['pry-result', '.html'])
  begin
    file.write(input)
    file.rewind
    `open #{file.path}`
  ensure
    file.unlink
  end
end

Pry.config.color = true

Pry.prompt = [
  proc { |target_self, nest_level, pry| "\001\e[01;38;5;202m\002[#{pry.input_array.size}] #{pry.config.prompt_name}(#{Pry.view_clip(target_self)})#{":#{nest_level}" unless nest_level.zero?}> \001\e[0m\002" },
  proc { |target_self, nest_level, pry| "\001\e[01;38;5;202m\002[#{pry.input_array.size}] #{pry.config.prompt_name}(#{Pry.view_clip(target_self)})#{":#{nest_level}" unless nest_level.zero?}* \001\e[0m\002" },
]

if defined?(PryDebugger)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

Pry.config.theme = "tomorrow-night"
