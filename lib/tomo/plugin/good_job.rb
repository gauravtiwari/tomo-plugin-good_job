require "tomo"
require_relative "good_job/tasks"
require_relative "good_job/version"

module Tomo::Plugin::GoodJob
  extend Tomo::PluginDSL

  tasks Tomo::Plugin::GoodJob::Tasks
  defaults good_job_systemd_service: "good_job_%{application}.service",
           good_job_systemd_service_path: ".config/systemd/user/%{good_job_systemd_service}",
           good_job_systemd_service_template_path: File.expand_path("good_job/service.erb", __dir__)
end
