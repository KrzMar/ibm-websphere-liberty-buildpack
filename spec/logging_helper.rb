# Encoding: utf-8
# IBM WebSphere Application Server Liberty Buildpack
# Copyright IBM Corp. 2014, 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'application_helper'
require 'console_helper'
require 'fileutils'
require 'liberty_buildpack/diagnostics/logger_factory'

shared_context 'logging_helper' do
  include_context 'console_helper'
  include_context 'application_helper'

  previous_log_config = ENV['JBP_CONFIG_LOGGING']
  previous_log_level = ENV['JBP_LOG_LEVEL']
  previous_debug_level = $DEBUG
  previous_verbose_level = $VERBOSE

  let(:log_contents) { Pathname.new(LibertyBuildpack::Diagnostics.get_buildpack_log(app_dir)).read }

  before do |example|
    log_level = example.metadata[:log_level]
    ENV['JBP_LOG_LEVEL'] = log_level if log_level

    enable_log_file = example.metadata[:enable_log_file]
    ENV['JBP_CONFIG_LOGGING'] = 'enable_log_file: true' if enable_log_file

    $DEBUG = example.metadata[:debug]
    $VERBOSE = example.metadata[:verbose]

    LibertyBuildpack::Diagnostics::LoggerFactory.send :close # suppress warnings
    LibertyBuildpack::Diagnostics::LoggerFactory.create_logger app_dir
  end

  after do
    FileUtils.rm_rf LibertyBuildpack::Diagnostics.get_diagnostic_directory app_dir

    ENV['JBP_CONFIG_LOGGING'] = previous_log_config
    ENV['JBP_LOG_LEVEL'] = previous_log_level
    $VERBOSE = previous_verbose_level
    $DEBUG = previous_debug_level
  end

end
