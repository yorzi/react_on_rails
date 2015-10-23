module GeneratorHelper
  # Takes a relative path from the destination root, such as `.gitignore` or `app/assets/javascripts/application.js`
  def dest_file_exists?(file)
    File.exist?(File.join(destination_root, file)) ? file : nil
  end

  def dest_dir_exists?(dir)
    Dir.exist?(File.join(destination_root, dir)) ? file : nil
  end

  # Takes the missing file and the
  def puts_setup_file_error(file, data)
    msg = ""
    msg << "** #{file} was not found.\n"
    msg << "Please add the following content to your .gitignore file"
    msg << "file:\n\n#{data}\n\n"
    puts msg
  end

  def empty_directory_with_keep_file(destination, config = {})
    empty_directory(destination, config)
    keep_file(destination)
  end

  def keep_file(destination)
    create_file("#{destination}/.keep") unless options[:skip_keeps]
  end
end
