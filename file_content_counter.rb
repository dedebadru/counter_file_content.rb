require 'digest'
require 'find'

module FileContentCounter
  # Method to calculate hash of a file in chunks to avoid memory overload
  def self.calculate_file_hash(file_path)
    digest = Digest::SHA256.new
    content = ''
    File.open(file_path, 'rb') do |file|
      # Read the file in chunks of 64KB to avoid memory overload with large files
      buffer = ''
      while file.read(64 * 1024, buffer)
        content += buffer
        digest.update(buffer)
      end
    end

    # return the hash of content with raw the content
    return digest.hexdigest, content
  end

  # Method to scan directory and return the most frequent file content
  def self.scan_directory(path)
    content_hash_map = Hash.new(0) # This will store content hash
    file_content_hash = Hash.new() # This will store raw content

    Find.find(path) do |file_path|
      next unless File.file?(file_path) # Ignore directories

      # Calculate the file content
      file_hash, content = calculate_file_hash(file_path)

      
      content_hash_map[file_hash] += 1 # Increase the count of files with the same content
      file_content_hash[file_hash] = content if file_content_hash[file_hash].nil? # Ignore set the content when the content has been set
    end

    # Find the most frequent content hash and its count
    most_frequent_content, max_count = content_hash_map.max_by { |_, count| count }

    # Return the content hash and the count of files with the same content
    most_frequent_file_content = file_content_hash[most_frequent_content]
    most_frequent_file_content = most_frequent_file_content.delete("\n") if most_frequent_file_content && !most_frequent_file_content.empty?
    return most_frequent_file_content, max_count
  end

  # Main execution method
  def self.execute(directory_path)
    if Dir.exist?(directory_path)
      content, count = scan_directory(directory_path)
      puts "#{content} #{count}"
    else
      puts "Error: Directory '#{directory_path}' does not exist."
    end
  end
end
