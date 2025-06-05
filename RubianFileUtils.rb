# rubian_file_utils.rb
# A comprehensive file management and system utility gem
# Inspired by the Rubian shell project's clean Ruby-native approach

require 'fileutils'
require 'pathname'
require 'digest'
require 'json'

module RubianFileUtils
  VERSION = "1.0.0"
  
  class DynamicUtils
    attr_reader :cached_directories
    
    def initialize
      @cached_directories = cache_directories
      puts "Cached #{@cached_directories.length} directories for fast file searching"
    end
    
    # Cache directory structure for fast searching
    def cache_directories
      puts "Scanning directory structure..."
      cached = []
      
      # Start from user home and common system paths
      search_paths = [
        Dir.home,
        "/usr/local",
        "/opt",
        Dir.pwd
      ].select { |path| Dir.exist?(path) }
      
      search_paths.each do |base_path|
        begin
          # Limit depth to avoid performance issues
          Dir.glob("#{base_path}/**/", File::FNM_DOTMATCH).each do |dir|
            cached << dir
            # Stop if we hit too many directories (performance limit)
            break if cached.length > 10000
          end
        rescue Errno::EACCES, Errno::ELOOP
          # Skip permission denied or symlink loops
          next
        end
      end
      
      cached.uniq.sort
    end
    
    # Refresh the cached directory tree when needed
    def refresh_cache
      @cached_directories = cache_directories
      puts "Cache refreshed: #{@cached_directories.length} directories"
    end
    
    # Find files matching a pattern
    def rubian_find(pattern, path: ".")
      Dir.glob(File.join(path, "**", pattern))
    end
    
    # Display directory tree structure
    def rubian_tree(path: ".", max_depth: 1, show_hidden: false, dirs_only: true)
      puts "[DIR] #{File.expand_path(path)}"
      display_tree(path, "", 0, max_depth, show_hidden, dirs_only)
    end
    
    # List directory contents with details
    def rubian_ls(path: ".", detailed: false, hidden: false)
      entries = Dir.entries(path).reject { |f| f.start_with?('.') unless hidden }
      
      if detailed
        entries.each do |entry|
          full_path = File.join(path, entry)
          stat = File.stat(full_path)
          permissions = File.executable?(full_path) ? "x" : "-"
          permissions += File.readable?(full_path) ? "r" : "-"
          permissions += File.writable?(full_path) ? "w" : "-"
          type = File.directory?(full_path) ? "d" : "f"
          
          puts "#{type}#{permissions} #{stat.size.to_s.rjust(8)} #{entry}"
        end
      else
        puts entries.join("  ")
      end
    end
    
    # Copy files with progress
    def rubian_copy(source, destination, verbose: false)
      if File.directory?(source)
        FileUtils.cp_r(source, destination, verbose: verbose)
      else
        FileUtils.cp(source, destination, verbose: verbose)
      end
      puts "Copied: #{source} -> #{destination}" if verbose
    end
    
    # Move files
    def rubian_move(source, destination, verbose: false)
      FileUtils.mv(source, destination, verbose: verbose)
      puts "Moved: #{source} -> #{destination}" if verbose
    end
    
    # Create directory structure
    def rubian_mkdir(path, parents: true, verbose: false)
      if parents
        FileUtils.mkdir_p(path, verbose: verbose)
      else
        Dir.mkdir(path)
      end
      puts "Created: #{path}" if verbose
    end
    
    # Fast file search using cached directories
    def rubian_fast_find(filename)
      matches = []
      @cached_directories.each do |dir|
        potential_file = File.join(dir, filename)
        matches << potential_file if File.exist?(potential_file)
      end
      matches
    end
    
    # File hash/checksum generation
    def rubian_hash(file_path, algorithm: :md5)
      return "File not found: #{file_path}" unless File.exist?(file_path)
      
      case algorithm
      when :md5
        Digest::MD5.hexdigest(File.read(file_path))
      when :sha1
        Digest::SHA1.hexdigest(File.read(file_path))
      when :sha256
        Digest::SHA256.hexdigest(File.read(file_path))
      else
        "Unsupported algorithm: #{algorithm}"
      end
    end
    
    # Compare two files
    def rubian_diff(file1, file2)
      unless File.exist?(file1) && File.exist?(file2)
        return "One or both files don't exist"
      end
      
      content1 = File.readlines(file1)
      content2 = File.readlines(file2)
      
      if content1 == content2
        "Files are identical"
      else
        "Files differ at line: #{find_first_difference(content1, content2)}"
      end
    end
    
    # Archive creation (simplified tar-like)
    def rubian_archive(source_path, archive_name = nil)
      archive_name ||= "#{File.basename(source_path)}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.tar"
      
      if system("tar -cf #{archive_name} #{source_path}")
        puts "Archive created: #{archive_name}"
        archive_name
      else
        puts "Archive creation failed"
        nil
      end
    end
    
    # Extract archives
    def rubian_extract(archive_path, destination = ".")
      case File.extname(archive_path).downcase
      when '.tar'
        system("tar -xf #{archive_path} -C #{destination}")
      when '.gz'
        system("tar -xzf #{archive_path} -C #{destination}")
      when '.zip'
        system("unzip #{archive_path} -d #{destination}")
      else
        puts "Unsupported archive format: #{File.extname(archive_path)}"
        return false
      end
      
      puts "Extracted: #{archive_path} to #{destination}"
      true
    end
    
    # File permissions management
    def rubian_chmod(path, permissions, recursive: false)
      if recursive && File.directory?(path)
        FileUtils.chmod_R(permissions, path)
      else
        FileUtils.chmod(permissions, path)
      end
      puts "Permissions changed: #{path} -> #{permissions.to_s(8)}"
    end
    
    # Git utilities - interactive git manager
    def rubian_git_manager(interactive: true)
      if interactive
        git_manager_repl
      else
        puts "Non-interactive git management not yet implemented"
        puts "Use: rubian_git_manager(interactive: true)"
      end
    end
    
    # USB/media management utilities
    def rubian_usb_manager(interactive: true)
      if interactive
        usb_manager_repl
      else
        list_usb_devices
      end
    end
    
    # C compilation utilities
    def rubian_make(source_file, interactive: false)
      if interactive
        make_repl(source_file)
      else
        simple_compile(source_file)
      end
    end
    
    # Installer generator - interactive REPL for creating deployment scripts
    def rubian_installer_generator(interactive: true)
      if interactive
        installer_generator_repl
      else
        puts "Non-interactive installer generation not yet implemented"
        puts "Use: rubian_installer_generator(interactive: true)"
      end
    end
    
    # Interactive installer generator REPL
    def installer_generator_repl
      puts "=== Rubian Installer Generator ==="
      puts "Commands: create, load, save, preview, test, help, exit"
      
      @installer_config = {
        project_name: nil,
        version: "1.0.0",
        description: nil,
        dependencies: [],
        components: {},
        install_path: nil
      }
      
      loop do
        print "installer> "
        command = gets.chomp.downcase.split
        
        case command[0]
        when 'create', 'c'
          create_installer_config
        when 'load', 'l'
          load_installer_config(command[1])
        when 'save', 's'
          save_installer_config(command[1])
        when 'preview', 'p'
          preview_installer
        when 'generate', 'g'
          generate_installer_script
        when 'test', 't'
          test_installer
        when 'help', 'h'
          show_installer_help
        when 'exit', 'e'
          break
        else
          puts "Unknown command: #{command[0]}"
          puts "Type 'help' for available commands"
        end
      end
      
      puts "Exited Installer Generator"
    end
    
    # Create installer configuration interactively
    def create_installer_config
      puts "\n=== Creating New Installer Configuration ==="
      
      print "Project name: "
      @installer_config[:project_name] = gets.chomp
      
      print "Version (#{@installer_config[:version]}): "
      version_input = gets.chomp
      @installer_config[:version] = version_input.empty? ? @installer_config[:version] : version_input
      
      print "Description: "
      @installer_config[:description] = gets.chomp
      
      print "Install path (default: #{Dir.home}/#{@installer_config[:project_name]}): "
      path_input = gets.chomp
      @installer_config[:install_path] = path_input.empty? ? "#{Dir.home}/#{@installer_config[:project_name]}" : path_input
      
      puts "\nAdding dependencies..."
      add_dependencies
      
      puts "\nAdding components..."
      add_components
      
      puts "\nConfiguration created successfully!"
      preview_installer
    end
    
    # Add gem dependencies
    def add_dependencies
      puts "Enter gem dependencies (one per line, empty line to finish):"
      
      loop do
        print "gem: "
        gem_name = gets.chomp
        break if gem_name.empty?
        
        @installer_config[:dependencies] << gem_name
        puts "  Added: #{gem_name}"
      end
    end
    
    # Add component directories and files
    def add_components
      puts "Adding components (directories with files):"
      puts "Enter component name (empty line to finish):"
      
      loop do
        print "component: "
        component_name = gets.chomp
        break if component_name.empty?
        
        puts "Files for #{component_name} component (empty line to finish):"
        files = []
        
        loop do
          print "  file: "
          file_name = gets.chomp
          break if file_name.empty?
          
          files << file_name
        end
        
        @installer_config[:components][component_name] = files
        puts "  Added component: #{component_name} with #{files.length} files"
      end
    end
    
    # Preview current configuration
    def preview_installer
      puts "\n=== Current Installer Configuration ==="
      puts "Project: #{@installer_config[:project_name]}"
      puts "Version: #{@installer_config[:version]}"
      puts "Description: #{@installer_config[:description]}"
      puts "Install Path: #{@installer_config[:install_path]}"
      puts "Dependencies: #{@installer_config[:dependencies].join(', ')}"
      puts "Components:"
      @installer_config[:components].each do |name, files|
        puts "  #{name}: #{files.join(', ')}"
      end
      puts "===================================="
    end
    
    # Generate the actual installer script
    def generate_installer_script
      unless @installer_config[:project_name]
        puts "No configuration loaded. Use 'create' first."
        return
      end
      
      script_content = build_installer_script
      filename = "#{@installer_config[:project_name].downcase}_installer.rb"
      
      File.write(filename, script_content)
      File.chmod(0755, filename)
      
      puts "Generated installer: #{filename}"
      puts "Made executable"
    end
    
    # Build the complete installer script content
    def build_installer_script
      project = @installer_config[:project_name]
      version = @installer_config[:version]
      description = @installer_config[:description]
      
      script = <<~RUBY
        #!/usr/bin/env ruby
        
        # #{project} Installer v#{version}
        # #{description}
        # Generated by RubianFileUtils
        
        require 'fileutils'
        
        class #{project}Installer
          def initialize
            @project_name = "#{project}"
            @version = "#{version}"
            @install_path = "#{@installer_config[:install_path]}"
            @components_installed = {}
            
            install_dependencies
            load_components
          end
          
          def install_dependencies
            puts "Installing dependencies..."
            #{generate_dependency_installs}
          end
          
          def load_components
            # Component loading would go here
            puts "Loading installer components..."
          end
          
          #{generate_check_methods}
          
          #{generate_install_methods}
          
          #{generate_uninstall_methods}
          
          def run
            puts '=' * 80
            puts "#{@project_name.upcase} INSTALLER v#{@version}"
            puts '=' * 80
            puts "#{description}"
            puts ''
            puts "Checking installation status..."
            
            check_installation
            
            if installation_exists?
              handle_existing_installation
            else
              handle_new_installation
            end
          end
          
          private
          
          def check_installation
            #{generate_component_checks}
          end
          
          def installation_exists?
            @components_installed.values.any?
          end
          
          def handle_existing_installation
            print "#{@project_name} found. Uninstall? [Y/n]: "
            response = gets.chomp
            
            if response =~ /Y|y/
              uninstall_all
              puts "#{@project_name} uninstalled successfully!"
            end
          end
          
          def handle_new_installation
            print "Install #{@project_name}? [Y/n]: "
            response = gets.chomp
            
            if response =~ /Y|y/
              install_all
              puts "#{@project_name} installed successfully!"
            end
          end
          
          def install_all
            #{generate_install_calls}
          end
          
          def uninstall_all
            #{generate_uninstall_calls}
          end
        end
        
        # Run the installer
        #{project}Installer.new.run
      RUBY
      
      script
    end
    
    def generate_dependency_installs
      return "# No dependencies" if @installer_config[:dependencies].empty?
      
      @installer_config[:dependencies].map do |gem|
        "system \"gem install #{gem}\""
      end.join("\n            ")
    end
    
    def generate_check_methods
      @installer_config[:components].map do |component, files|
        <<~RUBY
          def check_#{component}_install
            component_dir = File.join(@install_path, "#{component}")
            @components_installed[:#{component}] = Dir.exist?(component_dir)
            
            if @components_installed[:#{component}]
              puts "#{component.capitalize} component found"
            else
              puts "#{component.capitalize} component not found"
            end
          end
        RUBY
      end.join("\n")
    end
    
    def generate_install_methods
      @installer_config[:components].map do |component, files|
        <<~RUBY
          def install_#{component}
            component_dir = File.join(@install_path, "#{component}")
            FileUtils.mkdir_p(component_dir)
            
            Dir.chdir(component_dir)
            
            #{generate_file_creation(files)}
            
            puts "#{component.capitalize} component installed"
          end
        RUBY
      end.join("\n")
    end
    
    def generate_uninstall_methods
      @installer_config[:components].map do |component, files|
        <<~RUBY
          def uninstall_#{component}
            component_dir = File.join(@install_path, "#{component}")
            FileUtils.rm_rf(component_dir) if Dir.exist?(component_dir)
            puts "#{component.capitalize} component removed"
          end
        RUBY
      end.join("\n")
    end
    
    def generate_component_checks
      @installer_config[:components].keys.map do |component|
        "check_#{component}_install"
      end.join("\n            ")
    end
    
    def generate_install_calls
      @installer_config[:components].keys.map do |component|
        "install_#{component}"
      end.join("\n            ")
    end
    
    def generate_uninstall_calls
      @installer_config[:components].keys.reverse.map do |component|
        "uninstall_#{component}"
      end.join("\n            ")
    end
    
    def generate_file_creation(files)
      files.map do |file|
        <<~RUBY
          File.write("#{file}", <<~CONTENT)
            # #{file} - Generated by installer
            # Add your content here
          CONTENT
        RUBY
      end.join("\n            ")
    end
    
    def show_installer_help
      puts "\n=== Installer Generator Commands ==="
      puts "create (c)     - Create new installer configuration"
      puts "load (l) FILE  - Load configuration from file"
      puts "save (s) FILE  - Save current configuration"
      puts "preview (p)    - Preview current configuration"
      puts "generate (g)   - Generate installer script"
      puts "test (t)       - Test generated installer"
      puts "help (h)       - Show this help"
      puts "exit (e)       - Exit generator"
      puts "===================================="
    end
    
    def save_installer_config(filename)
      filename ||= "#{@installer_config[:project_name]}_config.rb"
      File.write(filename, @installer_config.inspect)
      puts "Configuration saved: #{filename}"
    end
    
    def load_installer_config(filename)
      if filename && File.exist?(filename)
        @installer_config = eval(File.read(filename))
        puts "Configuration loaded: #{filename}"
        preview_installer
      else
        puts "Configuration file not found: #{filename}"
      end
    end
    
    def test_installer
      puts "Testing installer generation..."
      if @installer_config[:project_name]
        generate_installer_script
        puts "Test completed - check generated installer"
      else
        puts "No configuration to test"
      end
    end
    
    private
    
    # Helper method for tree display
    def display_tree(path, prefix, depth, max_depth, show_hidden, dirs_only = true)
      return if depth > max_depth
      
      entries = Dir.entries(path).reject { |f| f.start_with?('.') unless show_hidden }
      
      # Filter to directories only if dirs_only is true
      if dirs_only
        entries = entries.select { |entry| File.directory?(File.join(path, entry)) }
      end
      
      entries = entries.sort
      
      entries.each_with_index do |entry, index|
        next if entry == '.' || entry == '..'
        
        full_path = File.join(path, entry)
        is_last = index == entries.length - 1
        
        current_prefix = is_last ? "└── " : "├── "
        icon = File.directory?(full_path) ? "[DIR] " : "[FILE] "
        puts "#{prefix}#{current_prefix}#{icon}#{entry}"
        
        if File.directory?(full_path) && depth < max_depth
          next_prefix = prefix + (is_last ? "    " : "│   ")
          display_tree(full_path, next_prefix, depth + 1, max_depth, show_hidden, dirs_only)
        end
      end
    end
    
    # Find first line difference between files
    def find_first_difference(content1, content2)
      [content1.length, content2.length].max.times do |i|
        return i + 1 if content1[i] != content2[i]
      end
      nil
    end
    
    # Simple compilation without interaction
    def simple_compile(source_file)
      unless File.exist?(source_file)
        puts "Source file not found: #{source_file}"
        return false
      end
      
      output_file = File.basename(source_file, File.extname(source_file))
      
      if system("gcc #{source_file} -o #{output_file}")
        puts "Compiled: #{source_file} -> #{output_file}"
        true
      else
        puts "Compilation failed"
        false
      end
    end
    
    # Interactive make REPL
    def make_repl(source_file)
      puts "=== C Compilation REPL ==="
      puts "Commands: compile, flags, clean, run, help, exit"
      
      @compile_flags = ""
      @output_name = File.basename(source_file, File.extname(source_file))
      
      loop do
        print "make> "
        command = gets.chomp.downcase.split
        
        case command[0]
        when 'compile', 'c'
          compile_with_flags(source_file)
        when 'flags', 'f'
          set_compile_flags
        when 'clean'
          clean_compiled_files
        when 'run', 'r'
          run_compiled_program
        when 'help', 'h'
          show_make_help
        when 'exit', 'e'
          break
        else
          puts "Unknown command: #{command[0]}"
        end
      end
    end
    
    def compile_with_flags(source_file)
      cmd = "gcc #{source_file} #{@compile_flags} -o #{@output_name}"
      puts "Executing: #{cmd}"
      
      if system(cmd)
        puts "Compilation successful"
      else
        puts "Compilation failed"
      end
    end
    
    def set_compile_flags
      print "Enter compile flags: "
      @compile_flags = gets.chomp
      puts "Flags set: #{@compile_flags}"
    end
    
    def clean_compiled_files
      if File.exist?(@output_name)
        File.delete(@output_name)
        puts "Cleaned: #{@output_name}"
      else
        puts "No compiled files to clean"
      end
    end
    
    def run_compiled_program
      if File.exist?(@output_name)
        system("./#{@output_name}")
      else
        puts "No compiled program found. Compile first."
      end
    end
    
    def show_make_help
      puts "\n=== Make REPL Commands ==="
      puts "compile (c) - Compile with current flags"
      puts "flags (f)   - Set compilation flags"
      puts "clean       - Remove compiled files"
      puts "run (r)     - Run compiled program"
      puts "help (h)    - Show this help"
      puts "exit (e)    - Exit make REPL"
      puts "=========================="
    end
    
    # Git management REPL
    def git_manager_repl
      puts "=== Git Manager REPL ==="
      puts "Commands: status, add, commit, push, pull, branch, log, help, exit"
      
      unless system("git rev-parse --git-dir > /dev/null 2>&1")
        puts "Not in a Git repository. Initialize? [Y/n]"
        if gets.chomp =~ /Y|y/
          system("git init")
        else
          return
        end
      end
      
      loop do
        print "git> "
        command = gets.chomp.split
        
        case command[0]
        when 'status', 's'
          system("git status")
        when 'add', 'a'
          if command[1]
            system("git add #{command[1..-1].join(' ')}")
          else
            system("git add .")
          end
        when 'commit', 'c'
          git_commit_interactive
        when 'push'
          system("git push")
        when 'pull'
          system("git pull")
        when 'branch', 'b'
          if command[1]
            system("git checkout -b #{command[1]}")
          else
            system("git branch")
          end
        when 'log', 'l'
          system("git log --oneline -10")
        when 'help', 'h'
          show_git_help
        when 'exit', 'e'
          break
        else
          puts "Unknown command: #{command[0]}"
        end
      end
    end
    
    def git_commit_interactive
      print "Commit message: "
      message = gets.chomp
      
      if message.empty?
        puts "Commit cancelled - no message provided"
      else
        system("git commit -m \"#{message}\"")
      end
    end
    
    def show_git_help
      puts "\n=== Git Manager Commands ==="
      puts "status (s)    - Show repository status"
      puts "add (a) [file]- Add files (default: add all)"
      puts "commit (c)    - Interactive commit"
      puts "push          - Push to remote"
      puts "pull          - Pull from remote"
      puts "branch (b)    - List or create branches"
      puts "log (l)       - Show recent commits"
      puts "help (h)      - Show this help"
      puts "exit (e)      - Exit git manager"
      puts "============================"
    end
    
    # USB device management
    def usb_manager_repl
      puts "=== USB Manager REPL ==="
      puts "Commands: list, mount, unmount, format, help, exit"
      
      loop do
        print "usb> "
        command = gets.chomp.downcase.split
        
        case command[0]
        when 'list', 'l'
          list_usb_devices
        when 'mount', 'm'
          mount_usb_device(command[1])
        when 'unmount', 'u'
          unmount_usb_device(command[1])
        when 'format', 'f'
          format_usb_device(command[1])
        when 'help', 'h'
          show_usb_help
        when 'exit', 'e'
          break
        else
          puts "Unknown command: #{command[0]}"
        end
      end
    end
    
    def list_usb_devices
      puts "=== Connected USB Devices ==="
      devices = `lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -E '(disk|part)'`.split("\n")
      
      if devices.empty?
        puts "No USB devices found"
      else
        devices.each { |device| puts device }
      end
    end
    
    def mount_usb_device(device)
      if device.nil?
        puts "Usage: mount <device> (e.g., mount sdb1)"
        return
      end
      
      mount_point = "/media/#{ENV['USER']}/#{device}"
      
      system("sudo mkdir -p #{mount_point}")
      
      if system("sudo mount /dev/#{device} #{mount_point}")
        puts "Mounted: /dev/#{device} -> #{mount_point}"
      else
        puts "Mount failed"
      end
    end
    
    def unmount_usb_device(device)
      if device.nil?
        puts "Usage: unmount <device> (e.g., unmount sdb1)"
        return
      end
      
      if system("sudo umount /dev/#{device}")
        puts "Unmounted: /dev/#{device}"
      else
        puts "Unmount failed"
      end
    end
    
    def format_usb_device(device)
      if device.nil?
        puts "Usage: format <device> (e.g., format sdb1)"
        return
      end
      
      print "Format /dev/#{device}? This will DESTROY ALL DATA! [y/N]: "
      confirmation = gets.chomp
      
      if confirmation.downcase == 'y'
        if system("sudo mkfs.ext4 /dev/#{device}")
          puts "Formatted: /dev/#{device} as ext4"
        else
          puts "Format failed"
        end
      else
        puts "Format cancelled"
      end
    end
    
    def show_usb_help
      puts "\n=== USB Manager Commands ==="
      puts "list (l)           - List USB devices"
      puts "mount (m) <device> - Mount USB device"
      puts "unmount (u) <dev>  - Unmount USB device"
      puts "format (f) <dev>   - Format USB device"
      puts "help (h)           - Show this help"
      puts "exit (e)           - Exit USB manager"
      puts "=========================="
    end
  end
end

# Usage examples:
# file_utils = RubianFileUtils::DynamicUtils.new
# file_utils.rubian_tree
# file_utils.rubian_find('*.rb')
# file_utils.rubian_git_manager
# file_utils.rubian_usb_manager
# file_utils.rubian_installer_generator
