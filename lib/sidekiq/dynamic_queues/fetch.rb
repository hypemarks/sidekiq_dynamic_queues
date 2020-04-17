require "sidekiq/util"
require "sidekiq/fetch"

module Sidekiq
  module DynamicQueues
    class Fetch < Sidekiq::BasicFetch
      include Sidekiq::Util

      def initialize(options)
        @strictly_ordered_queues = !!options[:strict]
        @queues = options[:queues]
      end

      def queues_cmd
        queues = @queues.dup.flat_map { |queue| queue == "@" ? expand_at : queue }
                            .compact
                            .map { |q| "queue:#{q}" }

        queues = @strictly_ordered_queues ? queues : queues.shuffle

        queues << TIMEOUT
      end

      def expand_at
        process_set = Sidekiq::ProcessSet.new.to_a

        index = process_set.index { |process| process["hostname"] == hostname }
        return unless index

        dynamic_queues = Sidekiq.redis { |r| r.hgetall("dynamic_queues") }

        Sidekiq::Queue.all
                      .map(&:name)
                      .select do |name|
                                percentage = (dynamic_queues[name] || Array(dynamic_queues.find { |k, _| Regexp.new("^#{k}$") =~ name })[1] || 100).to_f
                                percentage > 0 ? index <= (percentage / 100.0 * process_set.size).ceil : nil
                              end
      end
    end
  end
end
