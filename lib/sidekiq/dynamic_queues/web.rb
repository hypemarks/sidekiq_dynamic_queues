require "sidekiq/web"

module Sidekiq
  module DynamicQueues
    module Web
      def self.registered(app)
        app.get "/dynamic_queues" do
          @dynamic_queues = Sidekiq.redis { |r| r.hgetall("dynamic_queues") }
          render(:erb, File.read(File.expand_path("../../../../web/views/dynamic_queues.erb", __FILE__)))
        end

        app.post "/dynamic_queues" do
          Sidekiq.redis do |r|
            r.multi do
              r.del("dynamic_queues")

              Array(params["dynamic_queues"]).each do |v|
                name = v["name"].strip
                r.hset("dynamic_queues", name, v["percentage"].to_f) unless name.empty?
              end
            end
          end

          redirect "#{root_path}dynamic_queues"
        end

        app.tabs["Dynamic Queues"] = "dynamic_queues"
      end
    end
  end
end

Sidekiq::Web.register Sidekiq::DynamicQueues::Web
