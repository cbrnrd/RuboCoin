require 'colorize'

# Prints +msg+ to the given descriptor in the form of "[INFO] - msg"
def info(msg = '', descriptor = $stdout)
  descriptor.puts("[#{'INFO'.blue}] - #{msg}")
end

# @see #info
# Prints an informational message with a timestamp prepended to it
# Example: 2005-03-19 15:10:26,618 - [INFO] - msg
def info_with_timestamp(msg = '', descriptor = $stdout)
  descriptor.puts("#{Time.now} - [#{'INFO'.blue}] - #{msg}")
end

# Prints +msg+ to the given descriptor in the form of "[ERROR] - msg"
def error(msg = '', descriptor = $stdout)
  descriptor.puts("[#{'ERROR'.red}] - #{msg}")
end

# @see #error
# Prints an error message with a timestamp prepended to it
# Example: 2005-03-19 15:10:26,618 - [ERROR] - msg
def error_with_timestamp(msg = '', descriptor = $stdout)
  descriptor.puts("#{Time.now} - [#{'ERROR'.blue}] - #{msg}")
end

# Prints +msg+ to the given descriptor in the form of "[DEBUG] - msg"
def debug(msg = '', descriptor = $stdout)
  descriptor.puts("[#{'DEBUG'.yellow}] - #{msg}")
end

# @see #debug
# Prints an debug message with a timestamp prepended to it
# Example: 2005-03-19 15:10:26,618 - [DEBUG] - msg
def debug_with_timestamp(msg = '', descriptor = $stdout)
  descriptor.puts("#{Time.now} - [#{'DEBUG'.yellow}] - #{msg}")
end

# Prints +msg+ to the given descriptor in the form of "[NEW] - msg"
def print_new(msg = '', descriptor = $stdout)
  descriptor.puts("[#{'NEW'.green}] - #{msg}")
end

# @see #new
# Prints a 'NEW' message with a timestamp prepended to it.
# Usually used for new blocks being formed
# Example: 2005-03-19 15:10:26,618 - [NEW] - msg
def new_with_timestamp(msg = '', descriptor = $stdout)
  descriptor.puts("#{Time.now} - [#{'NEW'.green}] - #{msg}")
end
