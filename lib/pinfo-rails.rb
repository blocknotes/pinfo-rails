# coding: utf-8
require 'colorize'
require 'optparse'
require 'ostruct'
require 'yaml'

module PinfoRails
  NAME = 'pinfo-rails'.freeze
  DATE = '2016-10-08'.freeze
  INFO = 'Rails project info'.freeze
  DESC = 'A gem to collect informations from a Rails project'.freeze
  AUTHORS = [ [ 'Mattia Roccoberton', 'mat@blocknot.es', 'http://blocknot.es' ] ].freeze
  VERSION = [ 0, 1, 2 ].freeze

  FILES = {
    conf_db: 'config/database.yml',
    conf_env_dev: 'config/environments/development.rb',
    conf_env_stag: 'config/environments/staging.rb',
    conf_env_prod: 'config/environments/production.rb',
    conf_dep: 'config/deploy.rb',
    conf_dep_stag: 'config/deploy/staging.rb',
    conf_dep_prod: 'config/deploy/production.rb',
    gemfile: 'Gemfile'
  }.freeze
  PATTERNS = {
    cache: /config.cache_classes.*/,
    deploy_info: /branch\s*,.*|user\s*,.*|domain\s*,.*|server[^,]+/,
    deploy_tool: /'capistrano'|"capistrano|'capistrano-rails'|"capistrano-rails"|'mina'|"mina"/,
    deploy_user: /user.*/,
    rails: /'rails'.*|"rails".*/
  }.freeze

  # pinfo-rails: A gem to collect informations from a Rails project
  class PinfoRails
    # main method
    def self.info( args )
      @conf = {}
      @options = optparse( args )

      @output = ''
      @output += "[verbose mode]\n" if @options[:verbose]
      if @options[:conf]
        @output += "[with config: #{@options[:conf]}]\n"
        if File.exist? @options[:conf]
          lines = File.read( @options[:conf] ).split( "\n" ).reject { |l| l =~ /^\s*$|^\s*#.*$/ }.map { |l| "--#{l.strip}" }
          @options = optparse( lines )
        else
          puts 'ERR: file not found'
          exit
        end
      end

      # Ruby version
      printline( 'Ruby', { color: :green, mode: :bold }, RUBY_VERSION, @options[:verbose] ? 'p' + RUBY_PATCHLEVEL.to_s : nil )
      # Rails version
      printline( 'Rails', { color: :green, mode: :bold }, grep( FILES[:gemfile], PATTERNS[:rails] ) )
      check_database
      check_requirements
      check_cache
      check_deploy

      @output
    end

    # support methods

    def self.check_cache
      if @options.info[:cache]
        @output += "\n"
        printline( 'Development', :cyan, grep( FILES[:conf_env_dev], PATTERNS[:cache] ) )
        printline( 'Staging    ', :yellow, grep( FILES[:conf_env_stag], PATTERNS[:cache] ) )
        printline( 'Production ', :red, grep( FILES[:conf_env_prod], PATTERNS[:cache] ) )
      end
    end

    def self.check_database
      if File.exist? FILES[:conf_db]
        if @options[:verbose]
          printline FILES[:conf_db], {}, ' '
          @output += cat FILES[:conf_db]
        else
          content = YAML.load_file( FILES[:conf_db] ) rescue nil
          if content.nil?
            @output += "ERR: invalid YAML file: #{FILES[:conf_db]}"
          elsif content['development']
            printline( 'DB (development)', :cyan, content['development']['adapter'], content['development']['database'] )
          end
        end
      end
    end

    def self.check_deploy
      if @options.info[:deploy]
        @output += "\n"
        printline( 'Deploy tool', { color: :green, mode: :bold }, grep( FILES[:gemfile], PATTERNS[:deploy_tool] ) )
        if @options[:verbose]
          printline FILES[:conf_dep], {}, ' '
          @output += cat FILES[:conf_dep]
        else
          printline( 'Deploy user', :green, grep( FILES[:conf_dep], PATTERNS[:deploy_user] ) )
        end
        printline( 'Staging    ', :yellow, grep( FILES[:conf_dep_stag], PATTERNS[:deploy_info] ) )
        printline( 'Production ', :red, grep( FILES[:conf_dep_prod], PATTERNS[:deploy_info] ) )
      end
    end

    def self.check_requirements
      @options.reqs.split( ',' ).each do |req|
        printline( 'Required', :blue, grep( FILES[:gemfile], Regexp.new( "['|\"][^'\"]*#{req}[^'\"]*['|\"]" ) ) )
      end
    end

    def self.cat( file )
      lines = []
      if File.exist? file
        File.read( file ).each_line do |line|
          lines.push( line.rstrip ) unless line.strip =~ /^$|^#.*$/
        end
        lines.push( '' )
      end
      lines.join( "\n" )
    end

    def self.grep( file, expression )
      lines = []
      if File.exist? file
        File.read( file ).each_line do |line|
          lines.push( Regexp.last_match ) if !( line.strip =~ /^#.*$/ ) && line =~ expression
        end
      end
      ( lines.length > 1 ? "\n    " : '' ) + lines.join( "\n    " )
    end

    def self.printline( intro, styles, *strings )
      cnt = strings.reject { |s| s.nil? || s.empty? }.length
      return unless cnt > 0
      @output += '- ' + intro + ': '
      @output += @options[:styles] ? strings.compact.map( &:to_s ).join( ', ' ).colorize( styles ) : strings.compact.map( &:to_s ).join( ', ' )
      @output += "\n"
    end

    def self.optparse( args )
      options = OpenStruct.new
      options.library = []
      options.inplace = false
      options.encoding = 'utf8'
      options.transfer_type = :auto
      options.conf = nil
      options.reqs = ''
      options.styles = true
      options.verbose = false
      options.info = {
        cache: true,
        deploy: true
      }

      begin
        opt_parser = OptionParser.new do |opts|
          opts.banner = 'Usage: pinfo [options]'

          opts.separator ''
          opts.separator 'Specific options:'

          opts.on('-cCONF', '--config=CONF', 'Config file') do |v|
            options.conf = v
          end
          opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
            options.verbose = v
          end
          opts.separator ''
          opts.on('-s', '--[no-]styles', 'With styles and colors (default)') do |v|
            options.styles = v
          end
          opts.on('-rREQS', '--required=REQS', 'Search for specific gems') do |v|
            options.reqs = v
          end
          opts.on('--[no-]cache', 'Show cache info') do |v|
            options.info[:cache] = v
          end
          opts.on('--[no-]deploy', 'Show deploy info') do |v|
            options.info[:deploy] = v
          end

          opts.separator ''
          opts.separator 'Common options:'

          opts.on_tail('-h', '--help', 'Show this message') do
            puts opts
            exit
          end
          opts.on_tail('--about', 'Show about') do
            puts INFO + ' v' + VERSION.join('.') + "\n" + DESC + "\nby " + AUTHORS.first.join( ', ' )
            exit
          end
          opts.on_tail('--version', 'Show version') do
            puts VERSION.join('.')
            exit
          end
        end
        if File.exist? File.expand_path '~/.pinfo-rails.conf'
          # global configuration
          lines = File.read( File.expand_path( '~/.pinfo-rails.conf' ) ).split( "\n" ).reject { |l| l =~ /^\s*$|^\s*#.*$/ }.map { |l| "--#{l.strip}" }
          opt_parser.parse!( lines )
        end
        opt_parser.parse!( args )
      rescue Exception => e
        puts 'ERR: ' + e.message
        exit
      end
      options
    end
  end
end
