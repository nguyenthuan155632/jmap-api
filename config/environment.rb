# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

#ログ出力クラス
class Logger
  class Formatter
    def call(severity, time, progname, msg)
      file_name, line_num = caller.map { |x| 
        [Pathname.new($1).relative_path_from(Rails.root).to_s, $2] if x =~ /(.*?):(\d+)/
      }.compact.find { |x|
        x[0] !~ /^(..)\//
      }

      file_name ||= ""
      line_num ||= ""

      format = "[%s #%d %s:%s] %5s -- %s: %s\n"
      format % ["#{time.strftime('%g-%m-%d %H:%M:%S.%3N')}",
                  $$, file_name, line_num, severity, progname, msg2str(msg)]
    end
  end
end