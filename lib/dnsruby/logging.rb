module Dnsruby
  class Logging

    # TODO: Replace 'args' with actual argument list.
    class << self

      def error(args);  logger.error(args);  end
      def warn(args);   logger.warn(args);   end
      def info(args);   logger.info(args);   end
      def debug(args);  logger.debug(args);  end


      def logger
        unless @logger
          @logger = Logger.new(STDOUT)
          @logger.level = Logger::FATAL
        end
        @logger
      end
      alias :log :logger

      def logger=(new_logger)
        @logger = new_logger
      end

      #  Logs (error level) and raises an error.
      def self.log_and_raise(object, error_class = RuntimeError)
        if object.is_a?(Exception)
          error = object
          Dnsruby.log.error(error.inspect)
          raise error
        else
          message = object.to_s
          Dnsruby.log.error(message)
          raise error_class.new(message)
        end
      end
    end
  end
end
