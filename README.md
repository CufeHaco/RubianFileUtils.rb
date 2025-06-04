# RubianFileUtils

A comprehensive file management and system utility gem that brings the power of Ruby to everyday system administration tasks.

[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.7-red.svg)](https://www.ruby-lang.org/)
[![Gem Version](https://badge.fury.io/rb/rubian_file_utils.svg)](https://badge.fury.io/rb/rubian_file_utils)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Philosophy

RubianFileUtils embodies the Ruby philosophy of making programming enjoyable and productive. Instead of relying on shell commands or external tools, it provides pure Ruby implementations of common file operations with modern, interactive interfaces.

**Core Principles:**
- **Ruby-Native**: Everything built with Ruby's standard library
- **Interactive**: REPL-style interfaces for complex workflows  
- **Clean APIs**: Simple method calls instead of command-line arguments
- **Performance-Aware**: Smart caching and efficient algorithms
- **Cross-Platform**: Works anywhere Ruby runs

## Quick Start

```ruby
gem install rubian_file_utils
```

```ruby
require 'rubian_file_utils'

# Initialize the utility suite
file_utils = RubianFileUtils::DynamicUtils.new
# => Scanning directory structure...
# => Cached 1,247 directories for fast file searching

# Explore your filesystem
file_utils.rubian_tree(max_depth: 2)
file_utils.rubian_find('*.rb')
file_utils.rubian_ls(detailed: true)

# Interactive git management
file_utils.rubian_git_manager

# Generate deployment scripts
file_utils.rubian_installer_generator
```

## Features

### 🚀 **Smart File Operations**
- Pattern-based file discovery with caching
- Recursive directory operations
- Safe file copying and moving
- Archive creation and extraction

### 🌳 **Visual Directory Navigation**
- Beautiful tree views with emojis
- Configurable depth and filtering
- Hidden file management
- Directory-only or full file listing

### 🔧 **Interactive Utilities**
- **Git Manager**: Complete git workflow in Ruby
- **USB Manager**: Device mounting and formatting
- **Make Utility**: C compilation with flags
- **Installer Generator**: Create deployment scripts

### 🛡️ **System Integration**
- File permission management
- Checksum generation (MD5, SHA1, SHA256)
- Cross-platform compatibility
- Graceful error handling

## Core Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `rubian_tree` | Visual directory structure | `file_utils.rubian_tree(max_depth: 3)` |
| `rubian_find` | Pattern-based file search | `file_utils.rubian_find('*.log')` |
| `rubian_copy` | File/directory copying | `file_utils.rubian_copy('src', 'backup')` |
| `rubian_hash` | File integrity checking | `file_utils.rubian_hash('file.txt', algorithm: :sha256)` |
| `rubian_git_manager` | Interactive git workflow | `file_utils.rubian_git_manager` |

## Interactive REPLs

### Git Manager
```ruby
file_utils.rubian_git_manager
# git> status
# git> add .
# git> commit
# Commit message: Add new feature
# git> push
```

### Installer Generator
```ruby
file_utils.rubian_installer_generator
# installer> create
# Project name: MyProject
# installer> generate
# ✓ Generated installer: myproject_installer.rb
```

### USB Manager
```ruby
file_utils.rubian_usb_manager
# usb> list
# usb> mount sdb1
# usb> format sdb1
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubian_file_utils'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install rubian_file_utils
```

## Requirements

- Ruby 2.7 or higher
- Standard Ruby libraries (fileutils, pathname, digest, json)
- Unix-like environment for USB/system utilities

## Development

After checking out the repo, run:

```bash
bin/setup
bundle exec rspec
```

To install this gem onto your local machine:

```bash
bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[username]/rubian_file_utils.

## Inspiration

This gem is inspired by the Rubian shell project - a Ruby-based shell replacement that prioritizes clean, intuitive interfaces over complex command-line syntax. The goal is to make system administration tasks feel natural to Ruby developers.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Created by the Rubian Project team. Bringing Ruby's elegance to system administration since 2019.

---

*"Make file management as enjoyable as writing Ruby code."* - The Rubian Philosophy# RubianFileUtils

A comprehensive file management and system utility gem that brings the power of Ruby to everyday system administration tasks.

[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.7-red.svg)](https://www.ruby-lang.org/)
[![Gem Version](https://badge.fury.io/rb/rubian_file_utils.svg)](https://badge.fury.io/rb/rubian_file_utils)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Philosophy

RubianFileUtils embodies the Ruby philosophy of making programming enjoyable and productive. Instead of relying on shell commands or external tools, it provides pure Ruby implementations of common file operations with modern, interactive interfaces.

**Core Principles:**
- **Ruby-Native**: Everything built with Ruby's standard library
- **Interactive**: REPL-style interfaces for complex workflows  
- **Clean APIs**: Simple method calls instead of command-line arguments
- **Performance-Aware**: Smart caching and efficient algorithms
- **Cross-Platform**: Works anywhere Ruby runs

## Quick Start

```ruby
gem install rubian_file_utils
```

```ruby
require 'rubian_file_utils'

# Initialize the utility suite
file_utils = RubianFileUtils::DynamicUtils.new
# => Scanning directory structure...
# => Cached 1,247 directories for fast file searching

# Explore your filesystem
file_utils.rubian_tree(max_depth: 2)
file_utils.rubian_find('*.rb')
file_utils.rubian_ls(detailed: true)

# Interactive git management
file_utils.rubian_git_manager

# Generate deployment scripts
file_utils.rubian_installer_generator
```

## Features

### 🚀 **Smart File Operations**
- Pattern-based file discovery with caching
- Recursive directory operations
- Safe file copying and moving
- Archive creation and extraction

### 🌳 **Visual Directory Navigation**
- Beautiful tree views with emojis
- Configurable depth and filtering
- Hidden file management
- Directory-only or full file listing

### 🔧 **Interactive Utilities**
- **Git Manager**: Complete git workflow in Ruby
- **USB Manager**: Device mounting and formatting
- **Make Utility**: C compilation with flags
- **Installer Generator**: Create deployment scripts

### 🛡️ **System Integration**
- File permission management
- Checksum generation (MD5, SHA1, SHA256)
- Cross-platform compatibility
- Graceful error handling

## Core Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `rubian_tree` | Visual directory structure | `file_utils.rubian_tree(max_depth: 3)` |
| `rubian_find` | Pattern-based file search | `file_utils.rubian_find('*.log')` |
| `rubian_copy` | File/directory copying | `file_utils.rubian_copy('src', 'backup')` |
| `rubian_hash` | File integrity checking | `file_utils.rubian_hash('file.txt', algorithm: :sha256)` |
| `rubian_git_manager` | Interactive git workflow | `file_utils.rubian_git_manager` |

## Interactive REPLs

### Git Manager
```ruby
file_utils.rubian_git_manager
# git> status
# git> add .
# git> commit
# Commit message: Add new feature
# git> push
```

### Installer Generator
```ruby
file_utils.rubian_installer_generator
# installer> create
# Project name: MyProject
# installer> generate
# ✓ Generated installer: myproject_installer.rb
```

### USB Manager
```ruby
file_utils.rubian_usb_manager
# usb> list
# usb> mount sdb1
# usb> format sdb1
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubian_file_utils'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install rubian_file_utils
```

## Requirements

- Ruby 2.7 or higher
- Standard Ruby libraries (fileutils, pathname, digest, json)
- Unix-like environment for USB/system utilities

## Development

After checking out the repo, run:

```bash
bin/setup
bundle exec rspec
```

To install this gem onto your local machine:

```bash
bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CufeHaco/rubian_file_utils.

## Inspiration

This gem is inspired by the Rubian shell project - a Ruby-based shell replacement that prioritizes clean, intuitive interfaces over complex command-line syntax. The goal is to make system administration tasks feel natural to Ruby developers.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Created by Troy Mallory. Bringing Ruby's elegance to system administration since 2016.

---

*"Make file management as enjoyable as writing Ruby code."* - The Rubian Philosophy
