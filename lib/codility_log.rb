# frozen-string-literal: true

require 'highline'

module CodilityLog

  def self.logger
    CodilityLog::Logger.new
  end

  class Logger
    QUESTION = HighLine.color('¿ ', :white, :bold).freeze
    YES_OR_NO = [
      ' (',
      HighLine.color('yes', :underscore),
      '/',
      HighLine.color('no', :underscore),
      ') ',
    ].join.freeze

    FORMATTER = {
      cmd: { header: '$ ', color: :blue },
      error: { header: 'ERR:  ', color: :red },
      warning: { header: 'WARN: ', color: :yellow },
      info: { header: 'INFO: ' },
      ok: { color: :green },
      default: { header: '' },
    }.freeze

    class Aborted < RuntimeError; end

    attr_reader :terminal

    def initialize
      @terminal = HighLine.new
    end

    def color(*args)
      @terminal.color(*args)
    end

    # Ask user a nicely formatted yes/no question and return appropriate
    # boolean answer.
    #--
    # FIXME: this should be named #agree?
    def agree(yes_no_question)
      terminal.agree("#{QUESTION}#{yes_no_question}#{YES_OR_NO}")
    end

    # Ask user a yes/no question (via #agree) and raise an exception if user
    # says no.
    def raise_unless_agreed(question = nil)
      question ||= 'Proceed [yes] or Abort [no]?'
      raise Aborted, 'Aborting!' unless agree question
    end

    # Ask user to confirm putting uppercased answer (or `cancel` to abort).
    def confirm_with(answer)
      ask 'Please confirm', answer
    end

    # Simple print to STDOUT
    def say(msg)
      terminal.say(msg)
    end

    def log(msg, fmt = :default)
      case fmt
      when Symbol
        formatter = FORMATTER[fmt].dup
      when Hash
        formatter = FORMATTER[:default].dup
        formatter.merge!(fmt)
      else
        raise ArgumentError, "Invalid formatter: #{fmt}"
      end

      say format_message(msg, formatter)
    end

    # Logs message using #log, coloring it green (except the timestamp)
    def ok(msg)
      log msg, :ok
    end

    # Logs informational message using #log, adding INFO: as a header
    def info(msg)
      log msg, :info
    end

    # Logs warning message using #log, adding WARN: as a header and coloring
    # the message yellow
    def warning(msg)
      log msg, :warning
    end

    # Logs error message using #log, adding ERR: as a header and coloring
    # the message red. The header is aligned with #warning and #info headers by
    # adding additional spacing.
    def error(msg)
      log msg, :error
    end

    # Logs message using #log, adding `$ ` header and coloring the message blue.
    # This method is only responsible for custom formatting, `msg` can be any
    # string, that does not necessarily correspond to an actual command.
    def log_cmd(msg)
      log msg, :cmd
    end

    # Works like normal #say method but adds an empty line before and after the
    # message.
    def say_with_space(msg)
      say "\n"
      say msg
      say "\n"
    end

    # Works like normal #log method but adds an empty line before and after the
    # message.
    def log_with_space(msg, fmt = :default)
      say "\n"
      log msg, fmt
      say "\n"
    end

    # Works like #log_cmd but also adds the current working dir in []
    def log_cmd_with_path(msg, path: Dir.pwd)
      log msg, header: "[#{path}] $", color: FORMATTER[:cmd][:color]
    end

    private

    # Formats message using the given formatter.
    #
    # Add a whitespace to the header if there is none (and the header isn't
    # empty) to ensure the message is readable. Header should be applied only
    # to the first line, later lines should be aligned with the first one, but
    # have whitespace instead of the header.

    def format_message(msg, formatter)
      ts = timestamp
      header = formatter[:header] || ''
      header << ' ' unless header[-1] == ' ' || header.length == 0

      ts_length = ts.length
      header_length = header.length

      formatted_msg = msg.split("\n").map.with_index do |line, index|
        ts     = ' ' * ts_length unless index.zero?
        header = ' ' * header_length unless index.zero?
        header = color(header, formatter[:color])
        line   = color(line, formatter[:color])

        "#{ts} #{header}#{line}\n"
      end

      formatted_msg.join
    end

    # Returns current UTC time in format: HH:MM:SS
    def timestamp
      Time.now.utc.strftime '%T UTC'
    end
  end
end
