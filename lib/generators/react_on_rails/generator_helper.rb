module GeneratorHelper
  # Takes a relative path from the destination root, such as `.gitignore` or `app/assets/javascripts/application.js`
  def dest_file_exists?(file)
    File.exist?(File.join(destination_root, file)) ? file : nil
  end

  def dest_dir_exists?(dir)
    Dir.exist?(File.join(destination_root, dir)) ? dir : nil
  end

  # Takes the missing file and the
  def puts_setup_file_error(file, data)
    puts "** #{file} was not found.\nPlease add the following content to your #{file} file:\n\n#{data}\n\n"
  end

  def empty_directory_with_keep_file(destination, config = {})
    empty_directory(destination, config)
    keep_file(destination)
  end

  def keep_file(destination)
    create_file("#{destination}/.keep") unless options[:skip_keeps]
  end

  # As opposed to Rails::Generators::Testing.create_link, which creates a link pointing to
  # source_root, this symlinks a file in destination_root to a file also in
  # destination_root.
  def symlink_dest_file_to_dest_file(target, link)
    link_path = Pathname.new(File.join(destination_root, link))
    Dir.chdir(link_path.dirname) do
      target_file = File.join(destination_root, target)
      File.symlink(target_file, link_path.basename)
    end
  end

  def copy_file_and_missing_parent_directories(source_file, destination_file)
    destination_path = Pathname.new(destination_file)
    parent_directories = destination_path.dirname
    empty_directory(parent_directories) unless dest_dir_exists?(parent_directories)
    copy_file source_file, destination_file
  end
end
